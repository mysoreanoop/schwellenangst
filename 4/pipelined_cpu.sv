//top level module of pipelined processor 
`timescale 1ps/1ps
module pipelined_cpu(clk,reset);
input logic clk,reset;

initial $display ("Starting at the pipeline!!!");
logic Reg2Loc, RegWrite,MemWrite;
logic RegWrite_IF, MemWrite_IF;
logic RegWrite_EX, MemWrite_EX, RegWrite_MEM;
logic [1:0] MemToReg, ALUSrc, ALUSrc_IF, MemToReg_IF, MemToReg_EX;
logic [2:0] ALUOp, ALUOp_IF;
 
//////////////////////////////////////////
//   INSTRUCTION FETCH  //   IF  //
/////////////////////////////////////////

logic [63:0] pc_4, pc_br, pc_in, pc_out;
logic [31:0] insn;

//PC register and wires
register_v #(64) pc_reg(pc_out, pc_in, clk, reset, 1'b1);

//pc control mux - control signal = BrTaken from accelerated Br unit
// Branch target comes from accelerated branch unit in RF stage 

  add a4(pc_4, pc_out, 64'h4); //pc+4
  mux2 #(64) m_br(pc_in, pc_4, pc_br, BrTaken_IF); // pc select mux

// inst mem instance 
instructmem im(pc_out, insn, clk);
  
///////////////////////////////////////////
////   INSN FETCH/DECODE  //   RF   //
//////////////////////////////////////////
//IF registers
logic [31:0] inst_IF;
register_v #(32) inst_IF_reg(inst_IF, insn, clk, reset, 1'b1);
always@(posedge clk)
  $display (
    "Fetch\n",
    "PC %x Insn %x\n", pc_out, inst_IF);

logic [4:0] Rm,Rn,Rd;
logic [11:0] imm12;
logic [25:0] imm26;
logic [18:0] imm19;
logic [8:0] imm9;
logic [5:0] shamt;
logic [3:0] opcode;

//// DECODE inst from INSTRUCTION REGISTER 
idecode id(inst_IF, opcode, imm12, imm26, imm19, imm9, shamt, Rm, Rn, Rd);

//main control unit - gives out all control signals (put control signal assignments from sc_cpu in separate module,

control c(opcode, Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite,ALUOp);

//REGISTERs

//regfile with clock gating 
//mux for ab(Reg2Loc)
logic [4:0] Ab;
mux2 #(5) rn_sel (Ab, Rd, Rm, Reg2Loc);
logic [63:0] Da, Db, Dw;
regfile rf(Da, Db, Dw, Rn, Ab, Rd, RegWrite_MEM, clk);

// forwarding unit 
logic [1:0] forward_a, forward_b;// mux selects
logic [63:0] da,db,da_IF,db_IF; //outputs of fwd mux
logic [63:0] alu_out, mem_out;
logic [4:0] Rd_EX, Rd_MEM;
forwarding fwd(forward_a,forward_b,Rn,Rm,Rd_EX,RegWrite_EX,Rd_MEM,RegWrite_MEM);

// forwarding MUXES - 4:1 in- regfile a/b, aluout, memout 0-reg, 1- ex 2-mem
mux4 fwd_a(da, Da, alu_out, mem_out, '0,forward_a);
mux4 fwd_b(db, Db, alu_out, mem_out, '0,forward_b); //USE da db  IN ALU

//accelerated branch unit
accelerated_branch accb(pc_br,BrTaken, pc_out, db,n,o,opcode,imm19,imm26);

//intermediate RF registers
//register_v (#1) Reg2Loc_IF_reg(Reg2Loc_IF, Reg2Loc, clk, reset, 1'b1);  

// control signals 
register_v #(2) MemToReg_IF_reg(MemToReg_IF, MemToReg, clk, reset, 1'b1); 
register_v #(1) RegWrite_IF_reg(RegWrite_IF, RegWrite, clk, reset, 1'b1); 
register_v #(1) MemWrite_IF_reg(MemWrite_IF, MemWrite, clk, reset, 1'b1); 

register_v #(1) BrTaken_IF_reg(BrTaken_IF, BrTaken, clk, reset, 1'b1);
register_v #(3) ALUOp_IF_reg(ALUOp_IF, ALUOp, clk, reset, 1'b1); 
register_v #(2) ALUSrc_IF_reg(ALUSrc_IF, ALUSrc, clk, reset, 1'b1); 

// Rd Rn outputs 
logic [4:0] Rd_IF, Rn_IF, Rm_IF;
register_v #(5) Rd_IF_reg(Rd_IF, Rd, clk, reset, 1'b1); 
register_v #(5) Rn_IF_reg(Rn_IF, Rn, clk, reset, 1'b1); 
register_v #(5) Rm_IF_reg(Rm_IF, Rm, clk, reset, 1'b1); 

register_v #(64) da_IF_reg(da_IF, da, clk, reset, 1'b1); //regfile outputs afer fwd mux
register_v #(64) db_IF_reg(db_IF, db, clk, reset, 1'b1); 
logic [63:0] pc_ID;
logic [31:0] insn_ID;
register_v #(64) pc_ID_reg(pc_ID, pc_out, clk, reset, 1'b1); 
register_v #(32) insn_ID_reg(insn_ID, inst_IF, clk, reset, 1'b1); 


/////////////////////////////////////////
////EXCECUTE    //  EX  //
/////////////////////////////////////////

//flag registers 
// muxes for flags update based on ADDS,SUBS

//alu instance 
logic [63:0] _Db, _imm9, _imm12, shift_out, mul_out, mult_high;
mux4 alu_b (_Db, db_IF, _imm9, _imm12, _imm12, ALUSrc_IF);
mult mul(da_IF, db_IF, 1'b1, mul_out, mult_high);
shifter s(da_IF, ~opcode[0], shamt, shift_out);
alu xu(da_IF, _Db, ALUOp_IF, alu_out, _n, _z, _o, _c);
  
// intermediate EX registers
//register_v (#1) Reg2Loc_EX_reg(Reg2Loc_IF, Reg2Loc, clk, reset, 1'b1);  // control signals 
register_v #(2) MemToReg_EX_reg(MemToReg_EX, MemToReg_IF, clk, reset, 1'b1);
register_v #(1) RegWrite_EX_reg(RegWrite_EX, RegWrite_IF, clk, reset, 1'b1);
register_v #(1) MemWrite_EX_reg(MemWrite_EX, MemWrite_IF, clk, reset, 1'b1);
register_v #(1) BrTaken_EX_reg(BrTaken_EX, BrTaken_IF, clk, reset, 1'b1);

register_v #(5) Rd_EX_reg(Rd_EX, Rd_IF, clk, reset, 1'b1); 

logic [63:0] alu_out_EX, mul_out_EX, shift_out_EX, db_EX;
register_v #(64) alu_out_EX_reg(alu_out_EX, alu_out, clk, reset, 1'b1); 
register_v #(64) mul_out_EX_reg(mul_out_EX, mul_out, clk, reset, 1'b1); 
register_v #(64) shift_out_EX_reg(shift_out_EX, shift_out, clk, reset, 1'b1); 

register_v #(64) db_EX_reg(db_EX, db_IF, clk, reset, 1'b1); 

//For commit trace
logic [4:0] Rn_EX, Rm_EX, Rn_MEM, Rm_MEM;
register_v #(5) Rn_EX_reg(Rn_EX, Rn_IF, clk, reset, 1'b1); 
register_v #(5) Rm_EX_reg(Rm_EX, Rm_IF, clk, reset, 1'b1); 
logic [63:0] pc_EX;
logic [31:0] insn_EX;
register_v #(64) pc_EX_reg(pc_EX, pc_ID, clk, reset, 1'b1); 
register_v #(32) insn_EX_reg(insn_EX, insn_ID, clk, reset, 1'b1); 


///////////////////////////////////////
//// MEMORY   //   MEM   // 
//////////////////////////////////////

// data mem instance 
//TODO check; was addr; changed to alu_out_EX
logic [63:0] din;
datamem dm(alu_out_EX, MemWrite_EX, 1'b1, db_EX, clk, 4'd8, din);

mux4 rf_write(Dw, alu_out_EX, din, mul_out_EX, shift_out_EX, MemToReg_EX);


// intermediate MEM regs
register_v #(1) RegWrite_MEM_reg(RegWrite_MEM, RegWrite_EX, clk, reset, 1'b1); 

register_v #(5) Rd_MEM_reg(Rd_MEM, Rd_EX, clk, reset, 1'b1); 

//For commit trace
register_v #(5) Rn_MEM_reg(Rn_MEM, Rn_EX, clk, reset, 1'b1); 
register_v #(5) Rm_MEM_reg(Rm_MEM, Rm_EX, clk, reset, 1'b1); 
register_v #(1) BrTaken_MEM_reg(BrTaken_MEM, BrTaken_EX, clk, reset, 1'b1); 
logic [63:0] pc_MEM;
logic [31:0] insn_MEM;
register_v #(64) pc_MEM_reg(pc_MEM, pc_EX, clk, reset, 1'b1); 
register_v #(32) insn_MEM_reg(insn_MEM, insn_EX, clk, reset, 1'b1); 


/////////////////////////////////////////
////   REGISTER WRITEBACK   //   WB  //
////////////////////////////////////////

// wiring back to regfile - Dw and RegWrite_MEM

initial $monitor(
  "Commit: %x\n", $time,
  "\tPC %x | Insn %x\n", pc_MEM, insn_MEM,
  "\trs1 %x @%x | rs2 %x @x\n", '0, Rn_MEM, '0, Rm_MEM,
  "\trd %x @%x | b %b\n", Dw, Rd, BrTaken_MEM
);

endmodule
