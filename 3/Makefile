TEST_MODULE = rf_tb

SOURCES = \
  ./D_FF.sv \
  ./D_FF_en.sv \
  ./LS_2.sv \
  ./add.sv \
  ./adder.sv \
  ./alu.sv \
  ./cpu.sv \
  ./datamem.sv \
  ./decoder1_2.sv \
  ./decoder2_4.sv \
  ./decoder3_8.sv \
  ./decoder5_32.sv \
  ./idecode.sv \
  ./instructmem.sv \
  ./math.sv\
  ./mux2.sv \
  ./mux2_1.sv \
  ./mux32_1.sv \
  ./mux4.sv \
  ./mux4_1.sv \
  ./mux5_1.sv \
  ./mux64.sv \
  ./mux8_1.sv \
  ./regfile.sv \
  ./register64.sv \
  ./register_v.sv \
  ./register_bank_32.sv \
  ./se.sv \
  ./tb.sv \
  ./top.sv \
  ./ze.sv \

compile: 
	vlog -sv -timescale 10ps/10ps -work work $(SOURCES)
simulate: 
	vsim -t ps -batch -lib work $(TEST_MODULE) -do "run -all; quit -f"

all:
	$(compile)
	$(simulate) >> transcript
  
clean:
	rm -rf transcript work vsim.wlf
