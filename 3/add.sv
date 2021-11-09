// Just adder  - for PC increment
`timescale 1ps/1ps

module add (s, a, b); 
input logic [63:0]a,b;
output logic [63:0]s;
logic [63:0] co,ci;

assign ci[0]=0;

genvar i;
	generate      // ALU operations bit sliced, 64 times to give 64 bit ALU
		for(i=0; i<64; i++) begin : slice
		
			if(i>0) assign ci[i] = co[i-1];
			fa f (a[i], b[i], ci[i], s[i], co[i]);
			
		end
		
	endgenerate
endmodule	


module add_tb();
logic [63:0] a,b,s;

 add dut(.s, .a, .b);

initial begin 
		a=0; b=4; #500;
		a = 1000; b=2000; #500;
		a = -2; b= -1; #500;
		
	end 
endmodule

