`timescale 1ps/1ps
`define PC_INIT 0

//Enka -- our single cycle ARM CPU!
module sc_cpu (
  input  logic        clk,
  input  logic        rst,

  //d$ (from template provided)
  output logic [63:0] address,
  output logic        write_enable,
  output logic        read_enable,
  output logic [63:0] write_data,
  output logic [3:0]  xfer_size,
  input  logic [63:0] read_data

  //i$ (from template again)
  output reg   [63:0] pc,
  input  logic [31:0] inst
);
  //flags
  reg z, o, c, n;
  logic _z, _o, _c, _n;

  //decoder wires
  logic [3:0] opcode; 
  logic [11:0] imm12;
  logic [25:0] imm26;
  logic [18:0] imm19;
  logic [8:0] imm9;
  logic [5:0] shamt;
  logic [4:0] rm, rn, rd;

  //rf wires
  logic [4:0] ra;
  logic [63:0] wd;
  logic w;

  //ALU wires
  logic [63:0] r, da, db;
  logic [2:0] aluc;

  //D$ write enable:
  assign write_enable = opcode == STUR;

  //inst decoder, alu, rf, mul, shifter
  idecode id(inst, opcode, imm12, imm26, imm19, imm9, shamt, w, rm, rn, rd, aluc);
  alu x(da, db, address, _n, _z, _o, _c);
  regfile rf(da, write_data, wd, rn, ab, rd, w, clk);
  mul m(
  shifter s(

  always @(posedge clk) begin
    if(rst) begin
      //reset flags and pc
      z <= 1'b0;
      o <= 1'b0;
      c <= 1'b0;
      n <= 1'b0;
      pc <= `PC_INIT;
    end else begin
      z <= _z;
      o <= _o;
      c <= _c;
      n <= _n;
      //PC calculation
      pc <= opcode == B || opcode == BLT && (o ^ n) || opcode == CBZ && _z ?
        pc + (opcode == BLT || opcode == CBZ ? imm19 : imm26) << 2 : pc + 32'd4;
    end
  end
  always_comb begin
    //RF related assignments
    wd = opcode == LDUR ? read_data : addr_out;
    w = !(opcode == STUR ||
      opcode == CBZ  ||
      opcode == B    ||
      opcode == BLT);
    ab = opcode == CBZ || opcode == STUR ? rd : rm;

    //ALU connections
    db = () ? write_data : imm9; //TODO
  end
endmodule
