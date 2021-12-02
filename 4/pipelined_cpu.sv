//top level module of pipelined processor 
`timescale 1ps/1ps
module pipelined_cpu(clk,reset);
input logic clk,reset;

initial $display ("Starting at the pipeline!!!");
logic Reg2Loc, RegWrite,MemWrite;
logic RegWrite_IF, MemWrite_IF;
logic RegWrite_EX, MemWrite_EX, RegWrite_MEM;
logic [1:0] MemToReg, ALUSrc, ALUSrc_ID, MemToReg_ID, MemToReg_EX;
logic [2:0] ALUOp, ALUOp_ID;
logic z,o,c,n,_z,_o,_c,_n;


 
//////////////////////////////////////////
//   INSTRUCTION FETCH  //   IF  //
/////////////////////////////////////////

logic [63:0] pc_4, pc_br,pc_br_ID, pc_in, pc_IF, _pc_in, reset_pc;
logic [31:0] insn;
//TODO insn is available in IF itself (I$ is async read)
//So, we can decode it right away; or register it into insn_IF
//and then decode in ID stage
//Without this, most subsequent operations will be frame shifted in time outwards

//PC register and wires
logic reset_r;
register_v #(1) reset_reg(reset_r, reset, clk, 1'b0, 1'b1);

register_v #(64) pc_reg(pc_IF, _pc_in, clk, reset, 1'b1);

//pc control mux - control signal = BrTaken from accelerated Br unit
// Branch target comes from accelerated branch unit in RF stage 

register_v #(64) pc_res(reset_pc,'0, clk, reset, 1'b1);


mux2 pc_rst(_pc_in,pc_in,reset_pc,reset_r); //reset pc
  add a4(pc_4, pc_IF, 64'h4); //pc+4
  mux2 #(64) m_br(pc_in, pc_4, pc_br_ID, BrTaken_ID); // pc select mux
  //TODO not sure why BrTaken_ID here; check it

// inst mem instance 
instructmem im(_pc_in, insn, clk);
  
///////////////////////////////////////////
////   REG FETCH/INSN DECODE  //   ID   //
//////////////////////////////////////////
//ID registers
logic [31:0] inst_ID;
register_v #(32) inst_ID_reg(inst_ID, insn, clk, reset, 1'b1);

logic [4:0] Rm,Rn,Rd, Rd_MEM, Rd_EX;
logic [63:0] imm12;
logic [63:0] imm26;
logic [63:0] imm19;
logic [63:0] imm9;
logic [5:0] shamt,shamt_ID;
logic [3:0] opcode,opcode_ID;

//// DECODE inst from INSTRUCTION REGISTER 
idecode id(inst_ID, opcode, imm12, imm26, imm19, imm9, shamt, Rm, Rn, Rd);

//main control unit - gives out all control signals (put control signal assignments from sc_cpu in separate module,

control con(opcode, Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite,ALUOp);

//REGISTERs

//regfile with clock gating 
//mux for ab(Reg2Loc)
logic [4:0] Ab;
mux2 #(5) rn_sel (Ab, Rd, Rm, Reg2Loc);
logic [63:0] Da, Db, Dw;
//regfile rf(Da, Db, Dw, Rn, Ab, Rd_EX, RegWrite_MEM, clk);
regfile rf(Da, Db, Dw, Rn, Ab, Rd_EX, RegWrite_EX, clk);

// forwarding unit 
logic [1:0] forward_a, forward_b;// mux selects
logic [63:0] da,db,da_ID,db_ID; //outputs of fwd mux
logic [63:0] alu_out, alu_o,alu_o_EX, alu_out_EX;
//logic [4:0] Rd_EX;
logic [4:0] Rd_ID, Rn_ID, Rm_ID;

//forwarding fwd(forward_a,forward_b,Rn,Rm,Rd_EX,RegWrite_EX,Rd_MEM,RegWrite_MEM);
//forwarding fwd(forward_a,forward_b,Rn,Rm,Rd_ID,RegWrite_ID,Rd_EX,RegWrite_EX);

forwarding fwd(forward_a,forward_b,Rn,Ab,Rd_ID,RegWrite_ID,Rd_EX,RegWrite_EX);


// forwarding MUXES - 4:1 in- regfile a/b, aluout, memout 0-reg, 1- ex 2-mem
mux4 fwd_a(da, Da, alu_o, Dw, '0,forward_a); // NEWW
mux4 fwd_b(db, Db, alu_o, Dw, '0,forward_b); //

//mux4 fwd_a(da, Da, alu_o, alu_o_EX, '0,forward_a); // new
//mux4 fwd_b(db, Db, alu_o, alu_o_EX, '0,forward_b); //USE da db  IN ALU after reg
//mux4 fwd_a(da, Da, alu_out, alu_out_EX, '0,forward_a); //ORIGINAL
//mux4 fwd_b(db, Db, alu_out, alu_out_EX, '0,forward_b); //USE da db  IN ALU after reg


//TRYING SOMETHING here - remove later
//mux4 fwd_a(da, Da, alu_out, mem_out, '0,'0);
//mux4 fwd_b(db, Db, alu_out, mem_out, '0,'0); //USE da db  IN ALU

//accelerated branch unit
//accelerated_branch accb(pc_br,BrTaken, pc_IF, db,_n,_o,opcode,imm19,imm26);
accelerated_branch accb(pc_br,BrTaken, pc_IF, db,n,o,_n,_o,opcode,opcode_ID,imm19,imm26);


//check flags 

//intermediate RF registers
//register_v (#1) Reg2Loc_IF_reg(Reg2Loc_IF, Reg2Loc, clk, reset, 1'b1);  

// control signals 
register_v #(2) MemToReg_ID_reg(MemToReg_ID, MemToReg, clk, reset, 1'b1); 
register_v #(1) RegWrite_ID_reg(RegWrite_ID, RegWrite, clk, reset, 1'b1); 
register_v #(1) MemWrite_ID_reg(MemWrite_ID, MemWrite, clk, reset, 1'b1); 

register_v #(1) BrTaken_ID_reg(BrTaken_ID, BrTaken, clk, reset, 1'b1);
register_v #(3) ALUOp_ID_reg(ALUOp_ID, ALUOp, clk, reset, 1'b1); 
register_v #(2) ALUSrc_ID_reg(ALUSrc_ID, ALUSrc, clk, reset, 1'b1); 

register_v #(64) pc_br_ID_reg(pc_br_ID, pc_br, clk, reset, 1'b1);
logic [63:0] imm9_ID,imm12_ID,imm26_ID,imm19_ID;
register_v #(256) Imm_ID_reg({imm9_ID,imm12_ID,imm26_ID,imm19_ID}, {imm9,imm12,imm26,imm19}, clk, reset, 1'b1);


// Rd Rn outputs 
register_v #(5) Rd_ID_reg(Rd_ID, Rd, clk, reset, 1'b1); 
register_v #(5) Rn_ID_reg(Rn_ID, Rn, clk, reset, 1'b1); 
register_v #(5) Rm_ID_reg(Rm_ID, Rm, clk, reset, 1'b1); 

register_v #(6) shamt_ID_reg(shamt_ID, shamt, clk, reset, 1'b1); 
register_v #(4) opcode_ID_reg(opcode_ID, opcode, clk, reset, 1'b1); 

register_v #(64) da_ID_reg(da_ID, da, clk, reset, 1'b1); //regfile outputs afer fwd mux
register_v #(64) db_ID_reg(db_ID, db, clk, reset, 1'b1); 
logic [63:0] pc_ID;
logic [31:0] insn_ID;
register_v #(64) pc_ID_reg(pc_ID, pc_IF, clk, reset, 1'b1); 
register_v #(32) insn_ID_reg(insn_ID, inst_ID, clk, reset, 1'b1); 


/////////////////////////////////////////
////EXCECUTE    //  EX  //
/////////////////////////////////////////

//flag registers 
//  flags update based on ADDS,SUBS
logic [3:0] _op1, _op2;
  logic t, nrst, t0, t1, tand, t2, t3, tsub;
  xnor _opx0(_op1[0], opcode_ID[3], 0);
  xnor _opx1(_op1[1], opcode_ID[2], 0);
  xnor _opx2(_op1[2], opcode_ID[1], 1);
  xnor _opx3(_op1[3], opcode_ID[0], 0);
  and _opx4(t0, _op1[0], _op1[1]);
  and _opx5(t1, _op1[2], _op1[3]);
  and _opx6(tand, t0,t1);

  xnor _opy0(_op2[0], opcode_ID[3], 1);
  xnor _opy1(_op2[1], opcode_ID[2], 0);
  xnor _opy2(_op2[2], opcode_ID[1], 1);
  xnor _opy3(_op2[3], opcode_ID[0], 1);
  and _opy4(t2, _op2[0], _op2[1]);
  and _opy5(t3, _op2[2], _op2[3]);
  and _opy6(tsub, t2,t3);

  or  _opz0(_t, tand,tsub);
  and _opz1(t, _t, nrst);
  not _opq0(nrst, reset);


  register_v #(4) flags ({z,o,c,n}, {_z,_o,_c,_n}, clk, reset, t);
 



//alu instance 
logic [63:0] _Db, shift_out, mul_out, mult_high;
mux4 alu_b (_Db, db_ID, imm9_ID, imm12_ID, imm12_ID, ALUSrc_ID);
mult mul(da_ID, db_ID, 1'b1, mul_out, mult_high);
shifter s(da_ID, ~opcode_ID[0], shamt_ID, shift_out); //~opcode[0]
alu xu(da_ID, _Db, ALUOp_ID, alu_out, _n, _z, _o, _c);

mux4 alu_fwd(alu_o, alu_out, '0, mul_out, shift_out, MemToReg_ID);

// intermediate EX registers
//register_v (#1) Reg2Loc_EX_reg(Reg2Loc_IF, Reg2Loc, clk, reset, 1'b1);  // control signals 
register_v #(2) MemToReg_EX_reg(MemToReg_EX, MemToReg_ID, clk, reset, 1'b1);
register_v #(1) RegWrite_EX_reg(RegWrite_EX, RegWrite_ID, clk, reset, 1'b1);
register_v #(1) MemWrite_EX_reg(MemWrite_EX, MemWrite_ID, clk, reset, 1'b1);
register_v #(1) BrTaken_EX_reg(BrTaken_EX, BrTaken_ID, clk, reset, 1'b1);

register_v #(5) Rd_EX_reg(Rd_EX, Rd_ID, clk, reset, 1'b1); 

logic [63:0] mul_out_EX, shift_out_EX, db_EX;
register_v #(64) alu_out_EX_reg(alu_out_EX, alu_out, clk, reset, 1'b1); 
register_v #(64) alu_o_EX_reg(alu_o_EX, alu_o, clk, reset, 1'b1); 
register_v #(64) mul_out_EX_reg(mul_out_EX, mul_out, clk, reset, 1'b1); 
register_v #(64) shift_out_EX_reg(shift_out_EX, shift_out, clk, reset, 1'b1); 

register_v #(64) db_EX_reg(db_EX, db_ID, clk, reset, 1'b1); 

//For commit trace
logic [4:0] Rn_EX, Rm_EX, Rn_MEM, Rm_MEM;
register_v #(5) Rn_EX_reg(Rn_EX, Rn_ID, clk, reset, 1'b1); 
register_v #(5) Rm_EX_reg(Rm_EX, Rm_ID, clk, reset, 1'b1); 
logic [63:0] pc_EX;
logic [31:0] insn_EX;
register_v #(64) pc_EX_reg(pc_EX, pc_ID, clk, reset, 1'b1); 
register_v #(32) insn_EX_reg(insn_EX, insn_ID, clk, reset, 1'b1); 


///////////////////////////////////////
//// MEMORY   //   MEM   // 
//////////////////////////////////////

// data mem instance 
/*module datamem (
	input logic		[63:0]	address,
	input logic					write_enable,
	input logic					read_enable,
	input logic		[63:0]	write_data,
	input logic					clk,
	input logic		[3:0]		xfer_size,
	output logic	[63:0]	read_data
	);*/
logic [63:0] din;
datamem dm(alu_out_EX, MemWrite_EX, 1'b1, db_EX, clk, 4'd8, din); //din out of dm in to regfile

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
logic [4:0] Rn_WB, Rm_WB;
logic BrTaken_WB;
register_v #(5) Rn_WB_reg(Rn_WB, Rn_MEM, clk, reset, 1'b1); 
register_v #(5) Rm_WB_reg(Rm_WB, Rm_MEM, clk, reset, 1'b1); 
register_v #(1) BrTaken_WB_reg(BrTaken_WB, BrTaken_MEM, clk, reset, 1'b1); 
logic [63:0] pc_WB;
logic [31:0] insn_WB;
register_v #(64) pc_WB_reg(pc_WB, pc_WB, clk, reset, 1'b1); 
register_v #(32) insn_WB_reg(insn_WB, insn_WB, clk, reset, 1'b1); 

initial $monitor(
  "Fetch: %s\n", reset ? "In reset!!!" : "",
  "\tPC %x Insn %x\n", pc_IF, inst_ID,
  "Commit:\n",
  "\tPC %x | Insn %x\n", pc_WB, insn_WB,
  "\trs1 %x @%x | rs2 %x @x\n", '0, Rn_WB, '0, Rm_WB,
  "\trd %x @%x | b %b\n\n", Dw, Rd, BrTaken_WB
);

endmodule
