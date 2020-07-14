interface main_int;

	logic req;
	logic slave_addr;
	logic [30:0] addr;
	logic cmd;
	logic [31:0] wdata;

	logic ack;
	logic resp;
	logic [31:0] rdata;

	modport master_in (	input req,
						input slave_addr,
						input addr,
						input cmd,
						input wdata,
						output ack,
						output resp,
						output rdata);

	modport master_out (output req,
						input ack,
						input resp,
						input rdata);

	modport slave_in (	input req,
						input addr,
						input cmd,
						input wdata,
						output ack,
						output resp,
						output rdata);

	modport slave_out (	output req,
						output addr,
						output cmd,
						output wdata,
						input ack,
						input resp,
						input rdata);

endinterface

`timescale 1ns / 1ps

module TOP_tb();

	localparam int clk_period = 5;

	bit clk_i = 0;
	bit rst_n_i = 1;

	main_int m0();
	main_int m1();

	main_int s0();
	main_int s1();

Cross_bar DUT
(
	.*,
	.clk_i(clk_i),
	.rst_n_i(rst_n_i)
);

initial begin
	forever #(clk_period/2) clk_i = ~clk_i;
end

initial begin
	m0.req = 0;
	m0.slave_addr = 0;
	m0.addr = 0;
	m0.cmd = 0;
	m0.wdata = 0;
	
	m1.req = 0;
	m1.slave_addr = 0;
	m1.addr = 0;
	m1.cmd = 0;
	m1.wdata = 0;

	s0.ack = 0;
	s0.resp = 0;
	s0.rdata = '0;
	
	s1.ack = 0;
	s1.resp = 0;
	s1.rdata = '0;
end

initial begin

	// reset --------------------------------
	rst_n_i = 0;
	repeat(10) @(posedge clk_i); 
	rst_n_i = 1;
	repeat(10) @(posedge clk_i); 

	// write master0 -> slave0,slave1 --------------------
	repeat(5)begin
	@(posedge clk_i);
		m0.slave_addr = $urandom_range(1);
		m0.addr = $urandom;
		m0.cmd = 1;
		m0.wdata = $urandom;
		m0.req = 1;
	@(posedge m0.ack);
	@(posedge clk_i);
		m0.req = 0;
	end

	// write master1 -> slave0,slave1 -------------------
	repeat(5)begin
	@(posedge clk_i);
		m1.slave_addr = $urandom_range(1);
		m1.addr = $urandom;
		m1.cmd = 1;
		m1.wdata = $urandom;
		m1.req = 1;
	@(posedge m1.ack);
	@(posedge clk_i);
		m1.req = 0;
	end

	// read m0 -> s0,s1 ---------------------
	repeat(5)begin
	@(posedge clk_i);
		m0.slave_addr = $urandom_range(1);
		m0.addr = $urandom;
		m0.cmd = 0;
		m0.wdata = $urandom;
		m0.req = 1;
	@(posedge m0.ack);
	@(posedge clk_i);
		m0.req = 0;
	@(posedge m0.resp);
	@(posedge clk_i);
	end	

	// read m1 -> s0,s1 ---------------------
	repeat(5)begin
	@(posedge clk_i);
		m1.slave_addr = $urandom_range(1);
		m1.addr = $urandom;
		m1.cmd = 0;
		m1.wdata = $urandom;
		m1.req = 1;
	@(posedge m1.ack);
	@(posedge clk_i);
		m1.req = 0;
	@(posedge m1.resp);
	@(posedge clk_i);
	end

	repeat(10) @(posedge clk_i);

	// concurrent write operation -----------
	@(posedge clk_i);
		m0.req = 1;
		m0.slave_addr = 0;
		m0.addr = $urandom;
		m0.cmd = 1;
		m0.wdata = $urandom;

		m1.req = 1;
		m1.slave_addr = 0;
		m1.addr = $urandom;
		m1.cmd = 1;
		m1.wdata = $urandom;
	repeat(2) begin
		@(posedge m0.ack or m1.ack);
		@(posedge clk_i);
		if(m1.ack)
			m1.req = 0;
		else if (m0.ack)
			m0.req = 0;
	end

	repeat(10) @(posedge clk_i);
	
	// concurrent read operation -----------
	@(posedge clk_i);
		m0.req = 1;
		m0.slave_addr = 0;
		m0.addr = $urandom;
		m0.cmd = 0;

		m1.req = 1;
		m1.slave_addr = 0;
		m1.addr = $urandom;
		m1.cmd = 0;
	repeat(2) begin
		@(posedge m0.ack or m1.ack);
		@(posedge clk_i);
		if(m1.ack)
			m1.req = 0;
		else if (m0.ack)
			m0.req = 0;
	end

	#100;
	$stop;
end

// slave0 device response behavior
initial begin
	while(1) begin
		@(posedge s0.req);
		if(s0.req && s0.cmd)begin
			@(posedge clk_i);
			s0.ack = 1;
			@(posedge clk_i);
			s0.ack = 0;
		end else if (s0.req && !s0.cmd)begin
			@(posedge clk_i);
			s0.ack = 1;
			repeat(4)
				@(posedge clk_i);
			s0.resp = 1;
			s0.rdata = $urandom;
			@(posedge clk_i);
			s0.resp = 0;
			s0.ack = 0;
		end
	end
end

// slave1 device response behavior
initial begin
	while(1) begin
		@(posedge s1.req);
		if(s1.req && s1.cmd)begin
			@(posedge clk_i);
			s1.ack = 1;
			@(posedge clk_i);
			s1.ack = 0;
		end else if (s1.req && !s1.cmd)begin
			@(posedge clk_i);
			s1.ack = 1;
			repeat(4)
				@(posedge clk_i);
			s1.resp = 1;
			s1.rdata = $urandom;
			@(posedge clk_i);
			s1.resp = 0;
			s1.ack = 0;
		end
	end
end

endmodule : TOP_tb