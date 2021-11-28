//top level module of pipelined processor 
`timescale 1ps/1ps
module pipelined_cpu(clk,rst);
input logic clk,rst;

logic Reg2Loc, RegWrite,MemWrite;
logic RegWrite_IF, MemWrite_IF, RegWrite_RF,MemWrite_RF;
logic RegWrite_EX, MemWrite_EX, RegWrite_MEM;
logic [1:0] MemToReg, ALUSrc, MemToReg_IF, ALUSrc_IF,MemToReg_RF, ALUSrc_RF,MemToReg_EX;
logic [2:0] ALUOp, ALUOp_IF, ALUOp_RF;
 
//////////////////////////////////////////
//   INSTRUCTION FETCH  //   IF  //
/////////////////////////////////////////

logic [63:0] pc_4, pc_br, pc_in;
logic [31:0] inst;
logic e;
assign e=1'b1;
//PC register and wires
//register_v (#32) r(data_out, data_in, clk, reset, e); 

register_v #(64) pc_reg(pc_out, pc_in, clk, rst, 1); // enable always 1?


//pc control mux - control signal = BrTaken from accelerated Br unit
// Branch target comes from accelerated branch unit in RF stage 

//logic [63:0] ls_in, ax, o0, o1;  // ALL THIS MOVED TO ACC BR UNIT

  //se #(19) se1 (_imm19,imm19);
  //se #(26) se2 (_imm26,imm26);
  //mux2 m_pc(ls_in, _imm19, _imm26, UncondBr);
  //LS_2 ls(ax, ls_in); // left shift 2 (mul4)
  //add a_br(o1, pc_reg, ax); // pc+ branch addr
  
  add a4(pc_4, pc_out, 64'h4); //pc+4
                                               
  mux2 m_br(pc_in, pc_4, pc_br, BrTaken_RF); // pc select mux

// inst mem instance 

instructmem im(pc_out, inst, clk);
  

//intermediate IF registers

// register_v (#32) reg(out, in, clk, reset, e); using variable length reg for every stored value

register_v #(32) inst_IF_reg(inst_IF, inst, clk, reset, e); // INSTRUCTION REGISTER


/////////////////////////////////////////
//   REG FETCH/DECODE  //   RF   //
////////////////////////////////////////
logic [4:0] Rm,Rn,Rd;
logic [11:0] imm12;
logic [25:0] imm26;
logic [18:0] imm19;
logic [8:0] imm9;
logic [5:0] shamt;
logic [3:0] opcode;

// DECODE inst from INSTRUCTION REGISTER 
idecode id(inst_IF, opcode, imm12, imm26, imm19, imm9, shamt, w, Rm, Rn, Rd); //what is w?

//main control unit - gives out all control signals (put control signal assignments from sc_cpu in separate module,
//( remove BrTaken and UncondBr since they moved to accelerated br unit)

control c(opcode, Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite,ALUOp);

//REGISTERs

//regfile with clock gating 
//mux for ab(Reg2Loc)
mux2_a rn_sel (Ab, Rd, Rm, Reg2Loc);
regfile rf(Da, Db, Dw, Rn, Ab, Rd, RegWrite_MEM, clk);



// forwarding unit 
logic forward_a,forward_b;// mux selects
logic [63:0] da,db,da_RF,db_RF; //outputs of fwd mux
forwarding fwd(forward_a,forward_b,Rn,Rm,Rd_EX,RegWrite_EX,Rd_MEM,RegWrite_MEM);

// forwarding MUXES - 4:1 in- regfile a/b, aluout, memout 0-reg, 1- ex 2-mem
mux4 fwd_a(da, Da, alu_out, mem_out, 0,forward_a);
mux4 fwd_b(db, Db, alu_out, mem_out, 0,forward_b); //USE da db  IN ALU


//accelerated branch unit

accelerated_branch accb(pc_br,BrTaken, pc_out, db,n,o,opcode,imm19,imm26);

//intermediate RF registers
//register_v (#1) Reg2Loc_RF_reg(Reg2Loc_RF, Reg2Loc, clk, reset, e);  

// control signals 

register_v #(1) MemToReg_RF_reg(MemToReg_RF, MemToReg, clk, reset, e); 
register_v #(1) RegWrite_RF_reg(RegWrite_RF, RegWrite, clk, reset, e); 
register_v #(1) MemWrite_RF_reg(MemWrite_RF, MemWrite, clk, reset, e); 

register_v #(1) BrTaken_RF_reg(BrTaken_RF, BrTaken, clk, reset, e); 
register_v #(1) ALUOp_RF_reg(ALUOp_RF, ALUOp, clk, reset, e); 
register_v #(1) ALUSrc_RF_reg(ALUSrc_RF, ALUSrc, clk, reset, e); 

// Rd Rn outputs 

register_v #(5) Rd_RF_reg(Rd_RF, Rd, clk, reset, e); 
register_v #(5) Rn_RF_reg(Rn_RF, Rn, clk, reset, e); 
register_v #(5) Rm_RF_reg(Rm_RF, Rm, clk, reset, e); 


register_v #(64) da_RF_reg(da_RF, da, clk, reset, e); //regfile outputs afer fwd mux
register_v #(64) db_RF_reg(db_RF, db, clk, reset, e); 


///////////////////////////////////////
//EXCECUTE    //  EX  //
///////////////////////////////////////

//flag registers 

// muxes for flags update based on ADDS,SUBS

//alu instance 
mux4 alu_b (_Db, db_RF, _imm9, _imm12, _imm12, ALUSrc_RF);
mult mul(da_RF, db_RF, 1'b1, mul_out, mult_high);
shifter s(da_RF, ~opcode[0], shamt, shift_out);
alu xu(da_RF, _Db, ALUOp_RF, alu_out, _n, _z, _o, _c);

 
  
  
// intermediate EX registers

//register_v (#1) Reg2Loc_EX_reg(Reg2Loc_RF, Reg2Loc, clk, reset, e);  // control signals 
register_v #(1) MemToReg_EX_reg(MemToReg_EX, MemToReg_RF, clk, reset, e); 
register_v #(1) RegWrite_EX_reg(RegWrite_EX, RegWrite_RF, clk, reset, e); 
register_v #(1) MemWrite_EX_reg(MemWrite_EX, MemWrite_RF, clk, reset, e); 


register_v #(5) Rd_EX_reg(Rd_EX, Rd_RF, clk, reset, e); 


register_v #(64) alu_out_EX_reg(alu_out_EX, alu_out, clk, reset, e); 
register_v #(64) mul_out_EX_reg(mul_out_EX, mul_out, clk, reset, e); 
register_v #(64) shift_out_EX_reg(shift_out_EX, shift_out, clk, reset, e); 


register_v #(64) db_EX_reg(db_EX, db_RF, clk, reset, e); 

//register_v (#5) Rn_EX_reg(Rn_EX, Rn_RF, clk, reset, e); 
//register_v (#5) Rm_EX_reg(Rm_EX, Rm_RF, clk, reset, e); 


/////////////////////////////////////
// MEMORY   //   MEM   // 
////////////////////////////////////

// data mem instance 

datamem dm(addr, MemWrite_EX, 1'b1, db_EX, clk, 4'd8, din);

mux4 rf_write(Dw, alu_out_EX, din, mul_out_EX, shift_out_EX, MemToReg_EX);


// intermediate MEM regs
register_v #(1) RegWrite_MEM_reg(RegWrite_MEM, RegWrite_EX, clk, reset, e); 

register_v #(5) Rd_MEM_reg(Rd_MEM, Rd_EX, clk, reset, e); 

//register_v (#5) Rn_MEM_reg(Rn_MEM, Rn_EX, clk, reset, e); 
//register_v (#5) Rm_MEM_reg(Rm_MEM, Rm_EX, clk, reset, e); 

///////////////////////////////////////
//   REGISTER WRITEBACK   //   WB  //
//////////////////////////////////////

// wiring back to regfile - Dw and RegWrite_MEM

initial $monitor(
  "Commit: %x\n", $time,
  "\tPC %x | Insn %x\n", '0, '0,
  "rs1 %x @%x | rs2 %x @x\n", '0, '0, '0, '0, //TODO propagate rsx and rsx_id for commit stage verification
  "\trd %x @%x | xcpt %b\n", Dw, Rd, 1'b0, //TODO xcpt/jump indication for sanity
);

endmodule
