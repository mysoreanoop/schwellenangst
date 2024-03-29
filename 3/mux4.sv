//connecting 64 4:1 muxes 
// register x31=0
module mux4(out, in0,in1,in2,in3, sel); 
 output logic [63:0] out; 
 input logic [63:0] in1,in0,in2,in3; 
 input logic [1:0] sel;
 
//genvar i, j, n;
// generate
// for(i=0; i<64; i++) begin : eachMux
//   logic [1:0] in_sel_bit;
//   for(j=0; j<2; j++) assign in_sel_bit[j] = in[j][i];
//   mux2_1 m0(.out(out[i]),.in(in_sel_bit),.sel(read_reg));
// end
// endgenerate

genvar i;
generate
for(i=0;i<64;i++)begin : eachMux
	mux4_1 m(out[i],{in3[i],in2[i],in1[i],in0[i]},sel);
	end
	endgenerate 

endmodule 
 
//module mux64_testbench(); 
// logic [31:0][63:0] in; 
// logic [4:0] read_reg; 
// logic [63:0] out; 
// 
// //mux64 dut(out, in ,read_reg); 
// 
// integer i; 
// initial begin 
// for(i=0;i<32;i++)
// in[i]=i;
// 
// for(i=0;i<32;i++) begin
// #10 read_reg=i;
// $strobe("%16x %16x", out, in[i]);
// end
//
// #10;
// end 
//endmodule 
