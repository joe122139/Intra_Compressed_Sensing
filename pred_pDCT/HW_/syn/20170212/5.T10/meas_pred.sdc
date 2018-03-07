###################################################################

# Created by write_sdc on Sun Feb 12 20:23:53 2017

###################################################################
set sdc_version 2.0

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_operating_conditions -max ss_typical_max_0p99v_125c -max_library           \
sc12mc_logic0040ll_base_lvt_c40_ss_typical_max_0p99v_125c\
                         -min ff_typical_min_1p21v_m40c -min_library           \
sc12mc_logic0040ll_base_lvt_c40_ff_typical_min_1p21v_m40c
set_wire_load_mode top
set_wire_load_model -name Small -library                                       \
sc12mc_logic0040ll_base_lvt_c40_ss_typical_max_0p99v_125c
create_clock [get_ports clk]  -period 5  -waveform {0 2.5}
set_clock_uncertainty -setup 0.1  [get_clocks clk]
set_propagated_clock [get_clocks clk]
