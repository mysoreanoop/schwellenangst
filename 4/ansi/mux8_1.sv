module mux8_1(out, in ,sel); 
 output logic out; 
 input logic [7:0] in; 
 input logic [2:0]sel;
 logic [1:0]x; //wires
 //mux2_1(out, in, sel);
 
 mux4_1 m0(.out(x[0]),.in(in[3:0]),.sel(sel[1:0]));
 mux4_1 m1(.out(x[1]),.in(in[7:4]),.sel(sel[1:0])); 
 mux2_1 m2(.out(out), .in(x), .sel(sel[2])); 
 
endmodule 
 
module mux8_1_testbench(); 
 logic [7:0]in;
 logic [2:0]sel; 
 logic out; 
 
 mux8_1 dut (.out, .in, .sel); 
 
 integer i; 
 initial begin 
 for(i=0; i<2; i++) begin 
 {sel, in} = i; #10; 
 end 
 end 
endmodule 