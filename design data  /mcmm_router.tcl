design data file


remove_scenarios -all
remove_modes -all
remove_corners -all


set m_constr(func)         "risc_core_m_func.tcl"
#set m_constr(test)         "risc_core_m_test.tcl"

set c_constr(ss_125c)      "risc_core_c_ss_125c.tcl"
#set c_constr(ss_m40c)      "risc_core_c_ss_m40c.tcl"
#set c_constr(ff_m40c)      "risc_core_c_ff_m40c.tcl"

set s_constr(func.ss_125c) "risc_core_s_func.ss_125c.tcl"
#set s_constr(func.ss_m40c) "risc_core_s_func.ss_m40c.tcl"
#set s_constr(func.ff_m40c) "risc_core_s_func.ff_m40c.tcl"
#set s_constr(test.ss_125c) "risc_core_s_test.ss_125c.tcl"
#set s_constr(test.ff_m40c) "risc_core_s_test.ss_m40c.tcl"

########################################
## Mode, corner and scenario creation
########################################

foreach m [array names m_constr] {
	create_mode $m
}

foreach c [array names c_constr] {
	create_corner $c
}

foreach s [array names s_constr] {
	lassign [split $s "."] m c
	create_scenario -name $s -mode $m -corner $c
}

########################################
## Populate modes, corners and scenarios
########################################

foreach m [array names m_constr] {
	current_mode $m
	source $m_constr($m)
}

foreach c [array names c_constr] {
	current_corner $c
	source $c_constr($c)
}

foreach s [array names s_constr] {
	current_scenario $s
	source $s_constr($s)
}

########################################
## Configure scenarios
########################################
set_scenario_status {func.ss_125c} -hold false
set_scenario_status func.ss_125c -leakage_power false -dynamic_power false
set_scenario_status func.ss_125c -leakage_power true -dynamic_power true

puts "RM-info : Completed script [info script]\n"
