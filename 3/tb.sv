`timescale 1ns/100ps
module tb();
  logic clk, rst;

  top dut(clk, rst);

  initial begin // Set up the clock
    clk <= 0;
    rst = 1;
    #500
    rst = 0;
  end
  initial begin
   forever #100 clk <= ~clk;
  end
  initial begin
    #2000 $stop;
  end

endmodule
