//connecting 64 2:1 muxes 
// register x31=0
module mux2(out, in0,in1, sel); 
 output logic [63:0] out; 
 input logic [63:0] in1,in0; 
 input logic  sel;

genvar i;
generate
for(i=0;i<64;i++)begin : eachMux
	mux2_1 m(out[i],{in1[i],in0[i]},sel);
	end
	endgenerate 

endmodule 

module mux2_a(out, in0,in1, sel);
 output logic[4:0] out;
 input logic [4:0] in1,in0;
 input logic  sel;

genvar i;
generate
for(i=0;i<5;i++)begin : eachMux
  mux2_1 m(out[i],{in1[i],in0[i]},sel);
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
