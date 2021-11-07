// 64 bit Register
`timescale 1ps/1ps
module register64(clk, reset, in, out); 
	output out;
	input clk, reset, in;
	reg r;
	assign out = r;

	always @(posedge clk)
		r <= in;
endmodule 
