# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.

vlog "./accelerated_branch.sv"
vlog "./aux/D_FF.sv"
vlog "./aux/D_FF_en.sv"
vlog "./aux/LS_2.sv"
vlog "./aux/add.sv"
vlog "./aux/adder.sv"
vlog "./aux/alu.sv"         
vlog "./aux/datamem.sv"
vlog "./aux/decoder1_2.sv"
vlog "./aux/decoder2_4.sv"
vlog "./aux/decoder3_8.sv"
vlog "./aux/decoder5_32.sv"
vlog "./aux/idecode.sv"
vlog "./aux/instructmem.sv"
vlog "./aux/math.sv"
vlog "./aux/mux2.sv"
vlog "./aux/mux2_1.sv"
vlog "./aux/mux32_1.sv"
vlog "./aux/mux4.sv"
vlog "./aux/mux4_1.sv"
vlog "./aux/mux5_1.sv"
vlog "./aux/mux5_1.sv"
vlog "./aux/mux64.sv"
vlog "./aux/mux8_1.sv"
vlog "./aux/regfile.sv"
vlog "./aux/register64.sv"
vlog "./aux/register_bank_32.sv"
vlog "./aux/se.sv"
vlog "./aux/ze.sv"
vlog "./control.sv"
vlog "./forwarding.sv"
vlog "./pipelined_cpu.sv"
vlog "./register_v.sv"
vlog "./tb.sv"


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
