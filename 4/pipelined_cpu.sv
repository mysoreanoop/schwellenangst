//top level module of pipelined processor 
`timescale 1ps/1ps
module pipelined_cpu(clk,reset);
input logic clk,reset;

initial $display ("Starting at the pipeline!!!");
logic Reg2Loc, RegWrite,MemWrite;
logic RegWrite_IF, MemWrite_IF, RegWrite_RF,MemWrite_RF;
logic RegWrite_EX, MemWrite_EX, RegWrite_MEM;
logic [1:0] MemToReg, ALUSrc, MemToReg_IF, ALUSrc_IF,MemToReg_RF, ALUSrc_RF,MemToReg_EX;
logic [2:0] ALUOp, ALUOp_IF, ALUOp_RF;
 
//////////////////////////////////////////
//   INSTRUCTION FETCH  //   IF  //
/////////////////////////////////////////

logic [63:0] pc_4, pc_br, pc_in, pc_out;
logic [31:0] inst;

//PC register and wires
register_v #(64) pc_reg(pc_out, pc_in, clk, reset, 1'b1);

//pc control mux - control signal = BrTaken from accelerated Br unit
// Branch target comes from accelerated branch unit in RF stage 

  add a4(pc_4, pc_out, 64'h4); //pc+4
  mux2 m_br(pc_in, pc_4, pc_br, BrTaken_RF); // pc select mux

// inst mem instance 
instructmem im(pc_out, inst, clk);
  

//IF registers
register_v #(32) inst_IF_reg(inst_IF, inst, clk, reset, e);
always@(posedge clk)
  $display (
    "Fetch\n",
    "PC %x Insn %x\n", pc_out, inst_IF);

///////////////////////////////////////////
////   REG FETCH/DECODE  //   RF   //
//////////////////////////////////////////
logic [4:0] Rm,Rn,Rd;
logic [11:0] imm12;
logic [25:0] imm26;
logic [18:0] imm19;
logic [8:0] imm9;
logic [5:0] shamt;
logic [3:0] opcode;

//// DECODE inst from INSTRUCTION REGISTER 
idecode id(inst_IF, opcode, imm12, imm26, imm19, imm9, shamt, Rm, Rn, Rd);
//
////main control unit - gives out all control signals (put control signal assignments from sc_cpu in separate module,
////( remove BrTaken and UncondBr since they moved to accelerated br unit)
//
//control c(opcode, Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite,ALUOp);
//
////REGISTERs
//
////regfile with clock gating 
////mux for ab(Reg2Loc)
//mux2_a rn_sel (Ab, Rd, Rm, Reg2Loc);
//regfile rf(Da, Db, Dw, Rn, Ab, Rd, RegWrite_MEM, clk);
//
//
//
//// forwarding unit 
//logic forward_a,forward_b;// mux selects
//logic [63:0] da,db,da_RF,db_RF; //outputs of fwd mux
//forwarding fwd(forward_a,forward_b,Rn,Rm,Rd_EX,RegWrite_EX,Rd_MEM,RegWrite_MEM);
//
//// forwarding MUXES - 4:1 in- regfile a/b, aluout, memout 0-reg, 1- ex 2-mem
//mux4 fwd_a(da, Da, alu_out, mem_out, 0,forward_a);
//mux4 fwd_b(db, Db, alu_out, mem_out, 0,forward_b); //USE da db  IN ALU
//
//
////accelerated branch unit
//
//accelerated_branch accb(pc_br,BrTaken, pc_out, db,n,o,opcode,imm19,imm26);
//
////intermediate RF registers
////register_v (#1) Reg2Loc_RF_reg(Reg2Loc_RF, Reg2Loc, clk, reset, e);  
//
//// control signals 
//
//register_v #(1) MemToReg_RF_reg(MemToReg_RF, MemToReg, clk, reset, e); 
//register_v #(1) RegWrite_RF_reg(RegWrite_RF, RegWrite, clk, reset, e); 
//register_v #(1) MemWrite_RF_reg(MemWrite_RF, MemWrite, clk, reset, e); 
//
register_v #(1) BrTaken_RF_reg(BrTaken_RF, 0, clk, reset, 1'b1); 
//register_v #(1) BrTaken_RF_reg(BrTaken_RF, BrTaken, clk, reset, 1'b1); 
//always @(posedge clk)
//  if(reset)
//    BrTaken_RF <= 0;
//  else
//    BrTaken_RF <= 0;//BrTaken;
//register_v #(1) ALUOp_RF_reg(ALUOp_RF, ALUOp, clk, reset, e); 
//register_v #(1) ALUSrc_RF_reg(ALUSrc_RF, ALUSrc, clk, reset, e); 
//
//// Rd Rn outputs 
//
//register_v #(5) Rd_RF_reg(Rd_RF, Rd, clk, reset, e); 
//register_v #(5) Rn_RF_reg(Rn_RF, Rn, clk, reset, e); 
//register_v #(5) Rm_RF_reg(Rm_RF, Rm, clk, reset, e); 
//
//
//register_v #(64) da_RF_reg(da_RF, da, clk, reset, e); //regfile outputs afer fwd mux
//register_v #(64) db_RF_reg(db_RF, db, clk, reset, e); 
//
//
/////////////////////////////////////////
////EXCECUTE    //  EX  //
/////////////////////////////////////////
//
////flag registers 
//
//// muxes for flags update based on ADDS,SUBS
//
////alu instance 
//mux4 alu_b (_Db, db_RF, _imm9, _imm12, _imm12, ALUSrc_RF);
//mult mul(da_RF, db_RF, 1'b1, mul_out, mult_high);
//shifter s(da_RF, ~opcode[0], shamt, shift_out);
//alu xu(da_RF, _Db, ALUOp_RF, alu_out, _n, _z, _o, _c);
//
// 
//  
//  
//// intermediate EX registers
//
////register_v (#1) Reg2Loc_EX_reg(Reg2Loc_RF, Reg2Loc, clk, reset, e);  // control signals 
//register_v #(1) MemToReg_EX_reg(MemToReg_EX, MemToReg_RF, clk, reset, e); 
//register_v #(1) RegWrite_EX_reg(RegWrite_EX, RegWrite_RF, clk, reset, e); 
//register_v #(1) MemWrite_EX_reg(MemWrite_EX, MemWrite_RF, clk, reset, e); 
//
//
//register_v #(5) Rd_EX_reg(Rd_EX, Rd_RF, clk, reset, e); 
//
//
//register_v #(64) alu_out_EX_reg(alu_out_EX, alu_out, clk, reset, e); 
//register_v #(64) mul_out_EX_reg(mul_out_EX, mul_out, clk, reset, e); 
//register_v #(64) shift_out_EX_reg(shift_out_EX, shift_out, clk, reset, e); 
//
//
//register_v #(64) db_EX_reg(db_EX, db_RF, clk, reset, e); 
//
////register_v (#5) Rn_EX_reg(Rn_EX, Rn_RF, clk, reset, e); 
////register_v (#5) Rm_EX_reg(Rm_EX, Rm_RF, clk, reset, e); 
//
//
///////////////////////////////////////
//// MEMORY   //   MEM   // 
//////////////////////////////////////
//
//// data mem instance 
//
//datamem dm(addr, MemWrite_EX, 1'b1, db_EX, clk, 4'd8, din);
//
//mux4 rf_write(Dw, alu_out_EX, din, mul_out_EX, shift_out_EX, MemToReg_EX);
//
//
//// intermediate MEM regs
//register_v #(1) RegWrite_MEM_reg(RegWrite_MEM, RegWrite_EX, clk, reset, e); 
//
//register_v #(5) Rd_MEM_reg(Rd_MEM, Rd_EX, clk, reset, e); 
//
////register_v (#5) Rn_MEM_reg(Rn_MEM, Rn_EX, clk, reset, e); 
////register_v (#5) Rm_MEM_reg(Rm_MEM, Rm_EX, clk, reset, e); 
//
/////////////////////////////////////////
////   REGISTER WRITEBACK   //   WB  //
////////////////////////////////////////
//
//// wiring back to regfile - Dw and RegWrite_MEM
//
//initial $monitor(
//  "Commit: %x\n", $time,
//  "\tPC %x | Insn %x\n", '0, '0,
//  "\trs1 %x @%x | rs2 %x @x\n", '0, '0, '0, '0, //TODO propagate rsx and rsx_id for commit stage verification
//  "\trd %x @%x | xcpt %b\n", Dw, Rd, 1'b0, //TODO xcpt/jump indication for sanity
//);

endmodule
