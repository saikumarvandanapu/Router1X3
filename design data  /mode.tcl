#Functional Mode

# System clock
create_clock -period 5.0 -name Router_CLK [get_ports router_clock]


#Test Mode

# System clock
create_clock -period 30.0 -name Router_CLK [get_ports router_clock]
