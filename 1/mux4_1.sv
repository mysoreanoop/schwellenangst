// 4 to 1 Mux made of 3 2 to 1 Muxes and one Mux to select between them
`timescale 1ps/1ps
module mux4_1 (out, in ,sel); 
	output logic out; 
	input logic [3:0] in; 
	input logic [1:0]sel;
	logic [1:0]x; 
	
	mux2_1 m0(.out(x[0]),.in(in[1:0]),.sel(sel[0]));
	mux2_1 m1(.out(x[1]),.in(in[3:2]),.sel(sel[0])); 
	mux2_1 m2(.out(out), .in(x), .sel(sel[1])); 
endmodule 
 
module mux4_1_testbench(); 
	logic [3:0] in;
	logic [1:0] sel; 
	logic out; 
	
	mux4_1 dut (.out, .in, .sel); 
	
	integer i; 
	initial
		for(i=0; i<64; i++) begin 
			{sel,in} = i; #10; 
		end 
endmodule 
