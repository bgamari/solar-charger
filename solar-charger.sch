v 20110115 2
C 57700 41300 1 0 0 stm32l151c6.sym
{
T 64000 47000 5 10 1 1 0 6 1
refdes=U2
T 60900 44500 5 10 0 0 0 0 1
device=STM32L151Cx
T 60900 44700 5 10 0 0 0 0 1
footprint=LQFP48_7
}
C 49900 52300 1 0 1 connector2-2.sym
{
T 49200 52100 5 10 1 1 0 0 1
refdes=IN
T 49600 53550 5 10 0 0 0 6 1
device=CONNECTOR_2
T 49300 52700 5 10 0 1 0 0 1
footprint=JUMPER2
}
C 50200 52600 1 90 0 gnd-1.sym
C 57500 43800 1 270 0 gnd-1.sym
C 64700 46200 1 90 1 gnd-1.sym
C 59200 47500 1 180 1 gnd-1.sym
C 75800 48700 1 270 0 resistor-1.sym
{
T 76200 48400 5 10 0 0 270 0 1
device=RESISTOR
T 76100 48700 5 10 1 1 270 0 1
refdes=RSENSE1
T 75800 48700 5 10 0 0 270 0 1
footprint=1206
}
C 69500 52400 1 0 0 vcc-1.sym
C 55200 49300 1 0 0 gnd-1.sym
C 57200 52700 1 0 0 3.3V-plus-1.sym
C 55100 51500 1 0 0 tps71501.sym
{
T 56900 53200 5 10 1 1 0 6 1
refdes=U1
T 55700 53400 5 10 0 0 0 0 1
device=TPS71501
T 56000 52500 5 10 1 1 0 0 1
value=3.3V
}
N 57200 52700 57400 52700 4
C 56100 51300 1 0 0 gnd-1.sym
C 68600 50500 1 0 0 ucc27518.sym
{
T 70400 52200 5 10 1 1 0 6 1
refdes=U3
T 69500 51700 5 10 0 0 0 0 1
device=UCC27518
}
C 69600 50300 1 0 0 gnd-1.sym
C 72400 49900 1 0 1 inductor-1.sym
{
T 72200 50400 5 10 0 0 0 6 1
device=INDUCTOR
T 72000 50200 5 10 1 1 0 6 1
refdes=L1
T 72200 50600 5 10 0 0 0 6 1
symversion=0.1
T 72400 49900 5 10 0 0 0 0 1
footprint=bourns-2200ll-vert
}
C 75800 47500 1 0 0 gnd-1.sym
C 78500 49500 1 0 1 connector2-1.sym
{
T 78300 50500 5 10 0 0 0 6 1
device=CONNECTOR_2
T 78500 50300 5 10 1 1 0 6 1
refdes=BATT
T 78100 50000 5 10 0 1 0 0 1
footprint=JUMPER2
}
N 75900 48700 75900 49700 4
T 46900 52300 9 10 1 0 0 0 6
Supply from panel:
 * +18V
 * 2W

Design for:
 * 5V - 20V input
T 71800 50800 9 10 1 0 0 0 8
Battery charging buck-boost:
 * 6 NiMH (1.45V each charged)
 * 9V in series
 * Capacity: 1100mA h to 2800mA h per cell
 * Limit charge time to 10 h
 * Charge rate: C / 10 = 100mA
 * Trickle rate: C / 300
 * Design for maximum I = 300mA
N 73400 38400 73400 39000 4
C 70700 35700 1 0 0 ucc27518.sym
{
T 72500 37400 5 10 1 1 0 6 1
refdes=U8
T 71600 36900 5 10 0 0 0 0 1
device=UCC27518
}
N 73200 36900 73200 37900 4
C 71700 35500 1 0 0 gnd-1.sym
C 74400 38600 1 0 0 inductor-1.sym
{
T 74600 39100 5 10 0 0 0 0 1
device=INDUCTOR
T 74900 38900 5 10 1 1 0 6 1
refdes=L2
T 74600 39300 5 10 0 0 0 0 1
symversion=0.1
T 74400 38600 5 10 0 0 0 0 1
footprint=bourns-2200ll-vert
}
C 78600 38200 1 0 1 connector2-1.sym
{
T 78400 39200 5 10 0 0 0 6 1
device=CONNECTOR_2
T 78500 39000 5 10 1 1 0 6 1
refdes=OUT
T 78400 38600 5 10 0 1 0 0 1
footprint=JUMPER2
}
N 75300 38700 76900 38700 4
N 70800 36500 70300 36500 4
{
T 70200 36500 5 10 1 1 0 6 1
netname=CH2_PANEL_IN
}
N 70800 36900 70300 36900 4
{
T 70200 36900 5 10 1 1 0 6 1
netname=CH2_PANEL_EN
}
N 68700 51300 68200 51300 4
{
T 68100 51200 5 10 1 1 0 6 1
netname=CH1_IN_A
}
N 68700 51700 68200 51700 4
{
T 68100 51600 5 10 1 1 0 6 1
netname=CH1_EN_A
}
C 77000 47900 1 0 0 gnd-1.sym
C 64400 46700 1 270 0 3.3V-plus-1.sym
C 58700 47200 1 0 0 3.3V-plus-1.sym
C 57800 43100 1 90 0 3.3V-plus-1.sym
C 76900 49000 1 0 0 3.3V-plus-1.sym
C 76700 46700 1 90 0 resistor-1.sym
{
T 76300 47000 5 10 0 0 90 0 1
device=RESISTOR
T 76800 47100 5 10 1 1 0 0 1
refdes=R9
T 76700 46700 5 10 0 0 90 0 1
footprint=0603
}
N 76600 47600 76600 48400 4
C 77600 47700 1 180 0 resistor-1.sym
{
T 77300 47300 5 10 0 0 180 0 1
device=RESISTOR
T 77300 47400 5 10 1 1 180 0 1
refdes=R11
T 77600 47700 5 10 0 0 180 0 1
footprint=0603
}
N 76700 47600 76600 47600 4
N 77700 47600 77700 48600 4
N 77600 48600 78000 48600 4
{
T 78000 48600 5 10 1 1 0 0 1
netname=ISENSE1
}
C 77600 47600 1 270 0 resistor-1.sym
{
T 78000 47300 5 10 0 0 270 0 1
device=RESISTOR
T 77900 47100 5 10 1 1 0 0 1
refdes=R14
T 77600 47600 5 10 0 0 270 0 1
footprint=0603
}
C 76500 46400 1 0 0 gnd-1.sym
C 77600 46400 1 0 0 gnd-1.sym
N 76600 48800 75900 48800 4
N 73500 50000 76800 50000 4
{
T 76200 50000 5 10 1 1 0 0 1
netname=VBATT
}
N 74400 49400 74400 48300 4
C 75000 47400 1 90 0 resistor-1.sym
{
T 74600 47700 5 10 0 0 90 0 1
device=RESISTOR
T 75100 47900 5 10 1 1 180 6 1
refdes=R3
T 75000 47400 5 10 0 0 90 0 1
footprint=0603
}
C 75000 46300 1 90 0 resistor-1.sym
{
T 74600 46600 5 10 0 0 90 0 1
device=RESISTOR
T 74800 46800 5 10 1 1 180 0 1
refdes=R4
T 75000 46300 5 10 0 0 90 0 1
footprint=0603
}
N 74900 47300 75200 47300 4
{
T 75300 47200 5 10 1 1 0 0 1
netname=VSENSE1
}
C 74800 46000 1 0 0 gnd-1.sym
T 76800 39300 9 10 1 0 0 0 2
Output: +3V to +9V
Optimize for +5V
C 75500 37000 1 90 0 resistor-1.sym
{
T 75100 37300 5 10 0 0 90 0 1
device=RESISTOR
T 75300 37500 5 10 1 1 180 0 1
refdes=R15
T 75500 37000 5 10 0 0 90 0 1
footprint=0603
}
C 75500 36100 1 90 0 resistor-1.sym
{
T 75100 36400 5 10 0 0 90 0 1
device=RESISTOR
T 75300 36700 5 10 1 1 180 0 1
refdes=R16
T 75500 36100 5 10 0 0 90 0 1
footprint=0603
}
N 75400 37000 76000 37000 4
{
T 75600 37000 5 10 1 1 0 0 1
netname=VSENSE2
}
C 75300 35800 1 0 0 gnd-1.sym
T 72500 45800 9 10 1 0 0 0 11
MOSFET to decouple
the voltage divider
from the battery
when charger is not
active.

Finite resistance of
partially switched
FET should be small
compared to divider
resistance.
C 48000 50800 1 90 1 capacitor-2.sym
{
T 47300 50600 5 10 0 0 270 2 1
device=POLARIZED_CAPACITOR
T 48100 50600 5 10 1 1 180 0 1
refdes=C2
T 47100 50600 5 10 0 0 270 2 1
symversion=0.1
T 47700 50400 5 10 0 1 0 0 1
footprint=RCY200P
}
C 48900 49900 1 90 0 capacitor-1.sym
{
T 48200 50100 5 10 0 0 90 0 1
device=CAPACITOR
T 49000 50600 5 10 1 1 180 0 1
refdes=C3
T 48000 50100 5 10 0 0 90 0 1
symversion=0.1
T 48900 49900 5 10 0 1 0 0 1
footprint=0603
}
C 47400 49900 1 90 0 capacitor-1.sym
{
T 46700 50100 5 10 0 0 90 0 1
device=CAPACITOR
T 47100 50600 5 10 1 1 180 0 1
refdes=C1
T 46500 50100 5 10 0 0 90 0 1
symversion=0.1
T 47400 49900 5 10 0 1 0 0 1
footprint=0603
}
C 49700 49900 1 90 0 capacitor-1.sym
{
T 49000 50100 5 10 0 0 90 0 1
device=CAPACITOR
T 49800 50600 5 10 1 1 180 0 1
refdes=C4
T 48800 50100 5 10 0 0 90 0 1
symversion=0.1
T 49700 49900 5 10 0 1 0 0 1
footprint=0603
}
C 48600 49600 1 0 0 gnd-1.sym
C 47400 49600 1 0 0 gnd-1.sym
N 47200 50800 47800 50800 4
N 47200 49900 47800 49900 4
C 49300 50800 1 0 0 3.3V-plus-1.sym
C 49400 49600 1 0 0 gnd-1.sym
C 63000 41100 1 0 1 gnd-1.sym
C 63500 41400 1 180 0 3.3V-plus-1.sym
N 57800 44100 57000 44100 4
{
T 56900 44000 5 10 1 1 0 6 1
netname=\_RESET\_
}
C 60400 47500 1 180 1 gnd-1.sym
N 53900 50700 54400 50700 4
C 55500 49600 1 90 0 zener-1.sym
{
T 54900 50000 5 10 0 0 90 0 1
device=ZENER_DIODE
T 55000 49900 5 10 1 1 90 0 1
refdes=Z1
T 55700 49900 5 10 1 1 90 0 1
value=15V
T 55500 49600 5 10 0 0 0 0 1
footprint=SOD123
}
C 54400 50600 1 0 0 resistor-1.sym
{
T 54700 51000 5 10 0 0 0 0 1
device=RESISTOR
T 54600 50900 5 10 1 1 0 0 1
refdes=R1
T 54400 50600 5 10 0 0 0 0 1
footprint=0603
}
N 55300 50500 55300 50700 4
N 55800 50700 55300 50700 4
N 49900 53100 50300 53100 4
{
T 50400 53100 5 10 1 1 0 0 1
netname=VPANEL
}
N 53000 53100 52600 53100 4
{
T 52300 53100 5 10 1 1 0 0 1
netname=VPANEL
}
C 53000 52900 1 0 0 schottky-1.sym
{
T 53322 53572 5 10 0 0 0 0 1
device=DIODE
T 53300 53400 5 10 1 1 0 0 1
refdes=D1
T 53341 53732 5 10 0 1 0 0 1
footprint=SOD128
}
C 53000 52100 1 0 0 schottky-1.sym
{
T 53322 52772 5 10 0 0 0 0 1
device=DIODE
T 53300 52600 5 10 1 1 0 0 1
refdes=D2
T 53341 52932 5 10 0 1 0 0 1
footprint=SOD128
}
N 53900 50700 53900 53100 4
N 53000 52300 52600 52300 4
{
T 52300 52300 5 10 1 1 0 0 1
netname=VBATT
}
C 55600 50700 1 0 0 vcc-1.sym
N 47500 50800 47500 51100 4
{
T 47600 51200 5 10 1 1 90 0 1
netname=VPANEL
}
C 48500 50800 1 0 0 vcc-1.sym
C 71600 37600 1 0 0 vcc-1.sym
N 72600 38400 72400 38400 4
{
T 72300 38500 5 10 1 1 180 0 1
netname=VPANEL
}
N 70500 50000 68900 50000 4
{
T 68800 49900 5 10 1 1 0 6 1
netname=VPANEL
}
C 50500 49900 1 90 0 capacitor-1.sym
{
T 49800 50100 5 10 0 0 90 0 1
device=CAPACITOR
T 50600 50600 5 10 1 1 180 0 1
refdes=C5
T 49600 50100 5 10 0 0 90 0 1
symversion=0.1
T 50500 49900 5 10 0 1 0 0 1
footprint=0603
}
N 50300 51100 50300 50800 4
{
T 50400 51200 5 10 1 1 90 0 1
netname=VBATT
}
C 50200 49600 1 0 0 gnd-1.sym
C 71700 39300 1 0 0 gnd-1.sym
N 70800 40300 70300 40300 4
{
T 70200 40300 5 10 1 1 0 6 1
netname=CH2_BATT_IN
}
N 70800 40700 70300 40700 4
{
T 70200 40700 5 10 1 1 0 6 1
netname=CH2_BATT_EN
}
C 71600 41400 1 0 0 vcc-1.sym
C 70700 39500 1 0 0 ucc27518.sym
{
T 71400 41200 5 10 1 1 0 6 1
refdes=U7
T 71600 40700 5 10 0 0 0 0 1
device=UCC27518
}
N 73200 39500 73200 40700 4
N 72600 39000 72400 39000 4
{
T 72300 39100 5 10 1 1 180 0 1
netname=VBATT
}
T 73100 32900 9 16 1 0 0 0 1
MCU-based solar battery charger
T 77100 32300 9 10 1 0 0 0 1
Ben Gamari
T 56000 40800 9 10 1 0 0 0 3
PWM pins
 TIM2: PA0, PA1, PA2, PA3
 TIM3: PA6, PA7, PB0, PB1
N 62100 41400 62100 40600 4
{
T 62200 40500 5 10 1 1 90 6 1
netname=CH1_IN_A
}
N 60900 41400 60900 40600 4
{
T 61000 40500 5 10 1 1 90 6 1
netname=CH2_PANEL_IN
}
N 60100 41400 60100 40600 4
{
T 60200 40500 5 10 1 1 90 6 1
netname=CH2_BATT_IN
}
T 56000 40200 9 10 1 0 0 0 2
ADC pins:
 PA2, PA3, PA4, PA5, PA6, PA7
N 58900 41400 58900 40600 4
{
T 59000 40500 5 10 1 1 90 6 1
netname=ISENSE1
}
N 59700 41400 59700 40600 4
{
T 59800 40500 5 10 1 1 90 6 1
netname=VSENSE1
}
N 57800 42500 57000 42500 4
{
T 56900 42400 5 10 1 1 0 6 1
netname=CH1_EN_B
}
N 61300 41400 61300 40600 4
{
T 61400 40500 5 10 1 1 90 6 1
netname=CH2_PANEL_EN
}
N 60500 41400 60500 40600 4
{
T 60600 40500 5 10 1 1 90 6 1
netname=CH2_BATT_EN
}
T 53100 49800 9 10 1 0 0 0 3
Shunt regulator to
avoid over-voltage
of MOSFET drivers
N 59300 41400 59300 40600 4
{
T 59400 40500 5 10 1 1 90 6 1
netname=VSENSE1_EN
}
N 64400 45700 65000 45700 4
{
T 65100 45600 5 10 1 1 0 0 1
netname=JTMS
}
N 63300 47200 63300 47800 4
{
T 63400 47900 5 10 1 1 90 0 1
netname=JTCK
}
N 62900 47200 62900 47800 4
{
T 63000 47900 5 10 1 1 90 0 1
netname=JTDI
}
N 62500 47200 62500 47800 4
{
T 62600 47900 5 10 1 1 90 0 1
netname=JTDO
}
N 62100 47200 62100 47800 4
{
T 62200 47900 5 10 1 1 90 0 1
netname=\_JRST\_
}
C 49000 35700 1 270 1 resistor-1.sym
{
T 49400 36000 5 10 0 0 270 6 1
device=RESISTOR
T 49300 35900 5 10 1 1 270 6 1
refdes=R2
T 49000 35700 5 10 0 0 270 6 1
footprint=0603
}
C 49300 35700 1 90 1 led-1.sym
{
T 48700 34900 5 10 0 0 90 6 1
device=LED
T 49500 35500 5 10 1 1 90 6 1
refdes=LED7
T 48500 34900 5 10 0 0 90 6 1
symversion=0.1
T 49300 35700 5 10 1 1 0 0 1
footprint=0603
}
N 49100 34800 49100 34400 4
{
T 49000 34300 5 10 1 1 270 0 1
netname=LED7
}
C 48900 36600 1 0 0 3.3V-plus-1.sym
N 64400 44900 65200 44900 4
{
T 65300 44800 5 10 1 1 0 0 1
netname=BTN2
}
N 64400 45300 65200 45300 4
{
T 65300 45200 5 10 1 1 0 0 1
netname=BTN1
}
C 51700 35900 1 270 0 switch-pushbutton-no-1.sym
{
T 52000 35700 5 10 1 1 270 0 1
refdes=BTN1
T 52300 35500 5 10 0 0 270 0 1
device=SWITCH_PUSHBUTTON_NO
T 51700 35900 5 10 0 0 0 0 1
footprint=omron-b3s
}
N 51700 35900 51700 36200 4
{
T 51600 36300 5 10 1 1 270 6 1
netname=BTN1
}
C 51600 34600 1 0 0 gnd-1.sym
C 52500 35900 1 270 0 switch-pushbutton-no-1.sym
{
T 52800 35700 5 10 1 1 270 0 1
refdes=BTN2
T 53100 35500 5 10 0 0 270 0 1
device=SWITCH_PUSHBUTTON_NO
T 52500 35900 5 10 0 0 0 0 1
footprint=omron-b3s
}
N 52500 35900 52500 36200 4
{
T 52400 36300 5 10 1 1 270 6 1
netname=BTN2
}
C 52400 34600 1 0 0 gnd-1.sym
C 50900 35900 1 270 0 switch-pushbutton-no-1.sym
{
T 51200 35700 5 10 1 1 270 0 1
refdes=RESET
T 51500 35500 5 10 0 0 270 0 1
device=SWITCH_PUSHBUTTON_NO
T 51600 35500 5 10 0 1 0 0 1
footprint=omron-b3s
}
N 50900 35900 50900 36200 4
{
T 50800 36300 5 10 1 1 270 6 1
netname=\_RESET\_
}
C 50800 34600 1 0 0 gnd-1.sym
C 72600 49800 1 0 0 schottky-1.sym
{
T 72922 50472 5 10 0 0 0 0 1
device=DIODE
T 72900 50300 5 10 1 1 0 0 1
refdes=D4
T 72941 50632 5 10 0 1 0 0 1
footprint=SOD128
}
N 72600 50000 72400 50000 4
N 70700 51700 71100 51700 4
C 72400 48900 1 0 0 gnd-1.sym
C 69600 47100 1 0 0 gnd-1.sym
N 68700 48100 68200 48100 4
{
T 68100 48000 5 10 1 1 0 6 1
netname=CH1_IN_B
}
N 68700 48500 68200 48500 4
{
T 68100 48400 5 10 1 1 0 6 1
netname=CH1_EN_B
}
C 68600 47300 1 0 0 ucc27518.sym
{
T 70400 49100 5 10 1 1 180 0 1
refdes=U4
T 69500 48500 5 10 0 0 0 0 1
device=UCC27518
}
C 69500 49200 1 0 0 vcc-1.sym
N 70700 48500 72000 48500 4
C 71600 49100 1 90 0 schottky-1.sym
{
T 70928 49422 5 10 0 0 90 0 1
device=DIODE
T 71200 49600 5 10 1 1 180 0 1
refdes=D3
T 70768 49441 5 10 0 1 90 0 1
footprint=SOD128
}
N 71300 50000 71500 50000 4
C 71300 48800 1 0 0 gnd-1.sym
N 72000 48500 72000 49400 4
C 73400 50000 1 270 0 capacitor-2.sym
{
T 74100 49800 5 10 0 0 270 0 1
device=POLARIZED_CAPACITOR
T 73500 49400 5 10 1 1 180 0 1
refdes=C6
T 74300 49800 5 10 0 0 270 0 1
symversion=0.1
T 73600 49500 5 10 0 1 0 0 1
footprint=RCY100P
}
C 73500 48800 1 0 0 gnd-1.sym
N 71100 51700 71100 50500 4
C 71300 50500 1 90 1 nmos-3.sym
{
T 70800 49900 5 10 0 0 270 2 1
device=NMOS_TRANSISTOR
T 70300 50300 5 10 1 1 0 2 1
refdes=Q2
T 71300 50500 5 10 0 1 0 0 1
footprint=SOT669-PSMN0R9-25YLC
}
C 74400 49200 1 0 0 nmos-3.sym
{
T 75000 49700 5 10 0 0 180 8 1
device=NMOS_TRANSISTOR
T 74500 49700 5 10 1 1 0 8 1
refdes=Q4
T 74400 49200 5 10 0 1 0 0 1
footprint=SOT669-PSMN0R9-25YLC
}
C 72000 49200 1 0 0 nmos-3.sym
{
T 72600 49700 5 10 0 0 180 8 1
device=NMOS_TRANSISTOR
T 72100 49700 5 10 1 1 0 8 1
refdes=Q3
T 72000 49200 5 10 0 1 0 0 1
footprint=SOT669-PSMN0R9-25YLC
}
C 73400 37900 1 90 0 nmos-3.sym
{
T 72900 38500 5 10 0 0 270 8 1
device=NMOS_TRANSISTOR
T 73100 38000 5 10 1 1 0 8 1
refdes=Q6
T 73400 37900 5 10 0 1 0 0 1
footprint=SOT669-PSMN0R9-25YLC
}
C 73400 39500 1 90 1 nmos-3.sym
{
T 72900 38900 5 10 0 0 270 2 1
device=NMOS_TRANSISTOR
T 73100 39400 5 10 1 1 0 6 1
refdes=Q5
T 73400 39500 5 10 0 1 0 0 1
footprint=SOT669-PSMN0R9-25YLC
}
C 74500 37300 1 90 0 schottky-1.sym
{
T 73828 37622 5 10 0 0 90 0 1
device=DIODE
T 74100 37800 5 10 1 1 180 0 1
refdes=D5
T 73668 37641 5 10 0 1 90 0 1
footprint=SOD128
}
N 73400 38700 74400 38700 4
N 74300 38200 74300 38700 4
C 74200 37000 1 0 0 gnd-1.sym
C 76100 38700 1 270 0 capacitor-2.sym
{
T 76800 38500 5 10 0 0 270 0 1
device=POLARIZED_CAPACITOR
T 76000 38300 5 10 1 1 0 0 1
refdes=C7
T 77000 38500 5 10 0 0 270 0 1
symversion=0.1
T 76400 38100 5 10 0 1 0 0 1
footprint=RCY200P
}
C 76200 37500 1 0 0 gnd-1.sym
N 75900 49700 76800 49700 4
N 74400 48300 73800 48300 4
{
T 73700 48200 5 10 1 1 0 6 1
netname=VSENSE1_EN
}
N 74900 48300 74900 49200 4
N 74900 47400 74900 47200 4
N 60100 47200 60100 48000 4
{
T 60200 49000 5 10 1 1 90 6 1
netname=CH1_IN_B
}
N 62500 41400 62500 40600 4
{
T 62600 40500 5 10 1 1 90 6 1
netname=CH1_EN_A
}
T 77800 48000 9 10 1 0 0 0 1
Gain = ?
C 57000 33300 1 0 0 tca6507.sym
{
T 58800 37000 5 10 1 1 0 6 1
refdes=U5
}
N 57100 36500 56600 36500 4
{
T 56500 36400 5 10 1 1 0 6 1
netname=SCL
}
N 57100 36100 56600 36100 4
{
T 56500 36000 5 10 1 1 0 6 1
netname=SDA
}
N 57100 35700 56600 35700 4
{
T 56500 35600 5 10 1 1 0 6 1
netname=LED_EN
}
N 61300 47200 61300 47800 4
{
T 61400 47900 5 10 1 1 90 0 1
netname=SCL
}
N 60900 47200 60900 47800 4
{
T 61000 47900 5 10 1 1 90 0 1
netname=SDA
}
T 60900 48400 9 10 1 0 0 0 1
I2C1
N 61700 47200 61700 47800 4
{
T 61800 47900 5 10 1 1 90 0 1
netname=LED_EN
}
C 57900 37200 1 0 0 3.3V-plus-1.sym
C 58200 33100 1 0 1 gnd-1.sym
C 62100 36300 1 0 1 led-1.sym
{
T 61300 36900 5 10 0 0 0 6 1
device=LED
T 62300 36300 5 10 1 1 0 6 1
refdes=LED0
T 61300 37100 5 10 0 0 0 6 1
symversion=0.1
T 62100 36300 5 10 0 1 0 0 1
footprint=0603
}
C 60000 36400 1 0 1 resistor-1.sym
{
T 59700 36800 5 10 0 0 0 6 1
device=RESISTOR
T 60000 36300 5 10 1 1 0 6 1
refdes=R5
T 60000 36400 5 10 0 0 0 6 1
footprint=0603
}
C 60900 35900 1 0 1 led-1.sym
{
T 60100 36500 5 10 0 0 0 6 1
device=LED
T 61100 35900 5 10 1 1 0 6 1
refdes=LED1
T 60100 36700 5 10 0 0 0 6 1
symversion=0.1
T 60900 35900 5 10 0 1 0 0 1
footprint=0603
}
C 60000 36000 1 0 1 resistor-1.sym
{
T 59700 36400 5 10 0 0 0 6 1
device=RESISTOR
T 60000 35900 5 10 1 1 0 6 1
refdes=R6
T 60000 36000 5 10 0 0 0 6 1
footprint=0603
}
N 61200 36500 60000 36500 4
C 62100 35500 1 0 1 led-1.sym
{
T 61300 36100 5 10 0 0 0 6 1
device=LED
T 62300 35500 5 10 1 1 0 6 1
refdes=LED2
T 61300 36300 5 10 0 0 0 6 1
symversion=0.1
T 62100 35500 5 10 0 1 0 0 1
footprint=0603
}
C 60000 35600 1 0 1 resistor-1.sym
{
T 59700 36000 5 10 0 0 0 6 1
device=RESISTOR
T 60000 35500 5 10 1 1 0 6 1
refdes=R7
T 60000 35600 5 10 0 0 0 6 1
footprint=0603
}
N 61200 35700 60000 35700 4
N 60900 36100 62600 36100 4
C 60900 35100 1 0 1 led-1.sym
{
T 60100 35700 5 10 0 0 0 6 1
device=LED
T 60100 35900 5 10 0 0 0 6 1
symversion=0.1
T 61100 35100 5 10 1 1 0 6 1
refdes=LED3
T 60900 35100 5 10 0 1 0 0 1
footprint=0603
}
N 60900 35300 62600 35300 4
C 60000 35200 1 0 1 resistor-1.sym
{
T 59700 35600 5 10 0 0 0 6 1
device=RESISTOR
T 60000 35100 5 10 1 1 0 6 1
refdes=R8
T 60000 35200 5 10 0 0 0 6 1
footprint=0603
}
C 60900 34300 1 0 1 led-1.sym
{
T 60100 34900 5 10 0 0 0 6 1
device=LED
T 60100 35100 5 10 0 0 0 6 1
symversion=0.1
T 61100 34300 5 10 1 1 0 6 1
refdes=LED5
T 60900 34300 5 10 0 1 0 0 1
footprint=0603
}
N 60900 34500 62600 34500 4
C 60000 34400 1 0 1 resistor-1.sym
{
T 59700 34800 5 10 0 0 0 6 1
device=RESISTOR
T 60000 34300 5 10 1 1 0 6 1
refdes=R12
T 60000 34400 5 10 0 0 0 6 1
footprint=0603
}
C 60000 34800 1 0 1 resistor-1.sym
{
T 59700 35200 5 10 0 0 0 6 1
device=RESISTOR
T 60000 34700 5 10 1 1 0 6 1
refdes=R10
T 60000 34800 5 10 0 0 0 6 1
footprint=0603
}
N 61200 34900 60000 34900 4
C 62100 34700 1 0 1 led-1.sym
{
T 61300 35300 5 10 0 0 0 6 1
device=LED
T 61300 35500 5 10 0 0 0 6 1
symversion=0.1
T 62300 34700 5 10 1 1 0 6 1
refdes=LED4
T 62100 34700 5 10 0 1 0 0 1
footprint=0603
}
C 60000 34000 1 0 1 resistor-1.sym
{
T 59700 34400 5 10 0 0 0 6 1
device=RESISTOR
T 60000 33900 5 10 1 1 0 6 1
refdes=R13
T 60000 34000 5 10 0 0 0 6 1
footprint=0603
}
N 61200 34100 60000 34100 4
C 62100 33900 1 0 1 led-1.sym
{
T 61300 34500 5 10 0 0 0 6 1
device=LED
T 61300 34700 5 10 0 0 0 6 1
symversion=0.1
T 62300 33900 5 10 1 1 0 6 1
refdes=LED6
T 62100 33900 5 10 0 1 0 0 1
footprint=0603
}
C 62400 36600 1 0 0 3.3V-plus-1.sym
C 53200 35900 1 270 0 switch-pushbutton-no-1.sym
{
T 53500 35700 5 10 1 1 270 0 1
refdes=BTN3
T 53800 35500 5 10 0 0 270 0 1
device=SWITCH_PUSHBUTTON_NO
T 53200 35900 5 10 0 0 0 0 1
footprint=omron-b3s
}
N 53200 35900 53200 36200 4
{
T 53100 36300 5 10 1 1 270 6 1
netname=BTN3
}
C 53100 34600 1 0 0 gnd-1.sym
N 64400 43700 65200 43700 4
{
T 65300 43600 5 10 1 1 0 0 1
netname=BTN3
}
C 46100 32200 0 0 0 title-D.sym
N 64400 44100 65200 44100 4
{
T 65300 44000 5 10 1 1 0 0 1
netname=UART_TX
}
N 64400 44500 65200 44500 4
{
T 65300 44400 5 10 1 1 0 0 1
netname=UART_RX
}
C 51400 39600 1 0 0 connector3-2.sym
{
T 52100 41300 5 10 1 1 0 6 1
refdes=UART
T 51700 41250 5 10 0 0 0 0 1
device=CONNECTOR_3
T 51700 41450 5 10 0 0 0 0 1
footprint=JUMPER3
}
N 51400 40800 50600 40800 4
{
T 50600 40800 5 10 1 1 180 0 1
netname=UART_TX
}
N 51400 40400 50600 40400 4
{
T 50600 40400 5 10 1 1 180 0 1
netname=UART_RX
}
C 51100 40100 1 270 0 gnd-1.sym
C 48400 38400 1 0 0 connector6-2.sym
{
T 49100 41300 5 10 1 1 0 6 1
refdes=JTAG
T 48700 41250 5 10 0 0 0 0 1
device=CONNECTOR_6
T 48700 41450 5 10 0 0 0 0 1
footprint=SMT JUMPER6
}
N 48400 40400 47800 40400 4
{
T 47700 40500 5 10 1 1 180 0 1
netname=JTCK
}
N 48400 40000 47800 40000 4
{
T 47700 40100 5 10 1 1 180 0 1
netname=JTDI
}
N 48400 39600 47800 39600 4
{
T 47700 39700 5 10 1 1 180 0 1
netname=JTDO
}
N 48400 39200 47800 39200 4
{
T 47700 39300 5 10 1 1 180 0 1
netname=\_JRST\_
}
N 48400 40800 47800 40800 4
{
T 47700 40900 5 10 1 1 180 0 1
netname=JTMS
}
C 48100 38900 1 270 0 gnd-1.sym
N 77600 47600 77700 47600 4
N 73200 36900 72800 36900 4
N 72800 40700 73200 40700 4
N 75400 37900 75400 38700 4
C 76600 48200 1 0 0 opa340.sym
{
T 77300 49000 5 10 0 0 0 0 1
device=OPAMP
T 77300 48800 5 10 1 1 0 0 1
refdes=U6
T 77300 49600 5 10 0 0 0 0 1
symversion=0.1
T 77300 49800 5 10 0 1 0 0 1
value=OPA340
T 77300 50000 5 10 0 1 0 0 1
footprint=SOT23-5
}
N 62100 36500 62600 36500 4
N 62100 35700 62600 35700 4
N 62100 34900 62600 34900 4
N 62100 34100 62600 34100 4
N 62600 34100 62600 36600 4
C 55100 51800 1 90 0 capacitor-1.sym
{
T 54400 52000 5 10 0 0 90 0 1
device=CAPACITOR
T 55200 52500 5 10 1 1 180 0 1
refdes=C8
T 54200 52000 5 10 0 0 90 0 1
symversion=0.1
T 55100 51800 5 10 0 1 0 0 1
footprint=0603
}
N 55200 52700 53900 52700 4
C 54800 51500 1 0 0 gnd-1.sym
C 64600 40100 1 90 0 capacitor-1.sym
{
T 63900 40300 5 10 0 0 90 0 1
device=CAPACITOR
T 64700 40800 5 10 1 1 180 0 1
refdes=C9
T 63700 40300 5 10 0 0 90 0 1
symversion=0.1
T 64600 40100 5 10 0 1 0 0 1
footprint=0603
}
C 65200 40100 1 90 0 capacitor-1.sym
{
T 64500 40300 5 10 0 0 90 0 1
device=CAPACITOR
T 65300 40800 5 10 1 1 180 0 1
refdes=C10
T 64300 40300 5 10 0 0 90 0 1
symversion=0.1
T 65200 40100 5 10 0 1 0 0 1
footprint=0603
}
C 65800 40100 1 90 0 capacitor-1.sym
{
T 65100 40300 5 10 0 0 90 0 1
device=CAPACITOR
T 65900 40800 5 10 1 1 180 0 1
refdes=C11
T 64900 40300 5 10 0 0 90 0 1
symversion=0.1
T 65800 40100 5 10 0 1 0 0 1
footprint=0603
}
C 66400 40100 1 90 0 capacitor-1.sym
{
T 65700 40300 5 10 0 0 90 0 1
device=CAPACITOR
T 66500 40800 5 10 1 1 180 0 1
refdes=C12
T 65500 40300 5 10 0 0 90 0 1
symversion=0.1
T 66400 40100 5 10 0 1 0 0 1
footprint=0603
}
N 66200 41000 64400 41000 4
N 64400 40100 66200 40100 4
C 65200 39800 1 0 0 gnd-1.sym
C 65100 41000 1 0 0 3.3V-plus-1.sym
C 57100 34100 1 90 0 capacitor-1.sym
{
T 56400 34300 5 10 0 0 90 0 1
device=CAPACITOR
T 57200 34800 5 10 1 1 180 0 1
refdes=C13
T 56200 34300 5 10 0 0 90 0 1
symversion=0.1
T 57100 34100 5 10 0 1 0 0 1
footprint=0603
}
C 56700 35000 1 0 0 3.3V-plus-1.sym
C 57000 33800 1 0 1 gnd-1.sym
C 73900 34500 1 90 0 capacitor-1.sym
{
T 73200 34700 5 10 0 0 90 0 1
device=CAPACITOR
T 74000 35200 5 10 1 1 180 0 1
refdes=C14
T 73000 34700 5 10 0 0 90 0 1
symversion=0.1
T 73900 34500 5 10 0 1 0 0 1
footprint=0603
}
C 73800 35400 1 0 0 vcc-1.sym
C 73900 34200 1 0 0 gnd-1.sym
C 74500 34500 1 90 0 capacitor-1.sym
{
T 73800 34700 5 10 0 0 90 0 1
device=CAPACITOR
T 74600 35200 5 10 1 1 180 0 1
refdes=C15
T 73600 34700 5 10 0 0 90 0 1
symversion=0.1
T 74500 34500 5 10 0 1 0 0 1
footprint=0603
}
N 73700 35400 74300 35400 4
N 73700 34500 74300 34500 4
C 70800 46300 1 0 0 vcc-1.sym
C 70900 45100 1 0 0 gnd-1.sym
C 71500 45400 1 90 0 capacitor-1.sym
{
T 70800 45600 5 10 0 0 90 0 1
device=CAPACITOR
T 71600 46100 5 10 1 1 180 0 1
refdes=C17
T 70600 45600 5 10 0 0 90 0 1
symversion=0.1
T 71500 45400 5 10 0 1 0 0 1
footprint=0603
}
N 70700 46300 71300 46300 4
N 70700 45400 71300 45400 4
C 70900 45400 1 90 0 capacitor-1.sym
{
T 71000 46100 5 10 1 1 180 0 1
refdes=C16
T 70200 45600 5 10 0 0 90 0 1
device=CAPACITOR
T 70000 45600 5 10 0 0 90 0 1
symversion=0.1
T 70900 45400 5 10 0 1 0 0 1
footprint=0603
}
C 76000 45400 1 90 0 capacitor-1.sym
{
T 75300 45600 5 10 0 0 90 0 1
device=CAPACITOR
T 76100 46100 5 10 1 1 180 0 1
refdes=C20
T 75100 45600 5 10 0 0 90 0 1
symversion=0.1
T 76000 45400 5 10 0 1 0 0 1
footprint=0603
}
N 64400 43300 65200 43300 4
{
T 65300 43400 5 10 1 1 180 6 1
netname=VSENSE2
}
T 60200 42000 9 10 1 0 90 0 1
TIM3_CH1
T 61000 42000 9 10 1 0 90 0 1
TIM3_CH3
T 62200 42000 9 10 1 0 90 0 1
TIM2_CH3
T 60100 45700 9 10 1 0 90 0 1
TIM4_CH3
T 59000 42000 9 10 1 0 90 0 1
ADC_IN3
T 59800 42000 9 10 1 0 90 0 1
ADC_IN5
C 67900 46700 1 180 1 connector2-2.sym
{
T 68600 46900 5 10 1 1 180 0 1
refdes=THERM
T 68200 45450 5 10 0 0 180 6 1
device=CONNECTOR_2
T 68500 46300 5 10 0 1 180 0 1
footprint=JUMPER2
}
C 67900 46100 1 90 0 3.3V-plus-1.sym
C 67800 45000 1 270 1 resistor-1.sym
{
T 68200 45300 5 10 0 0 270 6 1
device=RESISTOR
T 67800 45500 5 10 1 1 90 6 1
refdes=R17
T 67800 45000 5 10 0 0 270 6 1
footprint=0603
}
N 67900 45900 67000 45900 4
{
T 66600 45900 5 10 1 1 0 0 1
netname=VTH
}
C 67500 44700 1 0 0 gnd-1.sym
N 57800 42900 57000 42900 4
{
T 56900 43000 5 10 1 1 180 0 1
netname=LED7
}
T 62700 42500 9 10 1 0 0 0 1
ADC_IN19
N 64400 42900 65200 42900 4
{
T 65300 43000 5 10 1 1 180 6 1
netname=ISENSE2
}
T 62700 43300 9 10 1 0 0 0 1
ADC_IN21
N 64400 42100 65200 42100 4
{
T 65300 42200 5 10 1 1 180 6 1
netname=VTH
}
T 62700 42100 9 10 1 0 0 0 1
ADC_IN18
C 67500 45000 1 90 0 capacitor-1.sym
{
T 66800 45200 5 10 0 0 90 0 1
device=CAPACITOR
T 67600 45700 5 10 1 1 180 0 1
refdes=C18
T 66600 45200 5 10 0 0 90 0 1
symversion=0.1
T 67500 45000 5 10 0 1 0 0 1
footprint=0603
}
N 67300 45000 67900 45000 4
T 62700 42900 9 10 1 0 0 0 1
ADC_IN20
C 76800 36700 1 270 0 resistor-1.sym
{
T 77200 36400 5 10 0 0 270 0 1
device=RESISTOR
T 77100 36700 5 10 1 1 270 0 1
refdes=RSENSE2
T 76800 36700 5 10 0 0 270 0 1
footprint=1206
}
C 76800 35500 1 0 0 gnd-1.sym
N 76900 36700 76900 38400 4
C 78000 35900 1 0 0 gnd-1.sym
C 77900 37000 1 0 0 3.3V-plus-1.sym
C 77700 34700 1 90 0 resistor-1.sym
{
T 77300 35000 5 10 0 0 90 0 1
device=RESISTOR
T 77800 35100 5 10 1 1 0 0 1
refdes=R18
T 77700 34700 5 10 0 0 90 0 1
footprint=0603
}
N 77600 35600 77600 36400 4
C 78600 35700 1 180 0 resistor-1.sym
{
T 78300 35300 5 10 0 0 180 0 1
device=RESISTOR
T 78300 35400 5 10 1 1 180 0 1
refdes=R19
T 78600 35700 5 10 0 0 180 0 1
footprint=0603
}
N 77700 35600 77600 35600 4
N 78700 35600 78700 36600 4
N 78600 36600 79000 36600 4
{
T 79000 36600 5 10 1 1 0 0 1
netname=ISENSE2
}
C 78600 35600 1 270 0 resistor-1.sym
{
T 79000 35300 5 10 0 0 270 0 1
device=RESISTOR
T 78900 35100 5 10 1 1 0 0 1
refdes=R20
T 78600 35600 5 10 0 0 270 0 1
footprint=0603
}
C 77500 34400 1 0 0 gnd-1.sym
C 78600 34400 1 0 0 gnd-1.sym
N 77600 36800 76900 36800 4
N 78600 35600 78700 35600 4
C 77600 36200 1 0 0 opa340.sym
{
T 78300 37000 5 10 0 0 0 0 1
device=OPAMP
T 78300 36800 5 10 1 1 0 0 1
refdes=U9
T 78300 37600 5 10 0 0 0 0 1
symversion=0.1
T 78300 37800 5 10 0 1 0 0 1
value=OPA340
T 78300 38000 5 10 0 1 0 0 1
footprint=SOT23-5
}
T 78800 36000 9 10 1 0 0 0 1
Gain = ?
C 76300 34500 1 90 0 capacitor-1.sym
{
T 75600 34700 5 10 0 0 90 0 1
device=CAPACITOR
T 76400 35200 5 10 1 1 180 0 1
refdes=C19
T 75400 34700 5 10 0 0 90 0 1
symversion=0.1
T 76300 34500 5 10 0 1 0 0 1
footprint=0603
}
C 75900 35400 1 0 0 3.3V-plus-1.sym
C 76000 34200 1 0 0 gnd-1.sym
C 75600 46300 1 0 0 3.3V-plus-1.sym
C 75700 45100 1 0 0 gnd-1.sym
