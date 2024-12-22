corner file:


# Corner ff_m40c constraints

set_parasitic_parameters -early_spec minTLU -late_spec minTLU

set_temperature -55
set_process_number 1.01
set_process_label fast

set_voltage 1.16  -object_list VDD
set_voltage 0.00  -object_list VSS

set_timing_derate -late 1.05 -cell_delay -net_delay


# Corner ss_125c constraints

set_parasitic_parameters -early_spec maxTLU -late_spec maxTLU

set_temperature 125
set_process_number 0.99
set_process_label slow

set_voltage 0.95  -object_list VDD
set_voltage 0.00  -object_list VSS

set_timing_derate -early 0.93 -cell_delay -net_delay


# Corner ss_125c constraints

set_parasitic_parameters -early_spec maxTLU -late_spec maxTLU

set_temperature -40
set_process_number 0.99
set_process_label slow

set_voltage 0.95  -object_list VDD
set_voltage 0.00  -object_list VSS

set_timing_derate -early 0.93 -cell_delay -net_delay
