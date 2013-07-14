#include <libopencm3/cm3/nvic.h>
#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/gpio.h>
#include <libopencm3/stm32/exti.h>

#include "clock.h"
#include "usart.h"
#include "regulator.h"
#include "io_expander.h"

#include <stdlib.h>
#include <string.h>
#include <libopencm3/stm32/timer.h>

const char* help_message = "TODO: help message\n";
static const char* const modes[] = {
  "disabled",
  "constant duty cycle",
  "constant current",
  "constant voltage",
  "maximum power"
};
  

char* itoa(char* str, unsigned int len, unsigned int val)
{
  unsigned int i;
  for (i=1; i <= len; i++) {
    str[len-i] = (val % 10) + '0';
    val /= 10;
  }

  str[i-1] = '\0';
  return &str[i-1];
}

char* fixed32_to_a(char* str, unsigned int len, fixed32_t val)
{
  return itoa(str, len, val);
  char* tmp = itoa(str, len, val>>16);
  tmp[0] = '.';
  //len -= (tmp - str) + 1; // FIXME length
  return itoa(&tmp[1], len, 0xffff & val);
}

void handle_line_recv(const char* line, unsigned int length)
{
  usart_write(line, length);
}

int init_buttons(void)
{
  exti_select_source(EXTI8, GPIOA); // Button 3
  exti_select_source(EXTI10, GPIOA); // Button 2
  exti_select_source(EXTI11, GPIOA); // Button 1

  exti_enable_request(EXTI8 | EXTI10 | EXTI11);
  exti_set_trigger(EXTI8 | EXTI10 | EXTI11, EXTI_TRIGGER_FALLING);
  nvic_enable_irq(NVIC_EXTI9_5_IRQ);
  nvic_enable_irq(NVIC_EXTI15_10_IRQ);
  return 0;
}

void init_pins(void)
{
  gpio_mode_setup(GPIOA, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, GPIO0); // LED7

  // Regulator channel 1
  gpio_mode_setup(GPIOA, GPIO_MODE_ANALOG, GPIO_PUPD_NONE, GPIO3 | GPIO4); // analog channels
  gpio_mode_setup(GPIOA, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, GPIO5); // Vsense1 EN

  gpio_set_af(GPIOB, GPIO_AF2, GPIO8); // PB8 = CH1_A = TIM4_CH3
  gpio_mode_setup(GPIOB, GPIO_MODE_AF, GPIO_PUPD_NONE, GPIO8);

  gpio_set_af(GPIOB, GPIO_AF1, GPIO10); // PB10 = CH1_B = TIM2_CH3
  gpio_mode_setup(GPIOB, GPIO_MODE_AF, GPIO_PUPD_NONE, GPIO10);

  // Regulator channel 2
  gpio_mode_setup(GPIOB, GPIO_MODE_ANALOG, GPIO_PUPD_NONE,
                  GPIO12 | GPIO14 | GPIO15); // analog channels

  gpio_set_af(GPIOA, GPIO_AF2, GPIO6); // PA6 = CH2_BATT = TIM3_CH1
  gpio_mode_setup(GPIOA, GPIO_MODE_AF, GPIO_PUPD_NONE, GPIO6);
  gpio_set_af(GPIOB, GPIO_AF2, GPIO0); // PB0 = CH2_PANEL = TIM3_CH3
  gpio_mode_setup(GPIOB, GPIO_MODE_AF, GPIO_PUPD_NONE, GPIO0);

  gpio_mode_setup(GPIOA, GPIO_MODE_INPUT, GPIO_PUPD_PULLUP,
                  GPIO8 | GPIO11 | GPIO12); // buttons pins

  gpio_set_af(GPIOA, GPIO_AF7, GPIO9 | GPIO10);
  gpio_mode_setup(GPIOA, GPIO_MODE_AF, GPIO_PUPD_NONE, GPIO9 | GPIO10); // USART1

  gpio_mode_setup(GPIOB, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, GPIO5); // LED driver enable
  gpio_set_af(GPIOB, GPIO_AF4, GPIO6 | GPIO7);
  gpio_mode_setup(GPIOB, GPIO_MODE_AF, GPIO_PUPD_PULLUP, GPIO6 | GPIO7); // LED driver I2C
}

void led7_off(void) { gpio_set(GPIOA, GPIO0); }
void led7_on(void) { gpio_clear(GPIOA, GPIO0); }

int main(void)
{
  PWR_CR = (PWR_CR & ~(0x7 << 5)) | (0x6 << 5) | PWR_CR_PVDE; // PVD = 3.1V
  exti_enable_request(EXTI16); // PVD interrupt
  init_systick();

  rcc_peripheral_enable_clock(&RCC_AHBENR, RCC_AHBENR_GPIOAEN);
  rcc_peripheral_enable_clock(&RCC_AHBENR, RCC_AHBENR_GPIOBEN);

  init_pins();
  init_buttons();

  // cycle through LEDs
  for (int i=0; i<7; i++) {
    set_led(i, led_on);
    delay_ms(100);
    set_led(i, led_off);
  }
    
  for (int i=0; i<3; i++) {
    led7_on();
    delay_ms(100);
    led7_off();
    delay_ms(100);
  }

  regulator_init();
  regulator_set_mode(&chan2, CONST_DUTY);
  regulator_set_duty_cycle(&chan2, 0.6, 0.5);
  //gpio_mode_setup(GPIOB, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, GPIO10);
  //gpio_clear(GPIOB, GPIO10);

  on_line_recv = handle_line_recv;
  configure_usart();
  usart_print("hello world!\n");

  char cmd[256];
  struct regulator_t* reg = &chan1;
  while (true) {
    usart_print("> ");
    usart_readline(cmd, 256);
    if (cmd[0] == 'd') {
      uint32_t duty = strtol(&cmd[1], NULL, 10);
      if (duty > 0xffff*3/4) {
        strcpy(cmd, "error\n");
      } else {
        regulator_set_duty_cycle(reg, duty, duty);
        strcpy(cmd, "duty = ");
        itoa(&cmd[6], 10, duty);
        strcat(cmd, "\n");
      }
    } else if (cmd[0] == 'p') {
      uint32_t period = strtol(&cmd[1], NULL, 10);
      regulator_set_mode(reg, DISABLED);
      regulator_set_period(reg, period);
      regulator_set_mode(reg, CONST_DUTY);
      strcpy(cmd, "freq = ");
      itoa(&cmd[6], 10, period);
      strcat(cmd, "\n");
    } else if (cmd[0] == 'v') {
      fixed32_t vsense = regulator_get_vsense(reg);
      strcpy(cmd, "vsense = ");
      fixed32_to_a(&cmd[8], 10, vsense);
      strcat(cmd, "\n");
    } else if (cmd[0] == 'i') {
      fixed32_t isense = regulator_get_isense(reg);
      strcpy(cmd, "isense = ");
      fixed32_to_a(&cmd[8], 10, isense);
      strcat(cmd, "\n");
    } else if (cmd[0] == 'r') {
      reg = cmd[1] == '1' ? &chan1 : &chan2;
      strcpy(cmd, "channel ");
      strcat(cmd, reg == &chan1 ? "1" : "2");
      strcat(cmd, " selected\n");
    } else if (cmd[0] == 'm') {
      enum feedback_mode mode = regulator_get_mode(reg);
      bool set = true;
      if (cmd[1] == 'p') {
        mode = MAX_POWER;
      } else if (cmd[1] == 'd') {
        mode = DISABLED;
      } else if (cmd[1] == 'i') {
        mode = CURRENT_FB;
      } else if (cmd[1] == 'v') {
        mode = VOLTAGE_FB;
      } else if (cmd[1] == 'D') {
        mode = CONST_DUTY;
      } else {
        set = false;
      }

      if (set) {
        regulator_set_mode(reg, mode);
      }

      strcpy(cmd, "mode = ");
      strcat(cmd, modes[mode]);
      strcat(cmd, "\n");
    } else if (cmd[0] == 'm' && cmd[1] == 'v') {
      strcpy(cmd, "constant voltage mode\n");
      regulator_set_mode(reg, VOLTAGE_FB);
    } else if (cmd[0] == 'm' && cmd[1] == 'i') {
      strcpy(cmd, "constant current mode\n");
      regulator_set_mode(reg, CURRENT_FB);
    } else if (cmd[0] == 'm' && cmd[1] == 'd') {
      strcpy(cmd, "constant duty cycle\n");
      regulator_set_mode(reg, CONST_DUTY);
    } else if (cmd[0] == 'm') {
      strcpy(cmd, "channel disabled\n");
      regulator_set_mode(reg, DISABLED);
    } else if (cmd[0] == '?') {
      cmd[0] = '\0';
      usart_print(help_message);
    } else {
      strcpy(cmd, "error\n");
    }

    usart_print(cmd);
  }

  while(true) {}
}

void button1_pressed(void) { }
void button2_pressed(void) { }
void button3_pressed(void) { }
void pvd_tripped(void) { }

void exti9_5_isr(void)
{
  if (exti_get_flag_status(EXTI8))
    button3_pressed();
  EXTI_PR |= EXTI8;
}

void exti15_10_isr(void)
{
  if (exti_get_flag_status(EXTI10))
    button2_pressed();
  else if (exti_get_flag_status(EXTI11))
    button1_pressed();
  else if (exti_get_flag_status(EXTI16))
    pvd_tripped();
  EXTI_PR |= EXTI10 | EXTI11;
}
