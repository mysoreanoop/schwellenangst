module top(
  input logic clk, rst
);

  logic [63:0] addr, wd, rd, pc;
  logic [31:0] inst;
  logic we, re;
  sc_cpu cpu_inst (clk, rst, addr, we, wd, rd, pc, inst);
  datamem dm(addr, we, 1'b1, wd, clk, 4'd6, rd);
  instructmem im(pc, inst, clk);
  always @(posedge clk)
    $display("PC: %6x | I: %x | rst %b\n", pc, inst, rst);
endmodule
