module D_FF (q, d, reset, clk);
 output reg q; 
 input d, reset, clk; 
 always_ff @(posedge clk) 
 if (reset) 
 q <= 0; // On reset, set to 0 
 else 
 q <= d; // Otherwise out = d 
endmodule 

module D_FF_testbench();
 logic q;
 logic d;
 logic clk,reset; 
 
D_FF dut (q, d, reset, clk); 

initial begin
clk=0;
reset=0;
forever #5 clk=~clk;
end
 
 initial begin 
 #5 reset=1;
 #10 reset=0;
 d = 1; #50; 
 d=0;
 
#50 reset=1;
#10;
$stop;
 
 end 
endmodule 