module decoder1_2(out,in,e);
output logic[1:0] out;
input logic in;
input logic e;
logic inn;

parameter delay = 0; 
not #delay n0(inn,in);

and #delay a0(out[0],inn,e); //out
and #delay a1(out[1],in,e);

endmodule

module decoder1_2_testbench(); 
 logic in;
 logic e; 
 logic [1:0] out; 
 
 decoder1_2 dut(.out, .in, .e);

 integer i; 
 initial begin 
 e=0;
 #10 e=1;
 for(i=0; i<2; i++) begin 
 in =i; #50; 
 
 end
 end 
endmodule 
