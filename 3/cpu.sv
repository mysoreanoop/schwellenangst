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
  
	logic MemToReg 
	logic Reg2Loc
	logic RegWrite
	logic MemWrite
	logic BrTaken
	logic ALUOp
	logic ALUSrc
	logic UncondBr; //check again
  
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
