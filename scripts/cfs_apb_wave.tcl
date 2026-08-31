# Add a divider for clarity sim:/testbench/dut/*
add wave -noupdate /testbench/dut/clk
add wave -noupdate /testbench/dut/reset_n

add wave -divider "APB interface signals"
add wave -noupdate /testbench/dut/pwrite
add wave -noupdate /testbench/dut/psel
add wave -noupdate /testbench/dut/penable
add wave -noupdate -radix hex /testbench/dut/paddr
add wave -noupdate -radix hex /testbench/dut/pwdata

add wave -noupdate -color yellow /testbench/dut/pready
add wave -noupdate -radix hex -color yellow /testbench/dut/prdata
add wave -noupdate -color yellow /testbench/dut/pslverr
