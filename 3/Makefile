TEST_MODULE = alustim

SOURCES = \
	./top.sv \
	./cpu.sv \
	./datamem.sv \
	./instructmem.sv \
	./idecode.sv \
	./add.sv \
	./se.sv \
	./ze.sv \
  ./math.sv\

compile: 
	vlog -sv -timescale 10ps/10ps -work work $(SOURCES)
simulate: 
	vsim -t ps -batch -lib work $(TEST_MODULE) -do "run -all; quit -f"

all:
	$(compile)
	$(simulate) >> transcript
  
clean:
	rm -rf transcript work vsim.wlf
