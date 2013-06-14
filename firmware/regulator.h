struct regulator_t;
extern struct regulator_t chan1;
extern struct regulator_t chan2;

enum feedback_mode {
  DISABLED, CONST_DUTY, CURRENT_FB, VOLTAGE_FB, MAX_POWER
};

enum ch2_source_t { BATTERY, INPUT };

void regulator_init(void);

int regulator_set_mode(struct regulator_t *reg, enum feedback_mode mode);

int regulator_set_duty_cycle(struct regulator_t *reg, float d1, float d2);

int regulator_set_vsetpoint(struct regulator_t *reg, float setpoint);

int regulator_set_isetpoint(struct regulator_t *reg, float setpoint);

void regulator_set_ch2_source(enum ch2_source_t src);
