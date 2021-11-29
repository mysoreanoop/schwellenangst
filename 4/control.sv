// Generates all control signals
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

module control(opcode, Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite,ALUOp);

input logic [3:0] opcode;
 output logic Reg2Loc, RegWrite,MemWrite;
 output logic [1:0] MemToReg, ALUSrc;
 output logic [2:0] ALUOp;
  
  assign MemToReg = opcode == `LDUR ? 2'd1
    : opcode == `MUL ? 2'd2
      : opcode == `LSL || opcode == `LSR ? 2'd3
        : 2'd0;
  assign Reg2Loc = ~(opcode == `STUR || opcode == `CBZ);
  assign RegWrite = ~(opcode == `B || opcode == `BLT|| opcode == `CBZ|| opcode == `STUR);
  assign MemWrite = opcode == `STUR;
  assign ALUOp = opcode == `SUBS ? 3'd3 : (opcode == `CBZ ? 3'd0 : 3'd2);
  assign ALUSrc = {opcode == `ADDI , opcode == `LDUR || opcode == `STUR};
  
 endmodule 
