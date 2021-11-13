`timescale 1ps/1ps
`define PC_INIT 0
`define ADDI 1
`define ADDS 2
`define BLT  3
`define B    4
`define CBZ  5
`define LDUR 6
`define LSL  7
`define LSR  8
`define MUL  9
`define STUR 10
`define SUBS 11

//Enka -- our single cycle ARM CPU!
module sc_cpu (
  input  logic        clk,
  input  logic        rst,

  //d$ (from template provided)
  output logic [63:0] Addr,
  output logic        WrEn_d,
  output logic [63:0] Dout,
  input  logic [63:0] Db,

  //i$ (from template again)
  output reg   [63:0] pc,
  input  logic [31:0] inst
);

  //flags
  reg z, o, c, n;
  logic _z, _o, _c, _n;
  
  //decoder wires
  logic [3:0]  opcode; 
  logic [11:0] imm12;
  logic [25:0] _imm26;
  logic [63:0] _imm19;
  logic [63:0] imm26;
  logic [18:0] imm19;
  logic [8:0]  imm9, _imm9;
  logic [5:0]  shamt;
  logic [4:0]  rm, rn, rd;

  //rf wires
  logic [4:0]  Aw, Ab, Aa;
  logic [63:0] Da, _Db, Dw;
  logic WrEn;

  //ALU wires
  logic [63:0] r, _imm12;
  logic [63:0] mul_out, mult_high, shift_out;

  logic Reg2Loc, RegWrite, BrTaken, ALUSrc, UncondBr;
  logic [1:0] MemToReg;
  logic [2:0] ALUOp;
  assign MemToReg = opcode == `LDUR ? 2'd1
    : opcode == `MUL ? 2'd2
      : opcode == `LSL || opcode == `LSR ? 2'd3
        : 2'd0;
  assign Reg2Loc = opcode == `CBZ;
  assign RegWrite = !(opcode == `B
    || opcode == `BLT
    || opcode == `CBZ
    || opcode == `STUR);
  assign WrEn_d = opcode == `STUR;
  assign BrTaken = (opcode == `B
    || opcode == `BLT
    || opcode == `CBZ);
  assign ALUOp = opcode == `SUBS ? 3'd3 : 3'd2;
  assign ALUSrc = {opcode == `ADDI , opcode == `LDUR || opcode == `STUR};
  assign UncondBr = ~((opcode == `BLT && (_n != _o)) || (opcode == `CBZ && _z));
  always @(posedge clk)
    $display("op: %x | M2R %x | R2L %x | RW %x | BT %x | AO %x | AS %x | UB %x\n",
      opcode, MemToReg, Reg2Loc, RegWrite, BrTaken, ALUOp, ALUSrc, UncondBr);

  //inst decoder, alu, rf, mul, shifter
  idecode id(inst, opcode, imm12, imm26, imm19, imm9, shamt, w, rm, rn, rd);
  
  ze addi (_imm12, imm12);
  se #(9) se9 (_imm9, imm9);
  mux4 alu_b (_Db, Db, _imm9, _imm12, _imm12, ALUSrc);
  mux2 rn_sel (Ab, Rm, Rd, Reg2Loc); //TODO gotta make a 5 bit 2:1 bus mux!
  
  mult mul(Da, Db, 1'b1, mul_out, mul_high);
  shifter s(Da, opcode[0], shamt, shift_out);
  alu xu (Da, _Db, ALUOp, Addr, _n, _z, _o, _c);

  mux4 rf_write(Dw, Addr, Dout, mul_out, shift_out, MemToReg);

  regfile rf(Da, Db, Dw, Aa, Ab, Aw, RegWrite, clk);

  always @(posedge clk) begin
    if(rst) begin
      //reset flags and pc
      z <= 1'b0; //Some of these may not be needed
      o <= 1'b0;
      c <= 1'b0;
      n <= 1'b0;
      pc <= `PC_INIT;
    end else begin
      z <= _z;
      o <= _o;
      c <= _c;
      n <= _n;
    end
  end
 
  //PC computation
  logic [63:0] ls_in, ax;
  se #(19) se1 (_imm19,imm19);
  se #(26) se2 (_imm26,imm26);
  mux2 m_pc(ls_in, _imm19, _imm26, UncondBr);
  LS_2 ls(ax, ls_in); // left shift 2 (mul4)
  add a4(o0, pc, 64'h4); //pc+4
  add a_br(o1, pc, ax); // pc+ branch addr
  mux2 m_br(pc,o0,o1,BrTaken);
endmodule
