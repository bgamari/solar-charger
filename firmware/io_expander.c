// I2C interface to TCA6057
#include "io_expander.h"
#include "clock.h"
#include <libopencm3/stm32/i2c.h>
#include <libopencm3/stm32/gpio.h>
#include <libopencm3/stm32/rcc.h>

const uint8_t expander_addr = 0x45;
const uint32_t expander_en_port = GPIOB;
const uint32_t expander_en_pin = GPIO5;

static uint8_t shadow[3] = {0,0,0};

static bool enabled = false;

static void update_leds(void);

static void enable_io_expander(void)
{
  if (enabled) return;
  enabled = true;
  gpio_clear(expander_en_port, expander_en_pin);
  delay_ms(1);
  gpio_set(expander_en_port, expander_en_pin);
  delay_ms(1);
  rcc_peripheral_enable_clock(&RCC_APB1ENR, RCC_APB1ENR_I2C1EN);
  i2c_reset(I2C1);
  // setup clocking: change when clocking is changed
  i2c_set_clock_frequency(I2C1, 16);
  i2c_set_ccr(I2C1, 0x40);
  i2c_set_standard_mode(I2C1);
  i2c_peripheral_enable(I2C1);
  update_leds();
}

static void disable_io_expander(void)
{
  if (!enabled) return;
  enabled = false;
  i2c_peripheral_disable(I2C1);
  gpio_clear(expander_en_port, expander_en_pin);
  rcc_peripheral_disable_clock(&RCC_APB1ENR, RCC_APB1ENR_I2C1EN);
}

/* Returns true if successful */
static bool i2c_try_arbitrate(uint32_t i2c, uint8_t address, uint8_t read_write)
{
  i2c_send_start(i2c);
  while (!(I2C1_SR1 & I2C_SR1_SB));
  i2c_send_7bit_address(i2c, address, read_write);
  while (true) {
    if (I2C_SR1(i2c) & I2C_SR1_ADDR) break;
    if (I2C_SR1(i2c) & I2C_SR1_ARLO) return false;
  }
  return true;
}

static void i2c_transfer(uint32_t i2c, uint8_t address, uint8_t* data, unsigned int length)
{
  while (! i2c_try_arbitrate(I2C1, address, I2C_WRITE));
  if (I2C_SR2(i2c) & I2C_SR2_MSL) {
    // transmitting
    for (unsigned int i=0; i<length; i++) {
      while (!(I2C_SR1(i2c) & I2C_SR1_TxE));
      i2c_send_data(i2c, data[i]);
    }
  } else {
    // receiving
    i2c_enable_ack(i2c);
    for (unsigned int i=0; i<length-1; i++) {
      while (!(I2C_SR1(i2c) & I2C_SR1_RxNE));
      data[i] = i2c_get_data(i2c);
    }
    i2c_disable_ack(i2c);
    data[length-1] = i2c_get_data(i2c);
  }
  i2c_send_stop(i2c);
}

static void write_command(uint8_t command, uint8_t* data, unsigned int n)
{
  while (! i2c_try_arbitrate(I2C1, expander_addr, I2C_WRITE));
  uint32_t unused = I2C1_SR2;

  while (!(I2C1_SR1 & I2C_SR1_TxE));
  i2c_send_data(I2C1, command);
  for (unsigned int i=0; i<n; i++) {
    while (!(I2C1_SR1 & I2C_SR1_TxE));
    i2c_send_data(I2C1, data[i]);
  }
  while (!(I2C1_SR1 & I2C_SR1_TxE));
  i2c_send_stop(I2C1);
}

static void read_command(uint8_t command, uint8_t* data, unsigned int n)
{
  while (! i2c_try_arbitrate(I2C1, expander_addr, I2C_WRITE));
  for (unsigned int i=0; i<n; i++)
    data[i] = i2c_get_data(I2C1);
  i2c_send_stop(I2C1);
}

static uint8_t read_reg(uint8_t reg)
{
  uint8_t d;
  read_command(0xf & reg, &d, 1);
  return d;
}

static void write_reg(uint8_t reg, uint8_t value)
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

void set_led(uint8_t led, enum led_state state)
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
