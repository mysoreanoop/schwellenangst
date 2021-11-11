// SIGN EXTEND for Imm26/BAddr26
`timescale 1ps/1ps
module SE_26 (out, in);  
	output logic [63:0] out; //output 64 bit
	input logic [25:0]in; // input - 26 bit
	
	assign out =  { {39{in[25]}} , in[25:0] };	

endmodule 
 
module SE_26_testbench(); // testbench for mux
	logic [25:0]in;
	logic [63:0]out; 
	
	SE_26 dut (.out, .in); 
	
	initial begin 
		in=0; #10;
		in = 18'b111111100; #10;
		in = -2; #10;
		
	end 
endmodule
