`timescale 1ps/1ps
module fa (input a, input b, input ci, output s, output co);
	logic c0, c1, _s;
	parameter delay = 0;
	ha  h0 (a, b, c0, _s);
	ha  h1 (ci, _s, c1, s);
	or #delay o (co, c0, c1);
endmodule

module ha (input a, input b, output c, output s);
	parameter delay = 0;
	xor #delay x (s, a, b);
	and #delay n (c, a, b);
endmodule

module fa_tb;
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
	
	


