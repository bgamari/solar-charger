#include <libopencm3/stm32/gpio.h>
#include <libopencm3/stm32/timer.h>
#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/l1/adc.h>
#include <libopencm3/cm3/nvic.h>

#include "regulator.h"

static const u32 vsense1_ch = ADC_CHANNEL5;
static const u32 isense1_ch = ADC_CHANNEL3;
static const u32 vsense2_ch = ADC_CHANNEL21;
static const u32 isense2_ch = ADC_CHANNEL20;

static enum tim_oc_id ch2_oc = TIM_OC3;

/*
 * This ties together the various parameters needed by a single
 * channel feedback loop. 
 */
struct regulator_t {
  uint32_t vsense_gain; // codepoints per volt
  uint32_t isense_gain; // codepoints per amp
  uint32_t period; // period in cycles
  fract32_t duty1;
  fract32_t duty2;
  uint16_t isense; // current in codepoints
  uint16_t vsense; // voltage in codepoints
  enum feedback_mode mode;
  uint16_t isetpoint, vlimit; // in codepoints, only used in current_fb mode
  uint16_t vsetpoint, ilimit; // in codepoints, only used in voltage_fb mode
  void (*enable_func)(void);
  int (*configure_func)(void);
  void (*disable_func)(void);
};

static void enable_ch1(void);
static int configure_ch1(void);
static void disable_ch1(void);

struct regulator_t chan1 = {
  .period = 2000000 / 10000,
  .mode = CURRENT_FB,
  .vsense_gain = (1<<12) / (3.3 * 33/(33+68)),
  .isense_gain = (1<<12) * (3.3 / 0.05 / 100),
  .vlimit = 0xffff,
  .ilimit = 0xffff,
  .enable_func = enable_ch1,
  .configure_func = configure_ch1,
  .disable_func = disable_ch1
};

static void enable_ch2(void);
static int configure_ch2(void);
static void disable_ch2(void);

struct regulator_t chan2 = {
  .period = 2000000 / 5000,
  .mode = VOLTAGE_FB,
  .vsense_gain = (1<<12) / (3.3 * 33/(33+68)),
  .isense_gain = (1<<12) / (3.3 / 0.05 / 50),
  .vlimit = 0xffff,
  .ilimit = 0xffff,
  .enable_func = enable_ch2,
  .configure_func = configure_ch2,
  .disable_func = disable_ch2
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
 *   TIM7:   ADC trigger
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

  if (chan1.mode == DISABLED && chan2.mode == DISABLED) {
    if (RCC_APB2ENR & RCC_APB2ENR_ADC1EN)
      adc_off(ADC1);
    rcc_peripheral_disable_clock(&RCC_APB1ENR, RCC_APB1ENR_TIM7EN);
    rcc_peripheral_disable_clock(&RCC_APB2ENR, RCC_APB2ENR_ADC1EN);
    rcc_osc_off(HSI);
  } else {
    // ADCCLK is derived from HSI
    rcc_osc_on(HSI);
    rcc_wait_for_osc_ready(HSI);

    rcc_peripheral_enable_clock(&RCC_APB1ENR, RCC_APB1ENR_TIM7EN);
    rcc_peripheral_enable_clock(&RCC_APB2ENR, RCC_APB2ENR_ADC1EN);

    nvic_enable_irq(NVIC_ADC1_IRQ);
    adc_enable_external_trigger_injected(ADC1, ADC_CR2_JEXTEN_RISING,
                                         ADC_CR2_JEXTSEL_TIM7_TRGO);
    adc_set_sample_time_on_all_channels(ADC1, ADC_SMPR_SMP_48CYC);
    //adc_set_resolution(ADC1, ADC_CR1_RES_12BIT);
    adc_enable_eoc_interrupt_injected(ADC1);
    adc_set_clk_prescale(ADC_CCR_ADCPRE_DIV4);
    adc_set_injected_sequence(ADC1, 4, sequence);
    adc_enable_scan_mode(ADC1);
    adc_power_on(ADC1);
    while (!(ADC1_SR & ADC_SR_ADONS));
    while (ADC1_SR & ADC_SR_JCNR);

    timer_reset(TIM7);
    timer_continuous_mode(TIM7);
    timer_set_prescaler(TIM7, 0x1);
    timer_set_period(TIM7, 2000000 / 1000);
    timer_set_master_mode(TIM7, TIM_CR2_MMS_UPDATE);
    timer_enable_counter(TIM7);
  }
}

static void set_pwm_duty(u32 timer, enum tim_oc_id oc, uint32_t period, fract32_t d)
{
  uint32_t t = ((uint64_t) d * period) >> 32;
  timer_set_oc_value(timer, oc, t);
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
static int configure_pwm(u32 timer, enum tim_oc_id oc,
                         u32 period, bool pol, u32 t)
{
  timer_reset(timer);
  timer_continuous_mode(timer);

  timer_set_oc_mode(timer, oc, pol ? TIM_OCM_PWM1 : TIM_OCM_PWM2);
  timer_set_oc_value(timer, oc, t);
  timer_enable_oc_preload(timer, oc);
  timer_enable_oc_output(timer, oc);

  timer_set_mode(timer, TIM_CR1_CKD_CK_INT, TIM_CR1_CMS_CENTER_3, TIM_CR1_DIR_UP);
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
static int configure_dual_pwm(u32 timer_a, enum tim_oc_id oc_a,
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

static int configure_ch1(void)
{
  uint32_t dt = 0x10;
  uint32_t ta = ((uint64_t) chan1.period * chan1.duty1) >> 32;
  uint32_t tb = ((uint64_t) chan1.period * chan1.duty2) >> 32;
  return configure_dual_pwm(TIM2, TIM_OC3,
                            TIM4, TIM_OC3,
                            TIM_SMCR_TS_ITR0,
                            chan1.period, ta, tb, dt);
}

static void enable_ch1(void)
{
  set_vsense1_en(true);
  rcc_peripheral_enable_clock(&RCC_APB1ENR, RCC_APB1ENR_TIM2EN);
  rcc_peripheral_enable_clock(&RCC_APB1ENR, RCC_APB1ENR_TIM4EN);
  setup_common_peripherals();
}

static void disable_ch1(void)
{
  timer_disable_counter(TIM2);
  timer_disable_counter(TIM4);
  rcc_peripheral_disable_clock(&RCC_APB1ENR, RCC_APB1ENR_TIM2EN);
  rcc_peripheral_disable_clock(&RCC_APB1ENR, RCC_APB1ENR_TIM4EN);
  setup_common_peripherals();
  set_vsense1_en(false);
}

static void feedback_ch1(void)
{
  if (chan1.mode == DISABLED) {
    return;
  } else if (chan1.mode == VOLTAGE_FB) {
    if (chan1.isense > chan1.ilimit) {
      chan1.duty1 /= 2;
      chan1.duty2 /= 2;
    } else {
      int32_t error = chan1.vsense - chan1.vsetpoint;
      fixed32_t p1_gain = 0x10;
      fixed32_t p2_gain = 0x10;
      chan1.duty1 += ((uint64_t) error * p1_gain) >> 32;
      chan1.duty2 += ((uint64_t) error * p2_gain) >> 32;
    }
  } else if (chan1.mode == CURRENT_FB) {
    if (chan1.vsense > chan1.vlimit) {
      chan1.duty1 /= 2;
      chan1.duty2 /= 2;
    } else {
      int32_t error = chan1.isense - chan1.isetpoint;
      fixed32_t p1_gain = 0x10;
      fixed32_t p2_gain = 0x10;
      chan1.duty1 += ((uint64_t) error * p1_gain) >> 32;
      chan1.duty2 += ((uint64_t) error * p2_gain) >> 32;
    }
  }

  set_pwm_duty(TIM2, TIM_OC3, chan1.period, chan1.duty1);
  set_pwm_duty(TIM4, TIM_OC3, chan1.period, chan1.duty2);
}

void regulator_set_ch2_source(enum ch2_source_t src)
{
  ch2_oc = (src == BATTERY) ? TIM_OC1 : TIM_OC3;
  configure_ch2();
}

static int configure_ch2()
{
  uint32_t t = chan2.period * chan2.duty1 / 0xffff;
  timer_disable_oc_output(TIM3, TIM_OC1);
  timer_disable_oc_output(TIM3, TIM_OC3);
  int ret = configure_pwm(TIM3, ch2_oc, chan2.period, true, t);
  if (ret) return ret;
  timer_enable_counter(TIM3);
  return 0;
}
 
static void enable_ch2(void)
{
  rcc_peripheral_enable_clock(&RCC_APB1ENR, RCC_APB1ENR_TIM3EN);
  setup_common_peripherals();
}

static void disable_ch2(void)
{
  timer_disable_counter(TIM3);
  rcc_peripheral_disable_clock(&RCC_APB1ENR, RCC_APB1ENR_TIM3EN);
  setup_common_peripherals();
}

static void feedback_ch2(void)
{
  if (chan2.mode == DISABLED) {
    return;
  } else if (chan2.mode == CONST_DUTY) {
    return;
  } else if (chan2.mode == VOLTAGE_FB) {
    if (chan2.isense > chan2.ilimit) {
      chan2.duty1 /= 2;
    } else {
      int32_t error = chan2.vsense - chan2.vsetpoint;
      fixed32_t p1_gain = 0x10;
      chan2.duty1 += ((uint64_t) error * p1_gain) >> 32;
    }
  } else if (chan2.mode == CURRENT_FB) {
    if (chan2.vsense > chan1.vlimit) {
      chan2.duty1 /= 2;
    } else {
      int32_t error = chan2.isense - chan2.isetpoint;
      fixed32_t p1_gain = 0x10;
      chan2.duty1 += ((uint64_t) error * p1_gain) >> 32;
    }
  }

  chan2.duty1 = 0xffff & chan2.duty1;
  set_pwm_duty(TIM2, TIM_OC3, chan2.period, chan2.duty1);
}

void adc1_isr(void)
{
  ADC1_SR &= ~ADC_SR_JEOC;
  chan1.vsense = adc_read_injected(ADC1, ADC1_JDR1);
  chan1.isense = adc_read_injected(ADC1, ADC1_JDR2);
  chan2.vsense = adc_read_injected(ADC1, ADC1_JDR3);
  chan2.isense = adc_read_injected(ADC1, ADC1_JDR4);
  feedback_ch1();
  feedback_ch2();
}

int regulator_set_mode(struct regulator_t *reg, enum feedback_mode mode)
{
  int ret;
  enum feedback_mode old_mode = reg->mode;

  reg->mode = mode;
  if (old_mode == DISABLED && mode != DISABLED)
    reg->enable_func();
  else if (mode == DISABLED)
    reg->disable_func();

  if (mode != DISABLED) {
    ret = reg->configure_func();
    if (ret != 0) return ret;
  }

  return 0;
}

int regulator_set_duty_cycle(struct regulator_t *reg, fract32_t d1, fract32_t d2)
{
  if (reg->mode != CONST_DUTY)
    return 1;
  reg->duty1 = d1;
  reg->duty2 = d2;
  reg->configure_func();
  return 0;
}

int regulator_set_vsetpoint(struct regulator_t *reg, fract32_t setpoint)
{
  uint16_t v = ((uint32_t) (reg->vsense_gain * setpoint) >> 16);
  if (v > reg->vlimit) return 1;
  reg->vsetpoint = v;
  return 0;
}

int regulator_set_isetpoint(struct regulator_t *reg, fract32_t setpoint)
{
  uint16_t i = ((uint32_t) (reg->isense_gain * setpoint) >> 16);
  if (i > reg->ilimit) return 1;
  reg->isetpoint = i;
  return 0;
}

void regulator_init(void)
{
  regulator_set_mode(&chan1, DISABLED);
  regulator_set_mode(&chan2, DISABLED);
}

int regulator_set_period(struct regulator_t *reg, unsigned int period)
{
  if (reg->mode != DISABLED)
    return -1;
  reg->period = period;
  return 0;
}
