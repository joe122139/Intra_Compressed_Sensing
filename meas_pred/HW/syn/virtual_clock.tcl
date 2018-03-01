set mydesign SAD

set  CLK_PERIOD 5
set  CLK_NAME   clk         

#create_clock -period $CLK_PERIOD -name $CLK_NAME [get_ports $CLK_NAME]


set source_directory {../rtl}
set source_directory_ {../stdcore/rtl}

set search_path {. /eda/smic.40ll/arm/smic/logic0040ll/sc12mc_base_lvt_c40/r0p2/db /eda/synopsys.syn.vI-2013.12-SP2/libraries/syn}

set search_path [concat $search_path $source_directory $source_directory_]

set LIBRARY_SLOW sc12mc_logic0040ll_base_lvt_c40_ss_typical_max_0p99v_125c
set LIBRARY_FAST sc12mc_logic0040ll_base_lvt_c40_ff_typical_min_1p21v_m40c

#set LIBRARY_SLOW_MEM_SP rf_sp_26x360m4_ss_0p99v_0p99v_125c.db
#set LIBRARY_FAST_MEM_SP rf_sp_26x360m4_ff_1p21v_1p21v_m40c.db

#set target_library "$LIBRARY_SLOW.db $LIBRARY_SLOW_MEM_SP"
#set link_library "$LIBRARY_SLOW.db $LIBRARY_FAST.db $LIBRARY_SLOW_MEM_SP $LIBRARY_FAST_MEM_SP"

set target_library "$LIBRARY_SLOW.db"
set link_library "$LIBRARY_SLOW.db $LIBRARY_FAST.db "

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


set synthetic_library {dw_foundation.sldb}
  
set folder [clock format [clock seconds] -gmt false -format "%Y%m%d"]
if { ! [file exists $folder]} {
  file mkdir $folder
}


set acs_sverilog_extensions ".sveri .sysver .sv"
set acs_hdl_source $source_directory	
acs_read_hdl -recurse -format sverilog -verbose $mydesign -no_elaborate > $mydesign.acs.log
elaborate $mydesign > $folder/$mydesign.elab.log
uniquify
current_design $mydesign
set_wire_load_mode top
set_min_library slow.db -min_version fast.db

#set clock_ports [get_ports $CLK_NAME]

create_clock -period $CLK_PERIOD -name $CLK_NAME

set_propagated_clock $CLK_NAME
set_dont_touch_network $CLK_NAME

#set_drive 0 [get_ports $CLK_NAME]
#set_drive 0 [$CLK_NAME]

set_input_delay [expr ($CLK_PERIOD * 0)] -clock $CLK_NAME  [all_inputs]
set_output_delay [expr ($CLK_PERIOD * 0)] -clock $CLK_NAME  [all_outputs]
#remove_input_delay $clock_ports
remove_input_delay $CLK_NAME

set_boundary_optimization $mydesign true
set_fix_multiple_port_nets -feedthroughs -all -buffer_constants

link
check_design > $folder/check_design.rep

compile_ultra -no_autoungroup > $folder/$mydesign.compile.txt


write_file -format verilog -hierarchy -output ./$folder/$mydesign.vnet
write_sdc ./$folder/$mydesign.sdc
report_area > ./$folder/$mydesign.area$CLK_PERIOD.txt
report_timing > ./$folder/$mydesign.timing$CLK_PERIOD.txt
report_power > ./$folder/$mydesign.power.txt
report_qor > ./$folder/$mydesign.qor$CLK_PERIOD.txt

