# AMHRA top-level SDC
create_clock -name clk -period 10.000 [get_ports clk]
set_clock_uncertainty -setup 0.20 [get_clocks clk]
set_clock_uncertainty -hold  0.10 [get_clocks clk]

set_input_delay  1.0 -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay 1.0 -clock clk [all_outputs]

set_false_path -from [get_ports reset_n]
set_input_transition 0.10 [all_inputs]
set_load 0.05 [all_outputs]
set_max_fanout 16 [current_design]
