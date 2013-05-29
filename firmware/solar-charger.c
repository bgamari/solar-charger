#include <libopencm3/stm32/rcc.h>
#include "usart.h"
#include "regulator.h"
#include "io_expander.h"

void handle_line_recv(const char* line, unsigned int length)
{
  usart_write(line, length);
}

int main(void)
{
  rcc_peripheral_enable_clock(&RCC_AHBENR, RCC_AHBENR_GPIOAEN);
  rcc_peripheral_enable_clock(&RCC_AHBENR, RCC_AHBENR_GPIOBEN);
  enable_io_expander();

  on_line_recv = handle_line_recv;
  configure_usart();
  usart_print("hello world!\n");

  //configure_ch1();
  //configure_ch2();
  return 0;
}
