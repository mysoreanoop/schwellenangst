//5 to 1 Mux -- special!
`timescale 1ps/1ps
module mux5_1 (out, in, sel);  //2:1 mux
	output logic out; 
	input logic [4:0] in;
	input logic [2:0] sel; 
	logic t0, t1, t2;

	//sel = 0/1, 2/3, 4, 5, 6 will select:
	//      0  , 1  , 2, 3, 4 th bit of in!
	mux2_1 m0 (t0, {in[1], in[0]}, sel[1]); //B or A+/-B
	mux2_1 m1 (t1, {in[3], in[2]}, sel[0]); //& or |
	mux2_1 m2 (t2, {in[4], t1}, sel[1]);    //t1 or ^
	mux2_1 m3 (out, {t2, t0}, sel[2]);      //t0 or t2
endmodule 
 
module mux5_1_testbench(); 
	logic [4:0] in;
	logic [2:0] sel; 
	logic out; 
	
	mux5_1 dut (.out, .in, .sel); 
	
	initial forever #10 sel=$urandom%7; 
	initial forever #10 in=$urandom%32;
endmodule
