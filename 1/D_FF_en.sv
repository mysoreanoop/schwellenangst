//D_FF with an enable to control latching
module D_FF_en (q, d, reset, clk, e);
	output logic q; 
	input logic d, reset, clk, e; 
	logic dd;
	
	D_FF d0(q,dd,reset,clk);
	mux2_1 m(dd,{d,q},e);
endmodule 
