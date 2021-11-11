module mux32_1(out, in ,sel); 
 output logic out; 
 input logic [31:0] in; 
 input logic [4:0]sel;
 logic [3:0]x; //wires
 //mux2_1(out, in, sel);
 
 mux8_1 m0(.out(x[0]),.in(in[7:0]),.sel(sel[2:0]));
 mux8_1 m1(.out(x[1]),.in(in[15:8]),.sel(sel[2:0])); 
 mux8_1 m2(.out(x[2]),.in(in[23:16]),.sel(sel[2:0])); 
 mux8_1 m3(.out(x[3]),.in(in[31:24]),.sel(sel[2:0])); 
 
 mux4_1 m4(.out(out), .in(x), .sel(sel[4:3])); 

 
endmodule 
 
module mux32_1_testbench(); 
 logic [31:0]in; 
 logic [4:0]sel; 
 logic out; 
 
 mux32_1 dut (.out, .in, .sel); 
 
 integer i; 
 initial begin 
 in=32'h11111111;
 #10 sel=24;
 #10 sel= 4;
 #10;
// for(i=0; i<64; i++) begin 
 //{sel,in} = i; #10; 
 //end 
 end 
endmodule 