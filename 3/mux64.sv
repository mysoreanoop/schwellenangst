//connecting 64 32:1 muxes for 64X32:64
// register x31=0
module mux64 #(parameter delay = 50) (out, in, read_reg); 
 output logic [63:0] out; 
 input logic [31:0][63:0] in; 
 input logic [4:0] read_reg;

 genvar i;
 generate
 for(i=0; i<64; i=i+1) begin : eachMux
   mux32_1 m0(.out(out[i]),.in(
    { in[0 ][i],
      in[1 ][i],
      in[2 ][i],
      in[3 ][i],
      in[4 ][i],
      in[5 ][i],
      in[6 ][i],
      in[7 ][i],
      in[8 ][i],
      in[9 ][i],
      in[10][i],
      in[11][i],
      in[12][i],
      in[13][i],
      in[14][i],
      in[15][i],
      in[16][i],
      in[17][i],
      in[18][i],
      in[19][i],
      in[20][i],
      in[21][i],
      in[22][i],
      in[23][i],
      in[24][i],
      in[25][i],
      in[26][i],
      in[27][i],
      in[28][i],
      in[29][i],
      in[30][i],
      in[31][i]
    }),.sel(read_reg));
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

