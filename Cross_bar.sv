module Cross_bar
(
	input clk_i,
	input rst_n_i,
	main_int.master_in m0,
	main_int.master_in m1,
	main_int.slave_out s0,
	main_int.slave_out s1
);

	main_int m00_bus ();
	main_int m01_bus ();
	main_int m10_bus ();
	main_int m11_bus ();

	logic [30:0] master0_addr;
	logic master0_cmd;
	logic [31:0] master0_wdata;

	master_module master0(
	.*,
	.m(m0),
	.s0(m00_bus),
	.s1(m01_bus),
	.addr(master0_addr),
	.cmd(master0_cmd),
	.wdata(master0_wdata)
	);

	assign m00_bus.addr = master0_addr;
	assign m01_bus.addr = master0_addr;
	assign m00_bus.cmd = master0_cmd;
	assign m01_bus.cmd = master0_cmd;
	assign m00_bus.wdata = master0_wdata;
	assign m01_bus.wdata = master0_wdata;

	logic [30:0] master1_addr;
	logic master1_cmd;
	logic [31:0] master1_wdata;

	master_module master1(
	.*,
	.m(m1),
	.s0(m10_bus),
	.s1(m11_bus),
	.addr(master1_addr),
	.cmd(master1_cmd),
	.wdata(master1_wdata)
	);

	assign m10_bus.addr = master1_addr;
	assign m11_bus.addr = master1_addr;
	assign m10_bus.cmd = master1_cmd;
	assign m11_bus.cmd = master1_cmd;
	assign m10_bus.wdata = master1_wdata;
	assign m11_bus.wdata = master1_wdata;

	slave_module slave0(
	.*,
	.m0(m00_bus),
	.m1(m10_bus),
	.s(s0)
	);

	slave_module slave1(
	.*,
	.m0(m01_bus),
	.m1(m11_bus),
	.s(s1)
	);

endmodule : Cross_bar