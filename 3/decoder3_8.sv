`timescale 1ps/1ps
module decoder3_8(out,in,e);
output logic[7:0] out;
input logic [2:0] in;
input logic e;
logic [1:0]x;

//decoder2_4(out,in,e);
decoder1_2 d0(x,in[2],e);
decoder2_4 d1(out[7:4],in[1:0],x[1]);
decoder2_4 d2(out[3:0],in[1:0],x[0]);


endmodule

module decoder3_8_testbench(); 
 logic [1:0] in; 
 logic [3:0] out; 
 logic e;
 
 decoder3_8 dut(.in,.out,.e);

 integer i; 
 initial begin 
 for(i=0; i<8; i++) begin 
 in =i; #50; 
 
 end
 end 
endmodule 
