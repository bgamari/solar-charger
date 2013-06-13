#include <libopencm3/stm32/gpio.h>
#include <libopencm3/stm32/timer.h>
#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/l1/adc.h>
#include "regulator.h"

static const u32 vsense1_ch = ADC_CHANNEL5;
static const u32 isense1_ch = ADC_CHANNEL3;
static const u32 vsense2_ch = ADC_CHANNEL21;
static const u32 isense2_ch = ADC_CHANNEL20;

typedef unsigned long fixed32; // 16.16 fixed point
typedef unsigned long fixedn32; // 0.32 fixed point

enum feedback_mode {
  current_fb, voltage_fb, power_fb
};

/*
 * This ties together the various parameters needed by a single
 * channel feedback loop. 
 */
struct regulator_t {
  bool enabled;
  uint32_t vsense_gain; // codepoints per volt
  uint32_t isense_gain; // codepoints per amp
  uint32_t period;
  fixedn32 duty1;
  fixedn32 duty2;
  uint16_t isense;
  uint16_t vsense;
  enum feedback_mode mode;
  uint16_t vsetpoint, vlimit; // in codepoints, only used in current_fb mode
  uint16_t isetpoint, ilimit; // in codepoints, only used in voltage_fb mode
};

struct regulator_t chan1 = {
  .period = 0xf000,
  .mode = current_fb,
  .vsense_gain = (1<<12) / (3.3 * 33/(33+68)),
  .isense_gain = (1<<12) * (3.3 / 0.05 / 100),
  .vlimit = 0xffff,
  .ilimit = 0xffff,
};

struct regulator_t chan2 = {
  .period = 0xf000,
  .mode = voltage_fb,
  .vsense_gain = (1<<12) / (3.3 * 33/(33+68)),
  .isense_gain = (1<<12) / (3.3 / 0.05 / 50),
  .vlimit = 0xffff,
  .ilimit = 0xffff,
};

static void set_vsense1_en(bool enabled)
{
  if (enabled) {
    gpio_set(GPIOA, GPIO5);
  } else
    gpio_clear(GPIOA, GPIO5);
}

/*
 * Switching voltage regulator core
 *
 * This is the logic for driving the two switching regulator channels.
 * Channel 1 is a buck-boost regulator with both current and voltage sensing.
 * Channel 2 is a buck regulator with only voltage sensing.
 * 
 *  == Common peripherals ==
 *
 *   ADC1:   Sample voltages and current sense
 *   TIM9:   ADC trigger
 *   GPIOA:  MOSFET driver enable
 * 
 *  == Channel 1 peripherals ==
 *
 *   TIM2:   Buck regulator switch PWM
 *   TIM4:   Boost regulator switch PWM
 *
 *  == Channel 2 peripherals ==
 *
 *   TIM3:   Buck regulator switch PWM
 *
 */

static void setup_common_peripherals(void)
{
  u8 sequence[] = { vsense1_ch, isense1_ch, vsense2_ch, isense2_ch };

  if (!chan1.enabled && !chan2.enabled) {
    rcc_peripheral_disable_clock(&RCC_APB1ENR, RCC_APB2ENR_TIM9EN);
    rcc_peripheral_disable_clock(&RCC_APB1ENR, RCC_APB2ENR_ADC1EN);
  } else {
    rcc_peripheral_enable_clock(&RCC_APB1ENR, RCC_APB2ENR_TIM9EN);
    rcc_peripheral_enable_clock(&RCC_APB1ENR, RCC_APB2ENR_ADC1EN);

    adc_power_on(ADC1);
    adc_enable_external_trigger_injected(ADC1, ADC_CR2_JEXTEN_RISING,
                                         ADC_CR2_JEXTSEL_TIM9_TRGO);
    adc_set_sample_time_on_all_channels(ADC1, ADC_SMPR_SMP_48CYC);
    //adc_set_resolution(ADC1, ADC_CR1_RES_12BIT);
    adc_enable_eoc_interrupt_injected(ADC1);
    adc_set_clk_prescale(ADC_CCR_ADCPRE_DIV4);
    adc_set_injected_sequence(ADC1, 4, sequence);
  }
}

/* Configure center-aligned PWM output
 *
 *           period
 *   ╭────────────────────╮
 *       t
 *   ╭────────╮
 * 1 ┌────────┐          
 * 0 ┘        └───────────┘
 * 
 * pol = 1
 */
int configure_pwm(u32 timer, enum tim_oc_id oc, u32 period, bool pol, u32 t)
{
  timer_reset(timer);
  timer_continuous_mode(timer);

  timer_set_oc_mode(timer, oc, pol ? TIM_OCM_PWM1 : TIM_OCM_PWM2);
  timer_set_oc_value(timer, oc, t);
  timer_enable_oc_preload(timer, oc);
  timer_enable_oc_output(timer, oc);

  timer_set_mode(timer, 8, TIM_CR1_CMS_CENTER_3, TIM_CR1_DIR_UP);
  timer_enable_preload(timer);
  timer_set_period(timer, period);
  timer_generate_event(timer, TIM_EGR_UG);

  return 0;
}

/* Configure two center-aligned PWM outputs with a relative phase.
 *
 *             period
 *      ╭────────────────────╮
 * 
 *        ta
 *      ╭────────╮
 *    1 ┌────────┐          
 * A: 0 ┘        └───────────┘
 *
 *    1    ┌──┐               
 * B: 0 ───┘  └───────────────
 *
 *         ╰──╯
 *          tb
 *      ╰──╯  
 *       dt   
 */
int configure_dual_pwm(u32 timer_a, enum tim_oc_id oc_a,
                       u32 timer_b, enum tim_oc_id oc_b,
                       u32 slave_trigger_src,
                       u32 period, u32 ta, u32 tb, u32 dt)
{

  // Configure PWMs independently
  configure_pwm(timer_a, oc_a, period, 1, ta);
  configure_pwm(timer_b, oc_b, period, 1, tb);

  // Setup A in master mode
  timer_set_master_mode(timer_a, TIM_CR2_MMS_ENABLE);
  timer_slave_set_mode(timer_a, TIM_SMCR_MSM);

  // Setup B in trigger slave mode
  timer_slave_set_mode(timer_b, TIM_SMCR_SMS_TM);
  timer_slave_set_trigger(timer_b, slave_trigger_src);

  // Configure offset
  timer_set_period(timer_a, period - dt);
  timer_generate_event(timer_a, TIM_EGR_UG);
  timer_set_period(timer_a, period);

  timer_enable_counter(timer_a);
  return 0;
}

void set_pwm_duty(u32 timer, enum tim_oc_id oc, u32 t)
{
  timer_set_oc_value(timer, oc, t);
}

int configure_ch1(u32 dt)
{
  uint32_t ta = chan1.period * chan1.duty1 / 0xffff;
  uint32_t tb = chan1.period * chan1.duty2 / 0xffff;
  return configure_dual_pwm(TIM2, TIM_OC3,
                            TIM4, TIM_OC3,
                            TIM_SMCR_TS_ITR0,
                            chan1.period, ta, tb, dt);
}

void enable_ch1(void)
{
  chan1.enabled = true;
  set_vsense1_en(true);
  rcc_peripheral_enable_clock(&RCC_APB1ENR, RCC_APB1ENR_TIM2EN);
  rcc_peripheral_enable_clock(&RCC_APB1ENR, RCC_APB1ENR_TIM4EN);
  setup_common_peripherals();
}

void disable_ch1(void)
{
  chan1.enabled = false;
  timer_disable_counter(TIM2);
  timer_disable_counter(TIM4);
  rcc_peripheral_disable_clock(&RCC_APB1ENR, RCC_APB1ENR_TIM2EN);
  rcc_peripheral_disable_clock(&RCC_APB1ENR, RCC_APB1ENR_TIM4EN);
  setup_common_peripherals();
  set_vsense1_en(false);
}

static void feedback_ch1(void)
{
  if (chan1.mode == voltage_fb) {
    if (chan1.isense > chan1.ilimit) {
      chan1.duty1 /= 2;
      chan1.duty2 /= 2;
    } else {
      s32 error = chan1.vsense - chan1.vsetpoint;
      u32 p1_gain = 0x10;
      u32 p2_gain = 0x10;
      chan1.duty1 += error * p1_gain / 0xffff;
      chan1.duty2 += error * p2_gain / 0xffff;
    }
  } else {
    if (chan1.vsense > chan1.vlimit) {
      chan1.duty1 /= 2;
      chan1.duty2 /= 2;
    } else {
      s32 error = chan1.isense - chan1.isetpoint;
      u32 p1_gain = 0x10;
      u32 p2_gain = 0x10;
      chan1.duty1 += error * p1_gain / 0xffff;
      chan1.duty2 += error * p2_gain / 0xffff;
    }
  }

  set_pwm_duty(TIM2, TIM_OC3, chan1.duty1);
  set_pwm_duty(TIM4, TIM_OC3, chan1.duty2);
}

int configure_ch2(bool battery)
{
  enum tim_oc_id src = battery ? TIM_OC1 : TIM_OC3;
  uint32_t t = chan2.period * chan2.duty1 / 0xffff;
  return configure_pwm(TIM2, src, chan2.period, true, t);
}
 
void enable_ch2(void)
{
  chan2.enabled = true;
  rcc_peripheral_enable_clock(&RCC_APB1ENR, RCC_APB1ENR_TIM3EN);
  setup_common_peripherals();
}

void disable_ch2(void)
{
  chan2.enabled = false;
  timer_disable_counter(TIM3);
  rcc_peripheral_disable_clock(&RCC_APB1ENR, RCC_APB1ENR_TIM3EN);
  setup_common_peripherals();
}

void adc_jeoc_irqhandler(void)
{
  ADC1_SR &= ~ADC_SR_JEOC;
  chan1.vsense = adc_read_injected(ADC1, ADC1_JDR1);
  chan1.isense = adc_read_injected(ADC1, ADC1_JDR2);
  chan2.vsense = adc_read_injected(ADC1, ADC1_JDR3);
  chan2.isense = adc_read_injected(ADC1, ADC1_JDR4);
  feedback_ch1();
}
