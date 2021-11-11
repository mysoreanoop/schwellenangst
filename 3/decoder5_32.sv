// 5:32 decoder ( for write address)
module decoder5_32(in,out,e);
 output logic[31:0] out;
 input logic [4:0] in;
 input logic e;
 logic [3:0]x; //wires
 
 
 //decoder2_4(out,in,e); decoder3_8(out,in,e);
 
 decoder2_4 d0(x[3:0],in[4:3],e);
 
 decoder3_8 d1(out[31:24],in[2:0],x[3]);
 decoder3_8 d2(out[23:16],in[2:0],x[2]);
 decoder3_8 d3(out[15:8],in[2:0],x[1]);
 decoder3_8 d4(out[7:0],in[2:0],x[0]);
 


endmodule

module decoder5_32_testbench(); 
 logic [4:0] in; 
 logic [31:0] out; 
 logic e;
 
 decoder5_32 dut(.in,.out,.e);

 integer i; 
 initial begin 
 e=0;#10 e=1;
 for(i=0; i<32; i++) begin 
 in =i; #50; 
 
 end
 end 
endmodule 
