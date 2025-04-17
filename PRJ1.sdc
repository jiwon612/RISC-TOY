#************************************************************
# THIS IS A WIZARD-GENERATED FILE.                           
#
# Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition
#
#************************************************************

# Copyright (C) 1991-2013 Altera Corporation
# Your use of Altera Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License 
# Subscription Agreement, Altera MegaCore Function License 
# Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the 
# applicable agreement for further details.



# Clock constraints

create_clock -name "CLK50M" -period 20.0ns [get_ports {CLK50M}] -waveform {0.000 10.000}
create_generated_clock -name "CLK1K" -divide_by 10 -source [get_ports {CLK50M}] [get_nets {clkgen1k|CLK1K}]
create_generated_clock -name "CLK1H" -divide_by 10 -source [get_nets {clkgen1k|CLK1K}] [get_nets {DUT|clkgen1h|CLK1H}]

# Automatically constrain PLL and other generated clocks
derive_pll_clocks -create_base_clocks

# Automatically calculate clock uncertainty to jitter and other effects.
#derive_clock_uncertainty
# Not supported for family Cyclone II

# tsu/th constraints
set_false_path -from [get_ports {RSTN}]

set_input_delay -clock "CLK1K" -max 3ns [get_ports {SW1}] 
set_input_delay -clock "CLK1K" -min 0.000ns [get_ports {SW1}] 
set_input_delay -clock "CLK1K" -max 3ns [get_ports {RSTN}] 
set_input_delay -clock "CLK1K" -min 0.000ns [get_ports {RSTN}] 
set_input_delay -clock "CLK1K" -max 3ns [get_ports {SW2}] 
set_input_delay -clock "CLK1K" -min 0.000ns [get_ports {SW2}] 
set_input_delay -clock "CLK1K" -max 3ns [get_ports {SW3}] 
set_input_delay -clock "CLK1K" -min 0.000ns [get_ports {SW3}] 
set_input_delay -clock "CLK1K" -max 3ns [get_ports {SW4}] 
set_input_delay -clock "CLK1K" -min 0.000ns [get_ports {SW4}] 
set_input_delay -clock "CLK1K" -max 3ns [get_ports {SW5}] 
set_input_delay -clock "CLK1K" -min 0.000ns [get_ports {SW5}] 
set_input_delay -clock "CLK1K" -max 3ns [get_ports {SW6}] 
set_input_delay -clock "CLK1K" -min 0.000ns [get_ports {SW6}] 
set_input_delay -clock "CLK1K" -max 3ns [get_ports {KEY1}] 
set_input_delay -clock "CLK1K" -min 0.000ns [get_ports {KEY1}] 
set_input_delay -clock "CLK1K" -max 3ns [get_ports {KEY2}] 
set_input_delay -clock "CLK1K" -min 0.000ns [get_ports {KEY2}] 
set_input_delay -clock "CLK1K" -max 3ns [get_ports {KEY3}] 
set_input_delay -clock "CLK1K" -min 0.000ns [get_ports {KEY3}] 
set_input_delay -clock "CLK1H" -max 3ns [get_ports {SOUNDSENSOR}] 
set_input_delay -clock "CLK1H" -min 0.000ns [get_ports {SOUNDSENSOR}] 
set_input_delay -clock "CLK1K" -max 3ns [get_ports {TOUCH_IN}] 
set_input_delay -clock "CLK1K" -min 0.000ns [get_ports {TOUCH_IN}] 

# tco constraint

set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_0[0]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_0[0]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_0[1]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_0[1]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_0[2]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_0[2]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_0[3]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_0[3]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_0[4]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_0[4]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_0[5]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_0[5]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_0[6]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_0[6]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_1[0]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_1[0]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_1[1]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_1[1]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_1[2]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_1[2]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_1[3]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_1[3]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_1[4]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_1[4]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_1[5]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_1[5]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_1[6]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_1[6]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_2[0]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_2[0]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_2[1]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_2[1]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_2[2]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_2[2]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_2[3]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_2[3]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_2[4]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_2[4]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_2[5]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_2[5]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_2[6]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_2[6]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_3[0]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_3[0]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_3[1]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_3[1]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_3[2]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_3[2]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_3[3]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_3[3]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_3[4]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_3[4]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_3[5]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_3[5]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_3[6]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_3[6]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_4[0]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_4[0]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_4[1]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_4[1]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_4[2]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_4[2]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_4[3]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_4[3]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_4[4]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_4[4]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_4[5]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_4[5]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_4[6]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_4[6]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_5[0]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_5[0]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_5[1]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_5[1]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_5[2]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_5[2]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_5[3]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_5[3]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_5[4]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_5[4]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_5[5]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_5[5]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_5[6]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_5[6]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_6[0]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_6[0]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_6[1]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_6[1]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_6[2]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_6[2]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_6[3]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_6[3]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_6[4]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_6[4]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_6[5]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_6[5]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_6[6]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_6[6]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_7[0]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_7[0]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_7[1]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_7[1]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_7[2]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_7[2]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_7[3]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_7[3]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_7[4]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_7[4]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_7[5]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_7[5]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {SEG7_7[6]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {SEG7_7[6]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {LEDG_OUT[3]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {LEDG_OUT[3]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {LEDG_OUT[2]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {LEDG_OUT[2]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {LEDG_OUT[1]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {LEDG_OUT[1]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {LEDG_OUT[0]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {LEDG_OUT[0]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {LCD_DATA[0]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {LCD_DATA[0]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {LCD_DATA[1]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {LCD_DATA[1]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {LCD_DATA[2]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {LCD_DATA[2]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {LCD_DATA[3]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {LCD_DATA[3]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {LCD_DATA[4]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {LCD_DATA[4]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {LCD_DATA[5]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {LCD_DATA[5]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {LCD_DATA[6]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {LCD_DATA[6]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {LCD_DATA[7]}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {LCD_DATA[7]}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {LCD_ENABLE}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {LCD_ENABLE}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {LCD_BLON}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {LCD_BLON}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {LCD_ON}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {LCD_ON}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {LCD_RS}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {LCD_RS}] 
set_output_delay -clock "CLK1K" -max 3ns [get_ports {LCD_RW}] 
set_output_delay -clock "CLK1K" -min -0.000ns [get_ports {LCD_RW}] 


# tpd constraints

