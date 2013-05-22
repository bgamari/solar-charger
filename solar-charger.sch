v 20110115 2
C 56200 38000 1 0 0 stm32l151c6.sym
{
T 62500 43700 5 10 1 1 0 6 1
refdes=U?
T 59400 41200 5 10 0 0 0 0 1
device=AD5L79Lxx
T 59400 41400 5 10 0 0 0 0 1
footprint=SOT89
}
C 54400 49700 1 0 1 connector2-2.sym
{
T 53700 51000 5 10 1 1 0 0 1
refdes=IN
T 54100 50950 5 10 0 0 0 6 1
device=CONNECTOR_2
T 54100 51150 5 10 0 0 0 6 1
footprint=SIP2N
}
C 54700 50000 1 90 0 gnd-1.sym
C 56000 40500 1 270 0 gnd-1.sym
C 63200 42900 1 90 1 gnd-1.sym
C 57700 44200 1 180 1 gnd-1.sym
C 69400 44700 1 270 0 resistor-1.sym
{
T 69800 44400 5 10 0 0 270 0 1
device=RESISTOR
T 69700 44700 5 10 1 1 270 0 1
refdes=RSENSE
T 69400 44700 5 10 0 0 270 0 1
footprint=0603
}
C 64900 50800 1 0 0 vcc-1.sym
C 60100 47000 1 0 0 gnd-1.sym
C 61300 50200 1 0 0 3.3V-plus-1.sym
C 59200 49000 1 0 0 tps71501.sym
{
T 61000 50700 5 10 1 1 0 6 1
refdes=U?
T 59800 50900 5 10 0 0 0 0 1
device=TPS71501
T 59800 51100 5 10 0 0 0 0 1
footprint=SOT89
T 60100 50000 5 10 1 1 0 0 1
value=3.3V
}
N 61300 50200 61500 50200 4
C 60200 48800 1 0 0 gnd-1.sym
C 64000 48900 1 0 0 ucc27518.sym
{
T 65800 50600 5 10 1 1 0 6 1
refdes=U?
T 64900 50100 5 10 0 0 0 0 1
device=UCC27518
T 64900 50300 5 10 0 0 0 0 1
footprint=SOT89
}
C 65000 48700 1 0 0 gnd-1.sym
C 67800 48300 1 0 1 inductor-1.sym
{
T 67600 48800 5 10 0 0 0 6 1
device=INDUCTOR
T 67400 48600 5 10 1 1 0 6 1
refdes=L?
T 67600 49000 5 10 0 0 0 6 1
symversion=0.1
}
C 69400 43500 1 0 0 gnd-1.sym
C 71200 45500 1 0 1 connector2-1.sym
{
T 71000 46500 5 10 0 0 0 6 1
device=CONNECTOR_2
T 71200 46300 5 10 1 1 0 6 1
refdes=BATT
}
N 69500 44700 69500 45700 4
T 55100 49700 9 10 1 0 0 0 3
Supply from panel:
 * +18V
 * 2W
T 70200 46800 9 10 1 0 0 0 8
Battery charging buck-boost:
 * 6 NiMH (1.45V each charged)
 * 9V in series
 * Capacity: 1100mA h to 2800mA h
 * Limit charge time to 10 h
 * Charge rate: C / 10 = 100mA
 * Trickle rate: C / 300
 * Design for maximum I = 300mA
N 69000 40200 69600 40200 4
C 66300 39200 1 0 0 ucc27518.sym
{
T 68100 40900 5 10 1 1 0 6 1
refdes=U?
T 67200 40400 5 10 0 0 0 0 1
device=UCC27518
T 67200 40600 5 10 0 0 0 0 1
footprint=SOT89
}
N 68400 40400 68500 40400 4
C 67300 39000 1 0 0 gnd-1.sym
C 69400 39000 1 90 0 inductor-1.sym
{
T 68900 39200 5 10 0 0 90 0 1
device=INDUCTOR
T 69400 39500 5 10 1 1 180 6 1
refdes=L?
T 68700 39200 5 10 0 0 90 0 1
symversion=0.1
}
C 69800 37300 1 0 0 gnd-1.sym
C 71600 37400 1 0 1 connector2-1.sym
{
T 71400 38400 5 10 0 0 0 6 1
device=CONNECTOR_2
T 71500 38200 5 10 1 1 0 6 1
refdes=OUT
}
N 69300 37900 69300 39000 4
N 66400 40000 65900 40000 4
{
T 65800 40000 5 10 1 1 0 6 1
netname=CH2_PANEL_IN
}
N 66400 40400 65900 40400 4
{
T 65800 40400 5 10 1 1 0 6 1
netname=CH2_PANEL_EN
}
N 64100 49700 63600 49700 4
{
T 63500 49600 5 10 1 1 0 6 1
netname=CH1_IN
}
N 64100 50100 63600 50100 4
{
T 63500 50000 5 10 1 1 0 6 1
netname=CH1_EN_A
}
C 52200 34200 0 0 0 title-C.sym
C 71300 44400 1 0 0 opamp-1.sym
{
T 72000 45200 5 10 0 0 0 0 1
device=OPAMP
T 72000 45000 5 10 1 1 0 0 1
refdes=U?
T 72000 45800 5 10 0 0 0 0 1
symversion=0.1
}
C 71700 44100 1 0 0 gnd-1.sym
C 62900 43400 1 270 0 3.3V-plus-1.sym
C 57200 43900 1 0 0 3.3V-plus-1.sym
C 56300 39800 1 90 0 3.3V-plus-1.sym
C 71600 45200 1 0 0 3.3V-plus-1.sym
C 71400 42900 1 90 0 resistor-1.sym
{
T 71000 43200 5 10 0 0 90 0 1
device=RESISTOR
T 71100 43100 5 10 1 1 90 0 1
refdes=R?
T 71400 42900 5 10 0 0 90 0 1
footprint=0603
}
N 71300 43800 71300 44600 4
C 72400 43900 1 180 0 resistor-1.sym
{
T 72100 43500 5 10 0 0 180 0 1
device=RESISTOR
T 72200 43600 5 10 1 1 180 0 1
refdes=R?
T 72400 43900 5 10 0 0 180 0 1
footprint=0603
}
N 71500 43800 71300 43800 4
N 72400 43800 72400 44800 4
N 72300 44800 73100 44800 4
{
T 73100 44800 5 10 1 1 0 0 1
netname=ISENSE1
}
C 72300 43800 1 270 0 resistor-1.sym
{
T 72700 43500 5 10 0 0 270 0 1
device=RESISTOR
T 72600 43600 5 10 1 1 270 0 1
refdes=R?
T 72300 43800 5 10 0 0 270 0 1
footprint=0603
}
C 71200 42600 1 0 0 gnd-1.sym
C 72300 42600 1 0 0 gnd-1.sym
N 71300 45000 69500 45000 4
N 66800 46000 69500 46000 4
{
T 66800 46000 5 10 1 1 0 0 1
netname=VBAT
}
N 67500 45400 66900 45400 4
{
T 65600 45300 5 10 1 1 0 0 1
netname=VSENSE1_EN
}
C 68100 44300 1 90 0 resistor-1.sym
{
T 67700 44600 5 10 0 0 90 0 1
device=RESISTOR
T 67900 44800 5 10 1 1 180 0 1
refdes=R?
T 68100 44300 5 10 0 0 90 0 1
footprint=0603
}
C 68100 43400 1 90 0 resistor-1.sym
{
T 67700 43700 5 10 0 0 90 0 1
device=RESISTOR
T 67900 43900 5 10 1 1 180 0 1
refdes=R?
T 68100 43400 5 10 0 0 90 0 1
footprint=0603
}
N 68000 44300 68600 44300 4
{
T 68200 44300 5 10 1 1 0 0 1
netname=VSENSE1
}
C 67900 43100 1 0 0 gnd-1.sym
N 69900 37900 67900 37900 4
T 70500 36800 9 10 1 0 0 0 2
Output: +3V to +9V
Optimize for +5V
C 68000 37000 1 90 0 resistor-1.sym
{
T 67600 37300 5 10 0 0 90 0 1
device=RESISTOR
T 67800 37500 5 10 1 1 180 0 1
refdes=R?
T 68000 37000 5 10 0 0 90 0 1
footprint=0603
}
C 68000 36100 1 90 0 resistor-1.sym
{
T 67600 36400 5 10 0 0 90 0 1
device=RESISTOR
T 67800 36700 5 10 1 1 180 0 1
refdes=R?
T 68000 36100 5 10 0 0 90 0 1
footprint=0603
}
N 67900 37000 68500 37000 4
{
T 68100 37000 5 10 1 1 0 0 1
netname=VSENSE2
}
C 67800 35800 1 0 0 gnd-1.sym
T 65700 43000 9 10 1 0 0 0 10
MOSFET to decouple
the voltage divider
when charger is not
active.

Finite resistance of
partially switched
FET should be small
compared to divider
resistance.
C 53900 48100 1 90 1 capacitor-2.sym
{
T 53200 47900 5 10 0 0 270 2 1
device=POLARIZED_CAPACITOR
T 54000 47900 5 10 1 1 180 0 1
refdes=C?
T 53000 47900 5 10 0 0 270 2 1
symversion=0.1
}
C 54800 47200 1 90 0 capacitor-1.sym
{
T 54100 47400 5 10 0 0 90 0 1
device=CAPACITOR
T 54900 47900 5 10 1 1 180 0 1
refdes=C?
T 53900 47400 5 10 0 0 90 0 1
symversion=0.1
}
C 53300 47200 1 90 0 capacitor-1.sym
{
T 52600 47400 5 10 0 0 90 0 1
device=CAPACITOR
T 53000 47900 5 10 1 1 180 0 1
refdes=C?
T 52400 47400 5 10 0 0 90 0 1
symversion=0.1
}
C 55600 47200 1 90 0 capacitor-1.sym
{
T 54900 47400 5 10 0 0 90 0 1
device=CAPACITOR
T 55700 47900 5 10 1 1 180 0 1
refdes=C?
T 54700 47400 5 10 0 0 90 0 1
symversion=0.1
}
C 54500 46900 1 0 0 gnd-1.sym
C 53300 46900 1 0 0 gnd-1.sym
N 53100 48100 53700 48100 4
N 53100 47200 53700 47200 4
C 55200 48100 1 0 0 3.3V-plus-1.sym
C 55300 46900 1 0 0 gnd-1.sym
C 61500 37800 1 0 1 gnd-1.sym
C 62000 38100 1 180 0 3.3V-plus-1.sym
N 56300 40800 55500 40800 4
{
T 55400 40700 5 10 1 1 0 6 1
netname=\_RESET\_
}
C 58900 44200 1 180 1 gnd-1.sym
N 59300 48400 58900 48400 4
{
T 58500 48400 5 10 1 1 0 0 1
netname=VPANEL
}
C 60400 47300 1 90 0 zener-1.sym
{
T 59800 47700 5 10 0 0 90 0 1
device=ZENER_DIODE
T 59900 47600 5 10 1 1 90 0 1
refdes=Z?
T 60600 47600 5 10 1 1 90 0 1
value=15V
}
C 59300 48300 1 0 0 resistor-1.sym
{
T 59600 48700 5 10 0 0 0 0 1
device=RESISTOR
T 59500 48600 5 10 1 1 0 0 1
refdes=R?
T 59300 48300 5 10 0 0 0 0 1
footprint=0603
}
N 60200 48200 60200 48400 4
N 60700 48400 60200 48400 4
N 54400 50500 54800 50500 4
{
T 54900 50500 5 10 1 1 0 0 1
netname=VPANEL
}
N 58400 50600 58000 50600 4
{
T 57700 50600 5 10 1 1 0 0 1
netname=VPANEL
}
C 58400 50400 1 0 0 schottky-1.sym
{
T 58722 51072 5 10 0 0 0 0 1
device=DIODE
T 58700 50900 5 10 1 1 0 0 1
refdes=D?
T 58741 51232 5 10 0 1 0 0 1
footprint=SOD80
}
C 58400 49600 1 0 0 schottky-1.sym
{
T 58722 50272 5 10 0 0 0 0 1
device=DIODE
T 58700 50100 5 10 1 1 0 0 1
refdes=D?
T 58741 50432 5 10 0 1 0 0 1
footprint=SOD80
}
N 59300 50600 59300 49800 4
N 58400 49800 58000 49800 4
{
T 57700 49800 5 10 1 1 0 0 1
netname=VBATT
}
C 60700 48600 1 270 0 vcc-1.sym
N 53400 48100 53400 48400 4
{
T 53500 48500 5 10 1 1 90 0 1
netname=VPANEL
}
C 54400 48100 1 0 0 vcc-1.sym
C 67200 41100 1 0 0 vcc-1.sym
N 69000 41000 69000 41200 4
{
T 69100 41300 5 10 1 1 90 0 1
netname=VPANEL
}
N 65900 48400 65000 48400 4
{
T 64900 48300 5 10 1 1 0 6 1
netname=VPANEL
}
C 56400 47200 1 90 0 capacitor-1.sym
{
T 55700 47400 5 10 0 0 90 0 1
device=CAPACITOR
T 56500 47900 5 10 1 1 180 0 1
refdes=C?
T 55500 47400 5 10 0 0 90 0 1
symversion=0.1
}
N 56200 48400 56200 48100 4
{
T 56300 48500 5 10 1 1 90 0 1
netname=VBATT
}
C 56100 46900 1 0 0 gnd-1.sym
C 71300 39000 1 0 1 gnd-1.sym
N 72200 40000 72700 40000 4
{
T 72800 40000 5 10 1 1 0 0 1
netname=CH2_BATT_IN
}
N 72200 40400 72700 40400 4
{
T 72800 40400 5 10 1 1 0 0 1
netname=CH2_BATT_EN
}
C 71400 41100 1 0 1 vcc-1.sym
C 72300 39200 1 0 1 ucc27518.sym
{
T 71600 40900 5 10 1 1 0 0 1
refdes=U?
T 71400 40400 5 10 0 0 0 6 1
device=UCC27518
T 71400 40600 5 10 0 0 0 6 1
footprint=SOT89
}
N 70100 40400 70200 40400 4
N 69600 41000 69600 41200 4
{
T 69700 41300 5 10 1 1 90 0 1
netname=VBATT
}
T 67200 34900 9 16 1 0 0 0 1
MCU-based solar battery charger
T 71100 34300 9 10 1 0 0 0 1
Ben Gamari
T 52500 38300 9 10 1 0 0 0 3
PWM pins
 TIM2: PA0, PA1, PA2, PA3
 TIM3: PA6, PA7, PB0, PB1
N 56300 39600 55500 39600 4
{
T 55400 39500 5 10 1 1 0 6 1
netname=CH1_IN
}
N 58600 38100 58600 37300 4
{
T 58700 37200 5 10 1 1 90 6 1
netname=CH2_PANEL_IN
}
N 59000 38100 59000 37300 4
{
T 59100 37200 5 10 1 1 90 6 1
netname=CH2_BATT_IN
}
T 52500 37700 9 10 1 0 0 0 2
ADC pins:
 PA2, PA3, PA4, PA5, PA6, PA7
N 56300 38800 55500 38800 4
{
T 55400 38700 5 10 1 1 0 6 1
netname=ISENSE1
}
N 57400 38100 57400 37300 4
{
T 57500 37200 5 10 1 1 90 6 1
netname=VSENSE1
}
N 57800 38100 57800 37300 4
{
T 57900 37200 5 10 1 1 90 6 1
netname=VSENSE2
}
N 56300 39200 55500 39200 4
{
T 55400 39100 5 10 1 1 0 6 1
netname=CH1_EN
}
N 58200 38100 58200 37300 4
{
T 58300 37200 5 10 1 1 90 6 1
netname=CH2_PANEL_EN
}
N 59400 38100 59400 37300 4
{
T 59500 37200 5 10 1 1 90 6 1
netname=CH2_BATT_EN
}
T 58000 47500 9 10 1 0 0 0 3
Shunt regulator to
avoid over-voltage
of MOSFET drivers
N 59800 38100 59800 37300 4
{
T 59900 37200 5 10 1 1 90 6 1
netname=VSENSE1_EN
}
N 62900 42400 63500 42400 4
{
T 63600 42300 5 10 1 1 0 0 1
netname=JTMS
}
N 61800 43900 61800 44500 4
{
T 61900 44600 5 10 1 1 90 0 1
netname=JTCK
}
N 61400 43900 61400 44500 4
{
T 61500 44600 5 10 1 1 90 0 1
netname=JTDI
}
N 61000 43900 61000 44500 4
{
T 61100 44600 5 10 1 1 90 0 1
netname=JTDO
}
N 60600 43900 60600 44500 4
{
T 60700 44600 5 10 1 1 90 0 1
netname=\_JRST\_
}
N 62900 42000 63700 42000 4
{
T 63800 41900 5 10 1 1 0 0 1
netname=LED1
}
C 52700 45100 1 270 1 resistor-1.sym
{
T 53100 45400 5 10 0 0 270 6 1
device=RESISTOR
T 53000 45300 5 10 1 1 270 6 1
refdes=R?
T 52700 45100 5 10 0 0 270 6 1
footprint=0603
}
C 52600 44200 1 270 1 led-1.sym
{
T 53200 45000 5 10 0 0 270 6 1
device=LED
T 52400 44400 5 10 1 1 270 6 1
refdes=LED1
T 53400 45000 5 10 0 0 270 6 1
symversion=0.1
}
N 52800 44200 52800 43800 4
{
T 52700 43700 5 10 1 1 270 0 1
netname=LED1
}
N 62900 41600 63700 41600 4
{
T 63800 41500 5 10 1 1 0 0 1
netname=LED2
}
C 52600 46000 1 0 0 3.3V-plus-1.sym
C 53700 45100 1 270 1 resistor-1.sym
{
T 54100 45400 5 10 0 0 270 6 1
device=RESISTOR
T 54000 45300 5 10 1 1 270 6 1
refdes=R?
T 53700 45100 5 10 0 0 270 6 1
footprint=0603
}
C 53600 44200 1 270 1 led-1.sym
{
T 54200 45000 5 10 0 0 270 6 1
device=LED
T 53400 44400 5 10 1 1 270 6 1
refdes=LED2
T 54400 45000 5 10 0 0 270 6 1
symversion=0.1
}
N 53800 44200 53800 43800 4
{
T 53700 43700 5 10 1 1 270 0 1
netname=LED2
}
C 53600 46000 1 0 0 3.3V-plus-1.sym
N 62900 40800 63700 40800 4
{
T 63800 40700 5 10 1 1 0 0 1
netname=BTN2
}
N 62900 41200 63700 41200 4
{
T 63800 41100 5 10 1 1 0 0 1
netname=BTN1
}
C 55500 45300 1 270 0 switch-pushbutton-no-1.sym
{
T 55800 44900 5 10 1 1 270 0 1
refdes=BTN1
T 56100 44900 5 10 0 0 270 0 1
device=SWITCH_PUSHBUTTON_NO
}
N 55500 45300 55500 45600 4
{
T 55400 45700 5 10 1 1 270 6 1
netname=BTN1
}
C 55400 44000 1 0 0 gnd-1.sym
C 56500 45300 1 270 0 switch-pushbutton-no-1.sym
{
T 56800 44900 5 10 1 1 270 0 1
refdes=BTN2
T 57100 44900 5 10 0 0 270 0 1
device=SWITCH_PUSHBUTTON_NO
}
N 56500 45300 56500 45600 4
{
T 56400 45700 5 10 1 1 270 6 1
netname=BTN2
}
C 56400 44000 1 0 0 gnd-1.sym
C 54600 45300 1 270 0 switch-pushbutton-no-1.sym
{
T 54900 45100 5 10 1 1 270 0 1
refdes=RESET
T 55200 44900 5 10 0 0 270 0 1
device=SWITCH_PUSHBUTTON_NO
}
N 54600 45300 54600 45600 4
{
T 54500 45700 5 10 1 1 270 6 1
netname=\_RESET\_
}
C 54500 44000 1 0 0 gnd-1.sym
C 68000 48200 1 0 0 schottky-1.sym
{
T 68322 48872 5 10 0 0 0 0 1
device=DIODE
T 68300 48700 5 10 1 1 0 0 1
refdes=D?
T 68341 49032 5 10 0 1 0 0 1
footprint=SOD80
}
N 68000 48400 67800 48400 4
N 66100 50100 66500 50100 4
C 67800 47300 1 0 0 gnd-1.sym
C 64800 45500 1 0 0 gnd-1.sym
N 63900 46500 63400 46500 4
{
T 63300 46400 5 10 1 1 0 6 1
netname=CH1_IN
}
N 63900 46900 63400 46900 4
{
T 63300 46800 5 10 1 1 0 6 1
netname=CH1_EN_A
}
C 63800 45700 1 0 0 ucc27518.sym
{
T 65600 47500 5 10 1 1 180 0 1
refdes=U?
T 64700 46900 5 10 0 0 0 0 1
device=UCC27518
T 64700 47100 5 10 0 0 0 0 1
footprint=SOT89
}
C 64700 47600 1 0 0 vcc-1.sym
N 65900 46900 67400 46900 4
C 67000 47500 1 90 0 schottky-1.sym
{
T 66328 47822 5 10 0 0 90 0 1
device=DIODE
T 66600 48000 5 10 1 1 180 0 1
refdes=D?
T 66168 47841 5 10 0 1 90 0 1
footprint=SOD80
}
N 66700 48400 66900 48400 4
C 66700 47200 1 0 0 gnd-1.sym
N 67400 46900 67400 47800 4
C 68800 48400 1 270 0 capacitor-2.sym
{
T 69500 48200 5 10 0 0 270 0 1
device=POLARIZED_CAPACITOR
T 68900 47800 5 10 1 1 180 0 1
refdes=C?
T 69700 48200 5 10 0 0 270 0 1
symversion=0.1
}
N 68900 48400 69500 48400 4
N 69500 48400 69500 46000 4
C 68900 47200 1 0 0 gnd-1.sym
N 66500 50100 66500 48900 4
C 66700 48900 1 90 1 nmos-3.sym
{
T 66200 48300 5 10 0 0 270 2 1
device=NMOS_TRANSISTOR
T 65700 48700 5 10 1 1 0 2 1
refdes=Q?
}
C 67500 45200 1 0 0 nmos-3.sym
{
T 68100 45700 5 10 0 0 180 8 1
device=NMOS_TRANSISTOR
T 67700 45700 5 10 1 1 0 8 1
refdes=Q?
}
C 67400 47600 1 0 0 nmos-3.sym
{
T 68000 48100 5 10 0 0 180 8 1
device=NMOS_TRANSISTOR
T 67500 48100 5 10 1 1 0 8 1
refdes=Q?
}
C 68500 40200 1 0 0 nmos-3.sym
{
T 69100 40700 5 10 0 0 180 8 1
device=NMOS_TRANSISTOR
T 68600 40500 5 10 1 1 270 8 1
refdes=Q?
}
C 70100 40200 1 0 1 nmos-3.sym
{
T 69500 40700 5 10 0 0 180 2 1
device=NMOS_TRANSISTOR
T 70000 40500 5 10 1 1 270 6 1
refdes=Q?
}
C 69000 39000 1 90 0 schottky-1.sym
{
T 68328 39322 5 10 0 0 90 0 1
device=DIODE
T 68600 39500 5 10 1 1 180 0 1
refdes=D?
T 68168 39341 5 10 0 1 90 0 1
footprint=SOD80
}
N 69000 40200 69000 39900 4
N 68800 39900 69300 39900 4
C 68700 38700 1 0 0 gnd-1.sym
C 69100 37900 1 270 0 capacitor-2.sym
{
T 69800 37700 5 10 0 0 270 0 1
device=POLARIZED_CAPACITOR
T 69000 37500 5 10 1 1 0 0 1
refdes=C?
T 70000 37700 5 10 0 0 270 0 1
symversion=0.1
}
C 69200 36700 1 0 0 gnd-1.sym
