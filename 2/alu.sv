// Our reasonably decent ALU, the one we wish could have been anything from slightly to a lot better, but are either too lazy or unable to dedicate enough time (amidst all the crazy course assignments, homeworks, research, cooking and whatnot) to get it done.
`timescale 1ps/1ps
module alu (
		input [63:0] A, 
		input [63:0] B,
		input [2:0] cntrl,
		output [63:0] result,
		output negative, output zero, output overflow, output carry_out);

	logic [63:0] add, _b, ci, co;
	logic [63:0] _and, _or, _xor; //intermediate results (to be selected from later)
	logic [31:0] tx; //These variables are for zero flag calculation tree
	logic [15:0] ty;
	logic [7:0] tz;
	logic [3:0] tq;
	logic [1:0] tr;
	
	parameter delay = 0; //Delay
	//flags 
	assign negative = result[63];
	xor #delay x0 (overflow, co[63], co[62]);
	assign carry_out = co[63];

	//carry in for add/sub
	assign ci[0] = cntrl[0];

	genvar i;
	generate
		for(i=0; i<64; i++) begin : slice
			//logic operations
			and #delay a2 (_and[i], A[i], B[i]);
			or #delay o0 (_or[i], A[i], B[i]);
			xor #delay x1 (_xor[i], A[i], B[i]);

			//add/sub
			xor #delay x2 (_b[i], cntrl[0], B[i]);
			if(i>0) assign ci[i] = co[i-1];
			fa f (A[i], _b[i], ci[i], add[i], co[i]);

			//select between operations
			mux5_1 m (result[i], {_xor[i], _or[i], _and[i], add[i], B[i]}, cntrl);
		end

		//calculation of zero flag using a tree of or gates (instead of an or cascade)
		for(i=0; i<32; i++)
			or ax0(tx[i], result[2*i], result[2*i+1]);
		for(i=0; i<16; i++)
			or ax1(ty[i], tx[2*i], tx[2*i+1]);	
		for(i=0; i<8; i++)
			or ax2(tz[i], ty[2*i], ty[2*i+1]);	
		for(i=0; i<4; i++)
			or ax3(tq[i], tz[2*i], tz[2*i+1]);	
		for(i=0; i<2; i++)
			or ax4(tr[i], tq[2*i], tq[2*i+1]);	
		nor ax5 (zero, tr[0], tr[1]);

	endgenerate
endmodule	

module alu_tb;
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
		seed <= $urandom%7;
		cntrl <= seed == 1 ? '0 : seed;
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
