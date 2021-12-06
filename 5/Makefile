TEST_MODULE = lab5_testbench

SOURCES = \
	./DataMemory.svp \
	./cache.svp \
	./main_memory.svp \
	./lab5.sv \
	./write_buffer.svp \

compile: 
	vlog -sv -timescale 10ps/10ps -work work $(SOURCES)
simulate: 
	vsim -t ps -batch -lib work $(TEST_MODULE) -do "run -all; quit -f"

all:
	$(compile)
	$(simulate) >> transcript
  
clean:
	rm -rf transcript work vsim.wlf
