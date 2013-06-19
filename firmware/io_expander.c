// I2C interface to TCA6057
#include "io_expander.h"
#include "clock.h"
#include <libopencm3/stm32/i2c.h>
#include <libopencm3/stm32/gpio.h>
#include <libopencm3/stm32/rcc.h>

const u8 expander_addr = 0x45;
const u32 expander_en_port = GPIOB;
const u32 expander_en_pin = GPIO5;

static u8 shadow[3] = {0,0,0};

static bool enabled = false;

static void update_leds(void);

static void enable_io_expander(void)
{
  if (enabled) return;
  enabled = true;
  gpio_set(expander_en_port, expander_en_pin);
  delay_ms(1);
  rcc_peripheral_enable_clock(&RCC_APB1ENR, RCC_APB1ENR_I2C1EN);
  i2c_reset(I2C1);
  i2c_peripheral_enable(I2C1);
  i2c_set_standard_mode(I2C1);
  update_leds();
}

static void disable_io_expander(void)
{
  if (!enabled) return;
  enabled = false;
  gpio_clear(expander_en_port, expander_en_pin);
  i2c_peripheral_disable(I2C1);
  rcc_peripheral_disable_clock(&RCC_APB1ENR, RCC_APB1ENR_I2C1EN);
}

static void write_command(u8 command, u8* data, unsigned int n)
{
  i2c_send_start(I2C1);
  i2c_send_7bit_address(I2C1, expander_addr, 0);
  i2c_send_data(I2C1, command);
  for (unsigned int i=0; i<n; i++)
    i2c_send_data(I2C1, data[i]);
  i2c_send_stop(I2C1);
}

static void read_command(u8 command, u8* data, unsigned int n)
{
  i2c_send_start(I2C1);
  i2c_send_7bit_address(I2C1, expander_addr, 1);
  i2c_send_data(I2C1, command);
  for (unsigned int i=0; i<n; i++)
    data[i] = i2c_get_data(I2C1);
  i2c_send_stop(I2C1);
}

static u8 read_reg(u8 reg)
{
  u8 d;
  read_command(0xf & reg, &d, 1);
  return d;
}

static void write_reg(u8 reg, u8 value)
{
  write_command(0xf & reg, &value, 1);
}

static void update_leds(void)
{
  bool any_on = false;
  for (unsigned int i=0; i<3; i++)
    any_on |= shadow[i] != 0;
  if (any_on)
    enable_io_expander();

  write_command(0x10, shadow, 3);
  if (!any_on)
    disable_io_expander();
}

void set_led(u8 led, enum led_state state)
{
  for (unsigned int i=0; i<3; i++) {
    shadow[i] &= ~(1<<led);
    shadow[i] |= (1 & (state >> i)) << led;
  }
  update_leds();
}

void clear_leds()
{
  for (unsigned int i=0; i<3; i++) shadow[i] = 0x0;
  update_leds();
}
