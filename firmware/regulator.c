#include <libopencm3/stm32/timer.h>
#include "regulator.h"

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

void enable_regulator()
{
  rcc_peripheral_enable_clock();
}

static void configure_ch2(void)
{
}
 
