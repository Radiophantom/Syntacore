module slave_module
(
	input clk_i,
	input rst_n_i,

	main_int.slave_in m0,
	main_int.slave_in m1,
	main_int.slave_out s
);

	logic prev_master;
	logic busy;
	logic response_flag;

	always_ff @(posedge clk_i or negedge rst_n_i)begin
		if(!rst_n_i)begin
			m0.ack <= 0;
			m1.ack <= 0;
			m0.resp <= 0;
			m1.resp <= 0;
			busy <= 0;
			prev_master <= 0;
			s.addr <= '0;
			s.cmd <= 0;
			s.wdata <= '0;
			s.req <= 0;
			m0.rdata <= '0;
			m1.rdata <= '0;
			response_flag <= 0;
		end else begin
			if(!busy)begin
				m0.resp <= 0;
				m1.resp <= 0;
				m0.ack <= 0;
				m1.ack <= 0;
				s.req <= 0;
				response_flag <= 0;
				if(m0.req == 1 && m1.req == 1)begin
					s.req <= 1;
					busy <= 1;
					prev_master <= ~prev_master;
					if(prev_master)begin
						s.addr <= m0.addr;
						s.cmd <= m0.cmd;
						if(m0.cmd)
							s.wdata <= m0.wdata;
					end else begin
						s.addr <= m1.addr;
						s.cmd <= m1.cmd;
						if(m1.cmd)
							s.wdata <= m1.wdata;
					end
				end else if(m0.req == 1)begin
					s.req <= 1;
					busy <= 1;
					prev_master <= 0;
					s.addr <= m0.addr;
					s.cmd <= m0.cmd;
					if(m0.cmd)
						s.wdata <= m0.wdata;
				end else if(m1.req == 1)begin
					s.req <= 1;
					busy <= 1;
					prev_master <= 1;
					s.addr <= m1.addr;
					s.cmd <= m1.cmd;
					if(m1.cmd)
						s.wdata <= m1.wdata;
				end
			end else begin
				if(s.cmd)begin
					if(prev_master)begin
						if(!m1.req)begin
							busy <= 0;
						end
						if(s.ack)begin
							s.req <= 0;
							m1.ack <= 1;
						end
					end else begin
						if(!m0.req)begin
							busy <= 0;
						end
						if(s.ack)begin
							s.req <= 0;
							m0.ack <= 1;
						end
					end
				end else begin
					if(prev_master)begin
						if(s.ack)begin
							s.req <= 0;
							m1.ack <= 1;
						end
						if(s.resp)begin
							response_flag <= 1;
							m1.resp <= 1;
							m1.rdata <= s.rdata;
						end
						if(response_flag && !m1.req) busy <= 0;
					end else begin
						if(s.ack)begin
							s.req <= 0;
							m0.ack <= 1;
						end
						if(s.resp)begin
							response_flag <= 1;
							m0.resp <= 1;
							m0.rdata <= s.rdata;
						end
						if(response_flag && !m0.req) busy <= 0;
					end
				end
			end
		end
	end

endmodule : slave_module