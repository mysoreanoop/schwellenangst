// SIGN EXTEND for Imm19/CondAddr19
`timescale 1ps/1ps
module SE_19 (out, in);  
	output logic [63:0] out; //output 64 bit
	input logic [18:0]in; // input - 19 bit
	
	assign out =  { {45{in[18]}} , in[18:0] };	

endmodule 
 
module SE_19_testbench(); // testbench for mux
	logic [18:0]in;
	logic [63:0]out; 
	
	SE_19 dut (.out, .in); 
	
	initial begin 
		in=0; #10;
		in = 18'b111111100; #10;
		in = -2; #10;
		
	end 
endmodule
