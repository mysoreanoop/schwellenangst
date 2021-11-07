TEST_MODULE = rf_tb

SOURCES = \
	./decoder5_32.sv \
	./decoder3_8.sv \
	./decoder2_4.sv \
	./decoder1_2.sv \
	./mux2_1.sv \
	./mux4_1.sv \
	./mux8_1.sv \
	./mux32_1.sv \
	./D_FF.sv \
	./D_FF_en.sv \
	./register64.sv \
	./register_bank_32.sv \
	./mux64.sv \
	./regfile.sv \
	./regstim.sv

compile: 
	vlog -sv -timescale 10ps/10ps -work work $(SOURCES)
simulate: 
	vsim -t ps -batch -lib work $(TEST_MODULE) -do "run -all; quit -f"

all:
	$(compile)
	$(simulate) >> transcript
  
clean:
	rm -rf transcript work
