#include "usart.h"
#include "regulator.h"

void handle_line_recv(const char* line, unsigned int length)
{
  usart_write(line, length);
}

int main(void)
{
  rcc_peripheral_disable_clock(&RCC_AHBENR, RCC_AHNENR_GPIOBEN);
  on_line_recv = handle_line_recv;
  configure_usart();
  //configure_ch1();
  //configure_ch2();
  return 0;
}
