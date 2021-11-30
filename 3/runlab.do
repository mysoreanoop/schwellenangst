# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./adder.sv"
vlog "./alu.sv"         
vlog "./mux2_1.sv"
vlog "./se.sv"
vlog "./ze.sv"
vlog "./mux5_1.sv"
vlog "./math.sv"
vlog "./instructmem.sv"
vlog "./datamem.sv"
vlog "./idecode.sv"
vlog "./cpu.sv"
vlog "./add.sv"
vlog "./top.sv"
vlog "./tb.sv"
vlog "./D_FF.sv"
vlog "./DFF_VAR.sv"
vlog "./D_FF_en.sv"
vlog "./decoder1_2.sv"
vlog "./decoder2_4.sv"
vlog "./decoder3_8.sv"
vlog "./decoder5_32.sv"
vlog "./LS_2.sv"
vlog "./mux2.sv"
vlog "./mux4.sv"
vlog "./mux4_1.sv"
vlog "./mux5_1.sv"
vlog "./mux8_1.sv"
vlog "./mux32_1.sv"
vlog "./mux64.sv"
vlog "./regfile.sv"
vlog "./register64.sv"
vlog "./register_v.sv"
vlog "./register_bank_32.sv"


# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
# There's an argument --timescale 1ps/1ps to set global default timescale; doesn't work here, works in Makefile
vsim -voptargs="+acc" -t 1ps -lib work tb

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all
