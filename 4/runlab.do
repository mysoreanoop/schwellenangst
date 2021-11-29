# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.

vlog "./accelerated_branch.sv"
vlog "./ansi/D_FF.sv"
vlog "./ansi/D_FF_en.sv"
vlog "./ansi/LS_2.sv"
vlog "./ansi/add.sv"
vlog "./ansi/adder.sv"
vlog "./ansi/alu.sv"         
vlog "./ansi/datamem.sv"
vlog "./ansi/decoder1_2.sv"
vlog "./ansi/decoder2_4.sv"
vlog "./ansi/decoder3_8.sv"
vlog "./ansi/decoder5_32.sv"
vlog "./ansi/idecode.sv"
vlog "./ansi/instructmem.sv"
vlog "./ansi/math.sv"
vlog "./ansi/mux2.sv"
vlog "./ansi/mux2_1.sv"
vlog "./ansi/mux32_1.sv"
vlog "./ansi/mux4.sv"
vlog "./ansi/mux4_1.sv"
vlog "./ansi/mux5_1.sv"
vlog "./ansi/mux5_1.sv"
vlog "./ansi/mux64.sv"
vlog "./ansi/mux8_1.sv"
vlog "./ansi/regfile.sv"
vlog "./ansi/register64.sv"
vlog "./ansi/register_bank_32.sv"
vlog "./ansi/se.sv"
vlog "./ansi/ze.sv"
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
