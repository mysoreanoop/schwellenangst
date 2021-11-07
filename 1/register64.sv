// 64 bit Register
`timescale 1ps/1ps
module register64(data_out, data_in, clk, reset, e); 
	output logic [63:0] data_out; 
	input logic [63:0] data_in; 
	input logic clk; 
	input logic reset, e;
	
	genvar i; 
	generate 
	for(i=0; i<64; i++) begin : eachDff 
		D_FF_en dff (.q(data_out[i]), .d(data_in[i]), .reset(reset), .clk(clk), .e(e)); 
	end 
	endgenerate 
endmodule 
