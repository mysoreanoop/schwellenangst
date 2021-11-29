// accelerated branch module 
// goes in REG DECODE stage
// checks CBZ using Db of regfile 
//calculates target

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
`define INV  12

module accelerated_branch(pc_br,BrTaken, pc_out, db,n,o,opcode,imm19,imm26);

output logic [63:0] pc_br;
output logic BrTaken;

input logic n,o;  // negative and overflow flags from prev cycle (out of regs)
input logic [63:0] db;// take db wire after forwarding muxes
input logic [63:0] pc_out;
input logic [3:0] opcode;
input logic [18:0] imm19;
input logic [25:0] imm26;

logic UncondBr;
//check condition for B.LT

parameter delay=50;


// check zero from forwarded / regfile o/p- Db value 
logic [31:0] tx; //These variables are for zero flag calculation tree of or gates
	logic [15:0] ty;
	logic [7:0] tz;
	logic [3:0] tq;
	logic [1:0] tr;
	logic zero;
genvar i;
	generate     
				//calculation of zero flag using a tree of or gates (instead of an or cascade)
		for(i=0; i<32; i++)
			or #delay ax0(tx[i], db[2*i], db[2*i+1]);
		for(i=0; i<16; i++)
			or #delay ax1(ty[i], tx[2*i], tx[2*i+1]);	
		for(i=0; i<8; i++)
			or #delay ax2(tz[i], ty[2*i], ty[2*i+1]);	
		for(i=0; i<4; i++)
			or #delay ax3(tq[i], tz[2*i], tz[2*i+1]);	
		for(i=0; i<2; i++)
			or #delay ax4(tr[i], tq[2*i], tq[2*i+1]);	
		nor #delay ax5 (zero, tr[0], tr[1]); // nor gate at the end to give high when inputs are 0
	endgenerate

	
assign BrTaken = (opcode == `B || (opcode == `BLT) &&  (n ^ o) || (opcode == `CBZ) && zero);
assign UncondBr = ~((opcode == `BLT) && (n ^ o) || (opcode == `CBZ) && zero);




 //adder for target PC computation
  logic [63:0] ls_in, ax, o0, o1;
  logic [63:0] _imm19, _imm26;
  se #(19) se1 (_imm19,imm19);
  se #(26) se2 (_imm26,imm26);
  mux2 m_pc(ls_in, _imm19, _imm26, UncondBr);
  LS_2 ls(ax, ls_in); // left shift 2 (mul4)
                                 //add a4(o0, pc_reg, 64'h4); //pc+4 do this in IF stage
  add a_br(pc_br, pc_out, ax); // pc+ branch addr


endmodule 

// implement delay slot 
//mux pc_out and pc+4 
// depends on BrTaken of 2 cycles before
// store BrTaken till RF register - make sure to reset in beginning of proc.
