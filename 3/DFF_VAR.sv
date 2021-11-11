module DFF_VAR #(parameter WIDTH=8) (q, d, clk); 
 output logic [WIDTH-1:0] q; 
 input logic [WIDTH-1:0] d; 
 input logic clk; 
 initial assert(WIDTH>0); 
 genvar i; 
 generate 
 for(i=0; i<WIDTH; i++) begin : eachDff 
 D_FF dff (.q(q[i]), .d(d[i]), .clk); 
 end 
 endgenerate 
endmodule 