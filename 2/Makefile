TEST_MODULE = alustim

SOURCES = \
	./adder.sv \
	./alu.sv \
	./alustim.sv \
	./mux2_1.sv \
	./mux5_1.sv \

compile: 
	vlog -sv -timescale 10ps/10ps -work work $(SOURCES)
simulate: 
	vsim -t ps -batch -lib work $(TEST_MODULE) -do "run -all; quit -f"

all:
	$(compile)
	$(simulate) >> transcript
  
clean:
	rm -rf transcript work vsim.wlf
