// SIGN EXTEND for Imm
`timescale 1ps/1ps
module se #(parameter width = 9)(out, in);  
	output logic [63:0] out; //output 64 bit
	input logic [width-1:0]in; // input -9 bit
	
	assign out =  { {(64-width){in[width-1]}} , in[width-1:0] };	

endmodule 
 
//module SE_9_testbench(); // testbench for mux
//	logic [8:0]in;
//	logic [63:0]out; 
//	
//	SE_9 dut (.out, .in); 
//	
//	initial begin 
//		in=0; #10;
//		in = 9'b111111100; #10;
//		in = 9'b010111100; #10;
//		
//	end 
//endmodule
