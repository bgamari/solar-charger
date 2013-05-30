#include <libopencm3/stm32/timer.h>
#include <libopencm3/stm32/rcc.h>
#include "regulator.h"

const u8 ch1_enabled = 0x1;
const u8 ch2_enabled = 0x2;

static u8 reg_state = 0;

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
 *   TIM6:   ADC trigger
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
  if (reg_state == 0) {
    rcc_peripheral_disable_clock(&RCC_APB1ENR, RCC_APB1ENR_TIM6EN);
    rcc_peripheral_disable_clock(&RCC_APB1ENR, RCC_APB2ENR_ADC1EN);
  } else {
    rcc_peripheral_enable_clock(&RCC_APB1ENR, RCC_APB1ENR_TIM6EN);
    rcc_peripheral_enable_clock(&RCC_APB1ENR, RCC_APB2ENR_ADC1EN);
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

/*
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
int configure_ch1(u32 period, u32 ta, u32 tb, u32 dt)
{
  u32 timer_a = TIM2; enum tim_oc_id oc_a = TIM_OC3;
  u32 timer_b = TIM4; enum tim_oc_id oc_b = TIM_OC3;
  u32 slave_trigger_src = TIM_SMCR_TS_ITR0; /// FIXME

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

void enable_ch1()
{
  rcc_peripheral_enable_clock(&RCC_APB1ENR, RCC_APB1ENR_TIM2EN);
  rcc_peripheral_enable_clock(&RCC_APB1ENR, RCC_APB1ENR_TIM4EN);
  reg_state |= ch1_enabled;
  setup_common_peripherals();
}

void disable_ch1(void)
{
  rcc_peripheral_disable_clock(&RCC_APB1ENR, RCC_APB1ENR_TIM2EN);
  rcc_peripheral_disable_clock(&RCC_APB1ENR, RCC_APB1ENR_TIM4EN);
  reg_state &= ~ch1_enabled;
  setup_common_peripherals();
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

