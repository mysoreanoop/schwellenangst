//LEFT SHIFT BY 2  (MUL by 4)
`timescale 1ps/1ps
module LS_2 (out, in);  
	output logic [63:0] out; //output 64 bit
	input logic [63:0]in; // input - 19 bit
	
	assign out =  { {in[61:0]} , {2{1'b0}}};	

endmodule 
 
module LS_2_testbench(); // testbench for mux
	logic [63:0]in;
	logic [63:0]out; 
	
	LS_2 dut (.out, .in); 
	
	initial begin 
		in=0; #10;
		in = 2; #10;
		in = 1000; #10;
		
	end 
endmodule
