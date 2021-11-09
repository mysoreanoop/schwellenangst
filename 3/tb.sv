`timescale 1ps/1ps
module tb();
  parameter ClockDelay = 5000;
  logic clk, rst;
  initial begin // Set up the clock
    clk = 0;
    rst = 1;
    forever #(ClockDelay/2) clk <= ~clk;
  end

  top dut(clk, rst);
endmodule
