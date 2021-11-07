//8 to 1 Mux made of 2 4 to 1 Muxes and one 2 to 1 Mux to select between them
`timescale 1ps/1ps
module mux8_1 #(parameter delay = 50) (out, in ,sel); 
	output logic out; 
	input logic [7:0] in; 
	input logic [2:0]sel;
	logic [1:0]x; //wires
	
	mux4_1 #(delay) m0(.out(x[0]),.in(in[3:0]),.sel(sel[1:0]));
	mux4_1 #(delay) m1(.out(x[1]),.in(in[7:4]),.sel(sel[1:0])); 
	mux2_1 #(delay) m2(.out(out), .in(x), .sel(sel[2])); 
endmodule 
 
module mux8_1_testbench(); 
	logic [7:0]in;
	logic [2:0]sel; 
	logic out; 
	
	mux8_1 dut (.out, .in, .sel); 
	
	integer i; 
	initial
		for(i=0; i<2; i++) begin 
		{sel, in} = i; #10; 
		end 
endmodule 
