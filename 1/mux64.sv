//connecting 64 32:1 muxes for 64X32:64
// register x31=0
module mux64 #(parameter delay = 50) (out, in, read_reg); 
 output logic [63:0] out; 
 input logic [31:0][63:0] in; 
 input logic [4:0] read_reg;
 //FIXME AM: streaming unpacks the 2D array that we can repack; will be more elegant; worth looking at
 //logic [63:0][31:0] in_cat = {<<{in}}; 
 //mux32_1 inst[63:0] (.out(out), .in(in_cat), .sel(read_reg));
 /*
	genvar i;
	generate 
	for(i=0; i<64; i++) _in[i] = {<<{in[][i]
 */
 genvar i, j, n;
 generate
 for(i=0; i<64; i++) begin : eachMux
   logic [31:0] in_sel_bit;
   for(j=0; j<32; j++) assign in_sel_bit[j] = in[j][i];
   mux32_1 #(delay) m0(.out(out[i]),.in(in_sel_bit),.sel(read_reg));
 end
 endgenerate

endmodule 
 
module mux64_testbench(); 
 logic [31:0][63:0] in; 
 logic [4:0] read_reg; 
 logic [63:0] out; 
 
 mux64 dut(out, in ,read_reg); 
 
 integer i; 
 initial begin 
 for(i=0;i<32;i++)
 in[i]=i;
 
 for(i=0;i<32;i++) begin
 #10 read_reg=i;
 $strobe("%16x %16x", out, in[i]);
 end

 #10;
 end 
endmodule 
