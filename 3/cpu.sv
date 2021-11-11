`timescale 1ps/1ps
`define PC_INIT 0

//Enka -- our single cycle ARM CPU!
module sc_cpu (
  input  logic        clk,
  input  logic        rst,

  //d$ (from template provided)
  output logic [63:0] address,
  output logic        write_enable,
  output logic [63:0] write_data,
  input  logic [63:0] read_data,

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
  //logic [2:0] aluc;
  logic [63:0] mul_out,mult_high, shift_out;
  
  
	logic MemToReg,Reg2Loc,RegWrite,MemWrite,BrTaken,ALUOp,ALUSrc, UncondBr; //check again
  
  
  //D$ write enable:
  assign write_enable = opcode == STUR;
  
    
  

  //inst decoder, alu, rf, mul, shifter
  idecode id(inst, opcode, imm12, imm26, imm19, imm9, shamt, w, rm, rn, rd, aluc);
  alu x(da, db, alu_c, alu_result, address, _n, _z, _o, _c);
  //module regfile(ReadData1, ReadData2, WriteData, ReadRegister1, ReadRegister2, WriteRegister, RegWrite, clk);
  regfile rf(da, write_data, wd, rn, ab, rd, w, clk);
  mult m(rn, rm,
	1,				// 1: signed multiply 
	mul_out, mult_high  // 
	);
  shifter s(rn,
	opcode[0], // 0: left, 1: right opcode[0]
	shamt,shift_out);

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
      pc <= opcode == B || opcode == BLT && (o ^ n) || opcode == CBZ && _z ? // expand with adder, mux, se
        pc + (opcode == BLT || opcode == CBZ ? imm19 : imm26) << 2 : pc + 32'd4;
    end
  end
  
  // Muxes - remaining signals to be done similarly
  
//module mux2(out, in0,in1, sel); 
//regfile rf(da, write_data, wd, rn, ab, rd, w, clk);
// module mux4(out, in0,in1,in2,in3, sel); 
 mux4(out, alu_result,dout,mul_out,shift_out, MemToReg); // includes mul and shift 
 mux2(ab,rd,rm,Reg2Loc);
 
// CONTROL IN RTL , these outputs go into muxes 
  
  always_comb begin
  // change names of control signals to MemToReg, Memwrite,etc as in diagram
    //RF related assignments
    
	 //MemToReg = opcode == LDUR ; ADD LOGIC FOR MUL/SHIFT
    
	 wd = opcode == LDUR ? read_data : addr_out; //MemToReg - expand as mux
    w = !(opcode == STUR || // MemWrite 
      opcode == CBZ  ||
      opcode == B    ||
      opcode == BLT);
    ab = opcode == CBZ || opcode == STUR ? rd : rm; // Reg2Loc

    //ALU connections
    db = () ? write_data : imm9; //TODO
	 //RegWrite =
	 //ALUSrc =
	 //ALUOP =
	 //BrTaken =
	 //UncondBr =
  end
endmodule
