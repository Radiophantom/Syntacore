onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /TOP_tb/clk_i
add wave -noupdate /TOP_tb/rst_n_i
add wave -noupdate -divider master0
add wave -noupdate /TOP_tb/m0/req
add wave -noupdate /TOP_tb/m0/slave_addr
add wave -noupdate /TOP_tb/m0/addr
add wave -noupdate /TOP_tb/m0/cmd
add wave -noupdate /TOP_tb/m0/wdata
add wave -noupdate /TOP_tb/m0/ack
add wave -noupdate /TOP_tb/m0/resp
add wave -noupdate /TOP_tb/m0/rdata
add wave -noupdate -divider master1
add wave -noupdate /TOP_tb/m1/req
add wave -noupdate /TOP_tb/m1/slave_addr
add wave -noupdate /TOP_tb/m1/addr
add wave -noupdate /TOP_tb/m1/cmd
add wave -noupdate /TOP_tb/m1/wdata
add wave -noupdate /TOP_tb/m1/ack
add wave -noupdate /TOP_tb/m1/resp
add wave -noupdate /TOP_tb/m1/rdata
add wave -noupdate -divider slave0
add wave -noupdate /TOP_tb/s0/req
add wave -noupdate /TOP_tb/s0/addr
add wave -noupdate /TOP_tb/s0/cmd
add wave -noupdate /TOP_tb/s0/wdata
add wave -noupdate /TOP_tb/s0/ack
add wave -noupdate /TOP_tb/s0/resp
add wave -noupdate /TOP_tb/s0/rdata
add wave -noupdate -divider slave1
add wave -noupdate /TOP_tb/s1/req
add wave -noupdate /TOP_tb/s1/addr
add wave -noupdate /TOP_tb/s1/cmd
add wave -noupdate /TOP_tb/s1/wdata
add wave -noupdate /TOP_tb/s1/ack
add wave -noupdate /TOP_tb/s1/resp
add wave -noupdate /TOP_tb/s1/rdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {778000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue right
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {892500 ps}
