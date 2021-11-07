//2 to 1 Mux
`timescale 1ps/1ps
module mux2_1 (out, in, sel);  //2:1 mux
	output logic out; 
	input logic [1:0]in;
	input logic sel; 
	logic seln;
	logic [1:0]x; //wires

	parameter delay = 0;	
	not #delay n0(seln,sel); //~Sel
	and #delay a0(x[0],in[0],seln);
	and #delay a1(x[1],in[1],sel);
	or  #delay o0(out,x[0],x[1]);
endmodule 
 
module mux2_1_testbench(); 
	logic [1:0]in;
	logic sel; 
	logic out; 
	
	mux2_1 dut (.out, .in, .sel); 
	
	initial begin 
		sel=0; in[0]=0; in[1]=0; #10; 
		sel=0; in[0]=0; in[1]=1; #10; 
		sel=0; in[0]=1; in[1]=0; #10; 
		sel=0; in[0]=1; in[1]=1; #10; 
		sel=1; in[0]=0; in[1]=0; #10; 
		sel=1; in[0]=0; in[1]=1; #10; 
		sel=1; in[0]=1; in[1]=0; #10; 
		sel=1; in[0]=1; in[1]=1; #10; 
	end 
endmodule
