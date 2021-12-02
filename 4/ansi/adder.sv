`timescale 1ps/1ps // Full adder with half adder 

module fa (input a, input b, input ci, output s, output co); // adds 3 1bit inputs, gives sum,carry
	logic c0, c1, _s;
	parameter delay = 50;
	ha  h0 (a, b, c0, _s);  // using 2 half adders 
	ha  h1 (ci, _s, c1, s);
	or #delay o (co, c0, c1); // carry out
endmodule

module ha (input a, input b, output c, output s); // adds 2 1bit inputs, gives sum, carry
	parameter delay = 50;
	xor #delay x (s, a, b);  // sum
	and #delay n (c, a, b);  // carry 
endmodule

module fa_tb; // test bench for full adder
	logic a, b, ci, s, co;
	logic [2:0] r;
	assign {a, b, ci} = r;
	initial begin
		r = '0;
		forever #5 r = r + 1;
	end
	fa f(a, b, ci, s, co);
	initial $monitor("a: %x b: %x ci: %x s: %x co: %x",
		a, b, ci, s, co);
endmodule
	
	


