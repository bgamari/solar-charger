#include <libopencm3/cm3/nvic.h>
#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/gpio.h>
#include <libopencm3/stm32/exti.h>
#include "usart.h"
#include "regulator.h"
#include "io_expander.h"

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
  gpio_mode_setup(GPIOA, GPIO_MODE_ANALOG, GPIO_PUPD_NONE, GPIO3 | GPIO4); // ADC pins
  gpio_mode_setup(GPIOA, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, GPIO5); // Vsense1 EN
  gpio_set_af(GPIOA, GPIO_AF2, GPIO5 | GPIO6);
  gpio_mode_setup(GPIOA, GPIO_MODE_AF, GPIO_PUPD_NONE, GPIO5 | GPIO6); // PWM pins

  // Regulator channel 2
  gpio_set_af(GPIOB, GPIO_AF2, GPIO8 | GPIO10);
  gpio_mode_setup(GPIOB, GPIO_MODE_AF, GPIO_PUPD_NONE, GPIO8 | GPIO10); // PWM pins
  gpio_mode_setup(GPIOB, GPIO_MODE_ANALOG, GPIO_PUPD_NONE,
                  GPIO12 | GPIO14 | GPIO15); // analog channels

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

  on_line_recv = handle_line_recv;
  configure_usart();
  while (true) {
  usart_print("hello world!\n");
  delay_ms(500);
  led7_on();
  delay_ms(500);
  led7_off();
  }

  //configure_ch1();
  //configure_ch2();
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
