// SIGN EXTEND for Immm9/DAddr9
`timescale 1ps/1ps
module SE_9 (out, in);  //2:1 mux
	output logic [63:0] out; //output 64 bit
	input logic [8:0]in; // input -9 bit
	
	assign out =  { {55{in[8]}} , in[8:0] };	

endmodule 
 
module SE_9_testbench(); // testbench for mux
	logic [8:0]in;
	logic [63:0]out; 
	
	SE_9 dut (.out, .in); 
	
	initial begin 
		in=0; #10;
		in = 9'b111111100; #10;
		in = 9'b010111100; #10;
		
	end 
endmodule
