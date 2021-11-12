`timescale 1ps/1ps
`define PC_INIT 0

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
  
  typedef enum logic[3:0] // define opcodes 
    { ADDI, ADDS, BLT, B, CBZ, LDUR, LSL, LSR, MUL, STUR, SUBS , INV } ops;
  
  //decoder wires
  logic [3:0]  opcode; 
  logic [11:0] imm12;
  logic [25:0] imm26;
  logic [18:0] imm19;
  logic [8:0]  imm9, _imm9;
  logic [5:0]  shamt;
  logic [4:0]  rm, rn, rd;

  //rf wires
  logic [4:0]  Aw, Ab, Aa;
  logic [63:0] Da, _Db, Dw;
  logic WrEn;

  //ALU wires
  logic [63:0] r, _Db;
  logic [2:0] aluc;
  logic [63:0] mul_out, mult_high, shift_out;
  //0 -
	logic MemToReg = opcode == LDUR ? 2'd1 
    : opcode == MUL ? 2'd2 
    : opcode == LSL || opcode == LSR ? 2'd3
    : 2'd0;
      logic [63:0] r, _Db;
  logic [2:0] aluc;
  logic [63:0] mul_out, mult_high, shift_out;
  //0 -
  logic MemToReg = opcode == LDUR ? 2'd1
    : opcode == MUL ? 2'd2
    : opcode == LSL || opcode == LSR ? 2'd3
    : 2'd0;
  logic Reg2Loc = opcode == CBZ;
  logic RegWrite = ~(opcode == B
    || opcode == BLT
    || opcode == CBZ
    || opcode == STUR)
  logic MemWrite = opcode == STUR;
  logic BrTaken = (opcode == B
    || opcode == BLT
    || opcode == CBZ)
  logic ALUOp == opcode == SUBS ? 3'd3 : 3'd2;
  logic ALUSrc = opcode == LDUR || opcode == STUR;
  logic UncondBr = opcode == BLT || opcode == CBZ;
  //D$ write enable:
  assign write_enable = opcode == STUR;

  //inst decoder, alu, rf, mul, shifter
  idecode id(inst, opcode, imm12, imm26, imm19, imm9, shamt, w, rm, rn, rd, aluc);

  se se9 #(9) (imm9_1, imm9)
  mux2 m2(_Db, Db, imm9_1, ALUSrc);
  mux2 m3(Ab, Rm, Rd, Reg2Loc); //TODO gotta make a 5 bit 2:1 bus mux!
  
  mult mul(Da, Db, 1'b1, mul_out, mul_high);
  shifter s(Da, opcode[0], shamt, shift_out);
  alu x(Da, _Db, ALUOp, Addr, address, _n, _z, _o, _c);

  mux4 rf_write(Dw, Addr, Dout, mul_out, shift_out, MemToReg);

  regfile rf(Da, Db, Dw, Aa, Ab, Aw, WrEn, clk);

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
      //PC calculation
      pc <= opcode == B || opcode == BLT && (o ^ n) || opcode == CBZ && _z ? // expand with adder, mux, se
        pc + (opcode == BLT || opcode == CBZ ? imm19 : imm26) << 2 : pc + 32'd4;
    end
  end
 
 //PC
  logic [63:0]ls_in,x;

  se se1 #(19)(_imm19,imm19);
  se se2 #(26)(_imm26,imm26);
  mux2 m_pc(ls_in,_imm19,_imm26,UncondBr);
  LS_2 ls(x,ls_in); // left shift 2 (mul4)
  add a4(o0,pc,64'b4); //pc+4
  add a_br(o1,pc,x); // pc+ branch addr
  mux2 m_br(pc,o0,o1,BrTaken);


  mux4 rf_w_mux (out, alu_result,dout,mul_out,shift_out, MemToReg);
  mux2 (ab,rd,rm, Reg2Loc);
 
  always_comb begin
    //RF related assignments
    
	  wd = opcode == LDUR ? read_data : addr_out; //MemToReg - expand as mux
    w = !(opcode == STUR || // MemWrite 
      opcode == CBZ  ||
      opcode == B    ||
      opcode == BLT);
    ab = opcode == CBZ || opcode == STUR ? rd : rm; // Reg2Loc
  end
endmodule
