create_clock -name clk_i -period 10.000 [get_ports {clk_i}]
set_false_path -from [get_ports {rst_n_i}] -to [get_clocks {clk_i}]