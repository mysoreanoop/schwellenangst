// ZERO EXTEND for Imm12
`timescale 1ps/1ps
module ze (out, in);  
	output logic [63:0] out; //output 64 bit
	input logic [11:0] in; // input - 11 bit
	
	assign out =  { {52{1'b0}} , in[11:0] };	

endmodule 
 
module ZE_9_testbench(); // testbench for mux
	logic [11:0]in;
	logic [63:0]out; 
	
	ze dut (.out, .in); 
	
	initial begin 
		in=0; #10;
		in = 11'b111111100; #10;
		in = 2; #10;
		
	end 
endmodule
