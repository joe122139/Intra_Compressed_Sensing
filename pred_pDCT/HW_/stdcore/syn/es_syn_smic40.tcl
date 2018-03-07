#
# design compiler script using SMIC 40nm library
#

# define the top model
set top_model stdcore_asyncfifo

#define the clock period
set clock_period 1.5

set folder [clock format [clock seconds] -gmt false -format "%Y%m%d"]
if { ! [file exists $folder]} {
  file mkdir $folder
}

set source_directory {../rtl ../../stdcore/rtl}

#
# paths and libraries
#

set search_path {. /eda/smic.40ll/arm/smic/logic0040ll/sc12mc_base_lvt_c40/r0p2/db /eda/synopsys.syn.vI-2013.12-SP2/libraries/syn}

set search_path [concat $search_path $source_directory]

set LIBRARY_SLOW sc12mc_logic0040ll_base_lvt_c40_ss_typical_max_0p99v_125c
set LIBRARY_FAST sc12mc_logic0040ll_base_lvt_c40_ff_typical_min_1p21v_m40c

set target_library "$LIBRARY_SLOW.db"
set link_library "$LIBRARY_SLOW.db $LIBRARY_FAST.db"

set link_library [concat * $link_library dw_foundation.sldb]
set symbol_library {}


set verilogout_no_tri true
set verilogout_show_unconnected_pins true
set bus_naming_style {%s[%d]}
define_name_rules myrules \
  -case_insensitive \
  -allowed {A-Za-z0-9_} \
  -first_restricted "0-9_" \
  -last_restricted "_" \
  -equal_ports_nets



set mydesign $top_model

#set_svf $mydesign.svf

set hdlin_vrlg_std 2001

set acs_hdl_source $source_directory
acs_read_hdl -recurse -format verilog -verbose $mydesign -no_elaborate > $folder/$mydesign.acs.log

#analyze -format verilog $mydesign

elaborate $mydesign > $folder/$mydesign.elab.log
uniquify

current_design $mydesign



set_wire_load_mode top
set_operating_conditions -min ff_typical_min_1p21v_m40c -max ss_typical_max_0p99v_125c -analysis_type bc_wc

set_min_library $LIBRARY_SLOW.db -min_version $LIBRARY_FAST.db

#
# clock definitions
#
# unit: ns
#

set  CLK_PERIOD $clock_period
set  CLK_NAME   p_clk
set  CLK_NAME_C   c_clk

create_clock -period $CLK_PERIOD -name p_clk [get_ports $CLK_NAME]

set clock_ports [get_ports $CLK_NAME]

set_clock_uncertainty -setup 0.1 $CLK_NAME
set_propagated_clock $CLK_NAME
set_dont_touch_network $CLK_NAME
set_drive 0 $clock_ports

set_input_delay 0.1 -clock $CLK_NAME  [all_inputs]
set_output_delay 0.1 -clock $CLK_NAME  [all_outputs]
remove_input_delay $clock_ports

create_clock -period $CLK_PERIOD -name c_clk [get_ports $CLK_NAME_C]

set clock_ports [get_ports $CLK_NAME_C]

set_clock_uncertainty -setup 0.1 $CLK_NAME_C
set_propagated_clock $CLK_NAME_C
set_dont_touch_network $CLK_NAME_C
set_drive 0 $clock_ports

set_input_delay 0.1 -clock $CLK_NAME_C  [all_inputs]
set_output_delay 0.1 -clock $CLK_NAME_C  [all_outputs]
remove_input_delay $clock_ports

set_ideal_network arst_n
#set_ideal_network rst_n

#set_ultra_optimization true
set_boundary_optimization $mydesign true
set_fix_multiple_port_nets -feedthroughs -all -buffer_constants

link
check_design > $folder/check_design.rep

#set_host_options -max_cores 2
compile_ultra -no_autoungroup
#compile

#group -all -flatten
#remove_unconnected_ports [get_cells -h]
change_name -h -rules myrules

write -f verilog -h -o $folder/$mydesign.vnet
#write -h -o $folder/$mydesign.db
write_sdc $folder/$mydesign.sdc
write_sdf $folder/$mydesign.sdf
report_area > $folder/$mydesign.area.rep
report_timing > $folder/$mydesign.timing.rep
report_timing -max_paths 100 > $folder/$mydesign.paths.rep
#report_power > $folder/$mydesign.power.rep
report_qor > $folder/$mydesign.qor.rep

#set_svf -off
