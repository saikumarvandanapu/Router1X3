scenario file:

# scenario constraints func @ ff_-40c

set_driving_cell -lib_cell INVX8_LVT [get_ports router_clock]
set_driving_cell -lib_cell INVX8_RVT [remove_from_collection [all_inputs] [get_ports router_clock]]

set_clock_uncertainty -setup 0.1 [get_clocks Router_CLK]
set_clock_latency 0.3 [get_clocks Router_CLK]
set_clock_transition 0.1 [get_clocks Router_CLK]

set_input_delay  -add_delay -max 0.6 -clock Router_CLK [remove_from_collection [all_inputs] [get_ports router_clock]]
set_output_delay -add_delay -max 0.3 -clock Router_CLK [all_outputs]


# scenario constraints func @ ss_125c

set_driving_cell -lib_cell INVX8_LVT [get_ports router_clock]
set_driving_cell -lib_cell INVX8_RVT [remove_from_collection [all_inputs] [get_ports router_clock]]

set_clock_uncertainty -setup 0.3 [get_clocks Router_CLK]
set_clock_latency 0.6 [get_clocks Router_CLK]
set_clock_transition 0.2 [get_clocks Router_CLK]

set_input_delay  -add_delay -max 1.0 -clock Router_CLK [remove_from_collection [all_inputs] [get_ports router_clock]]
set_output_delay -add_delay -max 0.5 -clock Router_CLK [all_outputs]


# scenario constraints func @ ss_m40c

set_driving_cell -lib_cell INVX8_LVT [get_ports router_clock]
set_driving_cell -lib_cell INVX8_RVT [remove_from_collection [all_inputs] [get_ports router_clock]]

set_clock_uncertainty -setup 0.2 [get_clocks Router_CLK]
set_clock_latency 0.4 [get_clocks Router_CLK]
set_clock_transition 0.2 [get_clocks Router_CLK]

set_input_delay  -add_delay -max 1.0 -clock Router_CLK [remove_from_collection [all_inputs] [get_ports router_clock]]
set_output_delay -add_delay -max 0.5 -clock Router_CLK [all_outputs]


# scenario constraints test @ ss_125c

set_driving_cell -lib_cell INVX8_LVT [get_ports router_clock]
set_driving_cell -lib_cell INVX8_RVT [remove_from_collection [all_inputs] [get_ports router_clock]]

set_clock_uncertainty -setup 0.3 [get_clocks Router_CLK]
set_clock_latency 0.6 [get_clocks Router_CLK]
set_clock_transition 0.2 [get_clocks Router_CLK]

set_input_delay  -add_delay -max 5.0 -clock Router_CLK [remove_from_collection [all_inputs] [get_ports router_clock]]
set_output_delay -add_delay -max 5.0 -clock Router_CLK [all_outputs]


# scenario constraints test @ ss_m40c

set_driving_cell -lib_cell INVX8_LVT [get_ports router_clock]
set_driving_cell -lib_cell INVX8_RVT [remove_from_collection [all_inputs] [get_ports router_clock]]

set_clock_uncertainty -setup 0.3 [get_clocks Router_CLK]
set_clock_latency 0.6 [get_clocks Router_CLK]
set_clock_transition 0.2 [get_clocks Router_CLK]

set_input_delay  -add_delay -max 5.0 -clock Router_CLK [remove_from_collection [all_inputs] [get_ports router_clock]]
set_output_delay -add_delay -max 5.0 -clock Router_CLK [all_outputs]
