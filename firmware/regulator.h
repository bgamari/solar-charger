typedef unsigned int fixed32_t; // 16.16 fixed point
typedef unsigned int fract32_t; // 0.32 fixed point

struct regulator_t;
extern struct regulator_t chan1;
extern struct regulator_t chan2;

enum feedback_mode {
  DISABLED, CONST_DUTY, CURRENT_FB, VOLTAGE_FB, MAX_POWER
};

enum ch2_source_t { BATTERY, INPUT };

void regulator_init(void);

int regulator_set_mode(struct regulator_t *reg, enum feedback_mode mode);
enum feedback_mode regulator_get_mode(struct regulator_t *reg);

int regulator_set_duty_cycle(struct regulator_t *reg, fract32_t d1, fract32_t d2);

int regulator_set_vsetpoint(struct regulator_t *reg, fract32_t setpoint);

int regulator_set_isetpoint(struct regulator_t *reg, fract32_t setpoint);

fixed32_t regulator_get_vsense(struct regulator_t *reg);

fixed32_t regulator_get_isense(struct regulator_t *reg);

void regulator_set_ch2_source(enum ch2_source_t src);

int regulator_set_period(struct regulator_t *reg, unsigned int period);
