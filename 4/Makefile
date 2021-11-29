TEST_MODULE = tb

SOURCES = \
	./accelerated_branch.sv \
	./ansi/D_FF.sv \
	./ansi/D_FF_en.sv \
	./ansi/LS_2.sv \
	./ansi/add.sv \
	./ansi/adder.sv \
	./ansi/alu.sv \
	./ansi/datamem.sv \
	./ansi/decoder1_2.sv \
	./ansi/decoder2_4.sv \
	./ansi/decoder3_8.sv \
	./ansi/decoder5_32.sv \
	./ansi/idecode.sv \
	./ansi/instructmem.sv \
	./ansi/math.sv \
	./ansi/mux2.sv \
	./ansi/mux2_1.sv \
	./ansi/mux32_1.sv \
	./ansi/mux4.sv \
	./ansi/mux4_1.sv \
	./ansi/mux5_1.sv \
	./ansi/mux64.sv \
	./ansi/mux8_1.sv \
	./ansi/regfile.sv \
	./ansi/register64.sv \
	./ansi/register_bank_32.sv \
	./ansi/se.sv \
	./ansi/ze.sv \
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
