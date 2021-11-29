`timescale 1ns/10ps
module tb();
  logic clk, rst;

  pipelined_cpu dut(.clk(clk), .reset(rst));

  initial begin // Set up the clock
    clk <= 0;
    rst = 1;
    #600 //Do not change this
    rst = 0;
  end
  initial begin
   forever #100 clk <= ~clk;
  end
  initial begin
    #2000 $stop;
  end

endmodule
