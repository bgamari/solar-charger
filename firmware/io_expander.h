#include <stdint.h>

enum led_state {
  led_off        = 0x0,
  led_on_pwm0    = 0x2,
  led_on_pwm1    = 0x3,
  led_on         = 0x4,
  led_on_master  = 0x5,
  led_blind_pwm0 = 0x6,
  led_blind_pwm1 = 0x7,
};

void clear_leds(void);
void set_led(uint8_t led, enum led_state state);
