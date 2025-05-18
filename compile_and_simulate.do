# Create work library
vlib work

# Compile all Verilog files
vlog sdes.v
vlog lfsr.v
vlog top_module.v
vlog testbench.v

# Start simulation
vsim -t 1ps -novopt work.crypto_tb

# Add waves
add wave -position insertpoint sim:/crypto_tb/*
add wave -position insertpoint sim:/crypto_tb/dut/*

# Run simulation
run 1000ns
