module D_FF_en (q, d, reset, clk, e);
 output logic q; 
 input logic d, reset, clk, e; 
 logic dd;
 
 D_FF d0(q,dd,reset,clk);
 mux2_1 m(dd,{d,q},e);
 
endmodule 

module D_FF_en_testbench();
 logic q;
 logic d;
 logic clk,reset, e; 
 
D_FF_en dut (q, d, reset, clk, e); 

initial begin
clk=0;
reset=1;
e=0;
#5; e=1;
#5; reset=0;

end
 initial begin forever #5 clk=~clk; end
 initial begin 
 
 d = 1; #50; 
 d=0;
 
#10 e=0;
#10 d=1; reset=0;
#20;
e=1;
#20;
$stop;
 
 end 
endmodule 