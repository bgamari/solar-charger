struct regulator_t;
extern struct regulator_t chan1;
extern struct regulator_t chan2;

enum feedback_mode {
  disabled, current_fb, voltage_fb, power_fb
};

void regulator_set_mode(struct regulator_t *reg, enum feedback_mode mode);
