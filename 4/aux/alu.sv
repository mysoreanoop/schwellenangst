// 64 bit ALU with 6 operations - PASS_B, ADD, SUB, AND, OR, XOR
// Authors: Anoop, Sanjukta
`timescale 1ps/1ps 

module alu (
		input [63:0] A, // first input A
		input [63:0] B, // second input B
		input [2:0] cntrl, // selects which operation to perform
		output [63:0] result, // result of ALU computatuon
		output negative, output zero, output overflow, output carry_out); // status flags

	logic [63:0] add, _b, ci, co;  // add has result for add/sub; b for pass B; array of carry in and carry out
	logic [63:0] _and, _or, _xor; //results of each operation (to be selected from later)
	
	logic [31:0] tx; //These variables are for zero flag calculation tree of or gates
	logic [15:0] ty;
	logic [7:0] tz;
	logic [3:0] tq;
	logic [1:0] tr;
	
	parameter delay = 50; //gate Delay
	//flags 
	assign negative = result[63]; // highest bit of result gives the sign
	xor #delay x0 (overflow, co[63], co[62]); // overflow = xor of last 2 carry outs
	assign carry_out = co[63]; // last carry out from adder

	//carry in for add/sub
	assign ci[0] = cntrl[0];

	genvar i;
	generate      // ALU operations bit sliced, 64 times to give 64 bit ALU
		for(i=0; i<64; i++) begin : slice
			//logic operations
			and #delay a2 (_and[i], A[i], B[i]); // AND
			or #delay o0 (_or[i], A[i], B[i]);    // OR
			xor #delay x1 (_xor[i], A[i], B[i]);  // XOR

			//PASS_B
			xor #delay x2 (_b[i], cntrl[0], B[i]);
			
			//ADD/SUB
			if(i>0) assign ci[i] = co[i-1];
			fa f (A[i], _b[i], ci[i], add[i], co[i]);

			//select between operations - which result to use
			mux5_1 m (result[i], {_xor[i], _or[i], _and[i], add[i], B[i]}, cntrl);
		end
		//calculation of zero flag using a tree of or gates (instead of an or cascade)
		for(i=0; i<32; i++)
			or #delay ax0(tx[i], result[2*i], result[2*i+1]);
		for(i=0; i<16; i++)
			or #delay ax1(ty[i], tx[2*i], tx[2*i+1]);	
		for(i=0; i<8; i++)
			or #delay ax2(tz[i], ty[2*i], ty[2*i+1]);	
		for(i=0; i<4; i++)
			or #delay ax3(tq[i], tz[2*i], tz[2*i+1]);	
		for(i=0; i<2; i++)
			or #delay ax4(tr[i], tq[2*i], tq[2*i+1]);	
		nor #delay ax5 (zero, tr[0], tr[1]); // nor gate at the end to give high when inputs are 0
	endgenerate
endmodule	

module alu_tb; //test bench
	logic [63:0] A, B, result;
	logic [2:0] cntrl, seed;
	logic zero, negative, carry_out, overflow;
	string s = "";
	
	alu x (A, B, cntrl, result, negative, zero, overflow, carry_out);
	logic k;
	initial begin
		A = 0;
		B = 0;
		cntrl = 0;
		k = 0;
		forever #5 k = ~k;
	end
	
	always @(negedge k) begin
	//always @(posedge k) begin
		seed <= $urandom%7;
		cntrl <= seed == 1 ? '0 : seed;  // ranomized cntrl
		A <= ($random%2) ? {2{$random}} : '0; //randomized inputs
		B <= ($random%2) ? {2{$random}} : '0;
		case(cntrl) //utility for printing only
			3'b000: s = "B";
			3'b010: s = "+";
			3'b011: s = "-";
			3'b100: s = "&";
			3'b101: s = "|";
			3'b110: s = "^";
			default: s = "Grrr....";
		endcase
	end
	initial $monitor("%s\n\nco:%x\nA:  %x\nB:  %x\nr:  %x |",
		s, x.co, A, B, result,
		"flags: %s %s %s %s",
		negative ? "n" : "", zero ? "z" : "", 
		overflow && (cntrl == 2 || cntrl == 3) ? "o" : "",
		carry_out && (cntrl == 2 || cntrl == 3) ? "c" : "");
endmodule
