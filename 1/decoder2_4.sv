`timescale 1ps/1ps
// 2 to 4 Decoder
module decoder2_4 #(parameter delay = 50) (out,in,e);
	output logic[3:0] out;
	input logic [1:0] in;
	input logic e;
	logic inn[1:0];
	
	not #delay n0(inn[0],in[0]);
	not #delay n1(inn[1],in[1]);
	and #delay a0(out[0],inn[1],inn[0],e); //out
	and #delay a1(out[1],inn[1],in[0],e);
	and #delay a2(out[2],in[1],inn[0],e);
	and #delay a3(out[3],in[1],in[0],e);
	
endmodule

module decoder2_4_testbench(); 
	logic [1:0] in;
	logic e; 
	logic [3:0] out; 
	
	decoder2_4 dut(.out, .in, .e);
	
	integer i; 
	initial begin 
		e=0;
		#10 e=1;
		for(i=0; i<4; i++) begin 
			in =i; #50; 
		end
	end 
endmodule 
