module master_module
(
	input clk_i,
	input rst_n_i,

	main_int.master_in m,
	main_int.master_out s0,
	main_int.master_out s1,

	output logic [30:0] addr,
	output logic cmd,
	output logic [31:0] wdata
);

	logic capture_ans;
	logic slave_num;

	always_ff @(posedge clk_i or negedge rst_n_i)begin
		if(!rst_n_i)begin
			s0.req <= 0;
			s1.req <= 0;
			cmd <= 0;
			addr <= '0;
			wdata <= '0;
			m.ack <= 0;
			m.resp <= 0;
			m.rdata <= '0;
			capture_ans <= 0;
			slave_num <= 0;
		end else begin
			if(!capture_ans)begin
				m.ack <= 0;
				m.resp <= 0;
				if(m.req)begin
					capture_ans <= 1;
					addr <= m.addr;
					cmd <= m.cmd;
					wdata <= m.wdata;
					if(m.slave_addr)begin
						s1.req <= 1;
						s0.req <= 0;
						slave_num <= 1;
					end else begin
						s0.req <= 1;
						s1.req <= 0;
						slave_num <= 0;
					end
				end
			end else begin
				m.ack <= 0;
				m.resp <= 0;
				if(slave_num)begin
					if(cmd)begin
						if(s1.req)begin
							if(s1.ack)begin
								m.ack <= 1;
								s1.req <= 0;
							end
						end else if(!m.req) capture_ans <= 0;
					end else begin
						if(s1.req)begin
							if(s1.ack) m.ack <= 1;
							if(s1.resp)begin
								s1.req <= 0;
								m.resp <= 1;
								m.rdata <= s1.rdata;
							end
						end else if(!m.req)	capture_ans <= 0;
					end
				end else begin
					if(cmd)begin
						if(s0.req)begin
							if(s0.ack)begin
								m.ack <= 1;
								s0.req <= 0;
							end
						end else if(!m.req) capture_ans <= 0;
					end else begin
						if(s0.req)begin
							if(s0.ack) m.ack <= 1;
							if(s0.resp)begin
								s0.req <= 0;
								m.resp <= 1;
								m.rdata <= s0.rdata;
							end
						end else if(!m.req)	capture_ans <= 0;
					end
				end
			end
		end
	end

endmodule : master_module