set PROJ_HOME "C:/digital_electronics/Projects/Aligner_venv"

# Create and map the working library
vlib work
vmap work work

# Compile the Design (DUT)
vlog -sv -work work $PROJ_HOME/src/*.v

# Compile the Testbench
vlog -sv -work work +incdir+$PROJ_HOME/tb $PROJ_HOME/tb/testbench.sv

# Load the Simulation
vsim -voptargs="+acc" work.testbench +UVM_TESTNAME=cfs_algn_test_reg_access

# Add Waveforms
do cfs_apb_wave.tcl

# Run the Simulation
run -all