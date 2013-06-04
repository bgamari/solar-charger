#include <libopencm3/stm32/gpio.h>
#include <libopencm3/stm32/timer.h>
#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/l1/adc.h>
#include "regulator.h"

static u8 reg_state = 0;
static const u8 ch1_enabled = 0x1;
static const u8 ch2_enabled = 0x2;

static const u32 vsense1_ch = ADC_CHANNEL5;
static const u32 isense1_ch = ADC_CHANNEL3;
static const u32 vsense2_ch = ADC_CHANNEL21;
static const u32 isense2_ch = ADC_CHANNEL20;

typedef unsigned long fixed_u32;

enum feedback_mode {
  current_fb, voltage_fb
};

struct regulator_t {
  u16 isense;
  u16 vsense;
  u32 duty1;
  u32 duty2;
  u32 vsense_gain; // codepoints per volt
  u32 isense_gain; // codepoints per amp
  enum feedback_mode mode;
  u16 vsetpoint, isetpoint;
  u16 max_v, max_i;
};

struct regulator_t chan1 = {
  .mode = current_fb,
  .vsense_gain = (1<<12) / (3.3 * 33/(33+68)),
  .isense_gain = (1<<12) * (3.3 / 0.05 / 100),
  .max_v = 0xffff,
  .max_i = 0xffff,
};

struct regulator_t chan2 = {
  .mode = voltage_fb,
  .vsense_gain = (1<<12) / (3.3 * 33/(33+68)),
  .isense_gain = (1<<12) / (3.3 / 0.05 / 50),
  .max_v = 0xffff,
  .max_i = 0xffff,
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

  if (reg_state == 0x0) {
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

int configure_ch1(u32 period, u32 ta, u32 tb, u32 dt)
{
  return configure_dual_pwm(TIM2, TIM_OC3,
                            TIM4, TIM_OC3,
                            TIM_SMCR_TS_ITR0,
                            period, ta, tb, dt);
}

void enable_ch1(void)
{
  rcc_peripheral_enable_clock(&RCC_APB1ENR, RCC_APB1ENR_TIM2EN);
  rcc_peripheral_enable_clock(&RCC_APB1ENR, RCC_APB1ENR_TIM4EN);
  reg_state |= ch1_enabled;
  setup_common_peripherals();
  set_vsense1_en(true);
}

void disable_ch1(void)
{
  rcc_peripheral_disable_clock(&RCC_APB1ENR, RCC_APB1ENR_TIM2EN);
  rcc_peripheral_disable_clock(&RCC_APB1ENR, RCC_APB1ENR_TIM4EN);
  reg_state &= ~ch1_enabled;
  setup_common_peripherals();
  set_vsense1_en(false);
}

static void configure_ch2(void)
{
}
 
void enable_ch2(void)
{
  rcc_peripheral_enable_clock(&RCC_APB1ENR, RCC_APB1ENR_TIM3EN);
  reg_state |= ch2_enabled;
  setup_common_peripherals();
}

void disable_ch2(void)
{
  rcc_peripheral_disable_clock(&RCC_APB1ENR, RCC_APB1ENR_TIM3EN);
  reg_state &= ~ch2_enabled;
  setup_common_peripherals();
}

void adc_jeoc_irqhandler(void)
{
  ADC1_SR &= ~ADC_SR_JEOC;
  chan1.vsense = adc_read_injected(ADC1, ADC1_JDR1);
  chan1.isense = adc_read_injected(ADC1, ADC1_JDR2);
  chan2.vsense = adc_read_injected(ADC1, ADC1_JDR3);
  chan2.isense = adc_read_injected(ADC1, ADC1_JDR4);
}
