vlib work

# delete old log
vdel -all

# Compile all file SystemVerilog/Verilog
#vlog -sv IR_defs.svh IR.v IR_tb.sv
#vlog -sv IR_defs.svh IR_AU_LU.v IR_AU_LU_tb.sv
vlog -sv IR_defs.svh flag.v flag_tb.sv


# Load testbench in UVM mode
vsim -uvmcontrol=all flag_tb



# add all in waveform
#add wave -r /*

# simulate
run -all
