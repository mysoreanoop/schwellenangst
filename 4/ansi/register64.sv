module register64  (data_out, data_in, clk, reset, e); 
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

module register64_testbench(); 
 logic [63:0] q;
 logic [63:0] d;
 logic clk,reset,e; 
 
register64 dut (q, d, clk, reset, e); 

initial begin
clk=0;
reset=0;
e=1;
forever #10 clk=~clk;
end
 
 initial begin 
 
 d = 5000; #45; 
 d=1010;
 #10 e=0;
 #30 e=1;

#10 reset=1;
#40;
$stop;
 
 end 
endmodule 
