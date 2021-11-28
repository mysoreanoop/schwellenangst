TEST_MODULE = pipelined_cpu

SOURCES = \
	./accelerated_branch.sv \
	./aux/DFF_VAR.sv \
	./aux/D_FF.sv \
	./aux/D_FF_en.sv \
	./aux/LS_2.sv \
	./aux/add.sv \
	./aux/adder.sv \
	./aux/alu.sv \
	./aux/cpu.sv \
	./aux/datamem.sv \
	./aux/decoder1_2.sv \
	./aux/decoder2_4.sv \
	./aux/decoder3_8.sv \
	./aux/decoder5_32.sv \
	./aux/idecode.sv \
	./aux/instructmem.sv \
	./aux/math.sv \
	./aux/mux2.sv \
	./aux/mux2_1.sv \
	./aux/mux32_1.sv \
	./aux/mux4.sv \
	./aux/mux4_1.sv \
	./aux/mux5_1.sv \
	./aux/mux64.sv \
	./aux/mux8_1.sv \
	./aux/regfile.sv \
	./aux/register64.sv \
	./aux/register_bank_32.sv \
	./aux/se.sv \
	./aux/ze.sv \
	./control.sv \
	./forwarding.sv \
	./pipelined_cpu.sv \
	./register_v.sv \
	./tb.sv \

compile: 
	vlog -sv -timescale 10ps/10ps -work work $(SOURCES)
simulate: 
	vsim -t ps -batch -lib work $(TEST_MODULE) -do "run -all; quit -f"

all:
	$(compile)
	$(simulate) >> transcript
  
clean:
	rm -rf transcript work vsim.wlf
