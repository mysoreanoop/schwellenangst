`timescale 1ps/1ps
module tb();
  logic clk, rst;

  pipelined_cpu dut(clk, rst);

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
    #200000 $stop;
  end

endmodule
