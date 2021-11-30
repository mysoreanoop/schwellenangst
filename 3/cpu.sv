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
  output logic [63:0] Addr,
  output logic        WrEn_d,
  input  logic [63:0] DataInFromDMem,
  output logic [63:0] Db,

  output reg   [63:0] pc_reg,
  input  logic [31:0] inst
);

  //flags
  reg z, o, c, n;
  logic _z, _o, _c, _n;
  
  //decoder wires
  logic [3:0]  opcode; 
  logic [11:0] imm12;
  logic [63:0] _imm26;
  logic [63:0] _imm19;
  logic [25:0] imm26;
  logic [18:0] imm19;
  logic [8:0]  imm9;
  logic [63:0] _imm9;
  logic [5:0]  shamt;
  logic [4:0]  Rm, Rn, Rd;

  //rf wires
  logic [4:0]  Ab, Aa;
  logic [63:0] Da, _Db, Dw;
  logic WrEn;

  //ALU wires
  logic [63:0] r, _imm12;
  logic [63:0] mul_out, mult_high, shift_out;

  logic Reg2Loc, RegWrite, BrTaken, UncondBr;
  logic [1:0] MemToReg, ALUSrc;
  logic [2:0] ALUOp;
  assign MemToReg = opcode == `LDUR ? 2'd1
    : opcode == `MUL ? 2'd2
      : opcode == `LSL || opcode == `LSR ? 2'd3
        : 2'd0;
  assign Reg2Loc = ~(opcode == `STUR || opcode == `CBZ);
  assign RegWrite = ~(opcode == `B
    || opcode == `BLT
    || opcode == `CBZ
    || opcode == `STUR);
  assign WrEn_d = opcode == `STUR;
  assign BrTaken = (opcode == `B
    || (opcode == `BLT) &&  (n ^ o)
    || (opcode == `CBZ) && _z);
  assign ALUOp = opcode == `SUBS ? 3'd3 : (opcode == `CBZ ? 3'd0 : 3'd2);
  assign ALUSrc = {opcode == `ADDI , opcode == `LDUR || opcode == `STUR};
  assign UncondBr = ~((opcode == `BLT) && (n ^ o) || (opcode == `CBZ) && _z);
  always @(posedge clk)
    $display("op: %x | M2R %x | R2L %x | RW %x | BT %x | AOp %x | ASrc %x | UB %x\n",
      opcode, MemToReg, Reg2Loc, RegWrite, BrTaken, ALUOp, ALUSrc, UncondBr);

  //inst decoder, alu, rf, mul, shifter
  idecode id(inst, opcode, imm12, imm26, imm19, imm9, shamt, w, Rm, Rn, Rd);
  
  ze addi (_imm12, imm12);
  se #(9) se9 (_imm9, imm9);
  mux4 alu_b (_Db, Db, _imm9, _imm12, _imm12, ALUSrc);
  mux2_a rn_sel (Ab, Rd, Rm, Reg2Loc); //TODO gotta make a 5 bit 2:1 bus mux!
  
  mult mul(Da, Db, 1'b1, mul_out, mult_high);
  shifter s(Da, ~opcode[0], shamt, shift_out);
  alu xu (Da, _Db, ALUOp, Addr, _n, _z, _o, _c);

  mux4 rf_write(Dw, Addr, DataInFromDMem, mul_out, shift_out, MemToReg);

  regfile rf(Da, Db, Dw, Rn, Ab, Rd, RegWrite, clk);

  logic [63:0] pc_n;
  logic [3:0] _op1, _op2;
  logic t, nrst, t0, t1, tand, t2, t3, tsub;
  xnor _opx0(_op1[0], opcode[3], 0);
  xnor _opx1(_op1[1], opcode[2], 0);
  xnor _opx2(_op1[2], opcode[1], 1);
  xnor _opx3(_op1[3], opcode[0], 0);
  and _opx4(t0, _op1[0], _op1[1]);
  and _opx5(t1, _op1[2], _op1[3]);
  and _opx6(tand, t0,t1);

  xnor _opy0(_op2[0], opcode[3], 1);
  xnor _opy1(_op2[1], opcode[2], 0);
  xnor _opy2(_op2[2], opcode[1], 1);
  xnor _opy3(_op2[3], opcode[0], 1);
  and _opy4(t2, _op2[0], _op2[1]);
  and _opy5(t3, _op2[2], _op2[3]);
  and _opy6(tsub, t2,t3);

  or  _opz0(_t, tand,tsub);
  and _opz1(t, _t, nrst);
  not _opq0(nrst, rst);


  register_v #(4) flags ({z,o,c,n}, {_z,_o,_c,_n}, clk, rst, t);
  register_v #(64) pc_inst (pc_reg, pc_n, clk, rst, nrst);
 
  //PC computation
  logic [63:0] ls_in, ax, o0, o1;
  se #(19) se1 (_imm19,imm19);
  se #(26) se2 (_imm26,imm26);
  mux2 m_pc(ls_in, _imm19, _imm26, UncondBr);
  //LS_2 ls(ax, ls_in); // left shift 2 (mul4)
  add a4(o0, pc_reg, 64'h4); //pc+4
  add a_br(o1, pc_reg, ls_in << 2); // pc+ branch addr
  mux2 m_br(pc_n, o0, o1, BrTaken);
  always @(posedge clk) begin
    $display("o0 %x | o1 %x | pc %x pc_reg %x\n", (ls_in <<2)+pc_reg, pc_reg+64'd4, pc_n, pc_reg);
    $display("ALU0: %x | ALU1: %x\n", Da, Db);
    $display("RF:%x %x %x %x %x %x %b\n", Da, Db, Dw, Rn, Ab, Rd, RegWrite);
    $display("ALU:%x %x %x %x %x %x %b %b\n",Da, _Db, ALUOp, Addr, _n, _z, _o, _c);
    $display("MUX4:%x %x %x %x %x %x\n",Dw, Addr, DataInFromDMem, mul_out, shift_out, MemToReg);
    $display("ALUSrc:%x %x %x %x %x %x\n",_Db, Db, _imm9, _imm12, _imm12, ALUSrc);
    $display("D$: %x %x %x %x \n", shamt, DataInFromDMem, WrEn_d, Db);
  end
endmodule
