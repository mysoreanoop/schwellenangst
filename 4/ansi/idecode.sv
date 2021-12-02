`timescale 1ps/1ps

`define ADDI 1
`define ADDS 2
`define BLT 3
`define B 4
`define CBZ 5
`define LDUR 6
`define LSL 7
`define LSR 8
`define MUL 9
`define STUR 10
`define SUBS 11
`define INV 12

module idecode(
input logic [31:0] inst,
output logic [3:0] opcode,
output logic [63:0] _imm12,
output logic [63:0] _imm26,
output logic [63:0] _imm19,
output logic [63:0] _imm9,
output logic [5:0] shamt,
output logic [4:0] rm, rn, rd
);

//From the instruction encodings
 logic [11:0] imm12;
 logic [25:0] imm26;
 logic [18:0] imm19;
 logic [8:0] imm9;
assign imm12 = inst[21:10];
ze addi (_imm12, imm12);
assign imm26 = inst[25:0] ;
se #(26) se2 (_imm26,imm26);
assign imm19 = inst[23:5] ;
se #(19) se1 (_imm19,imm19);

assign imm9 = inst[20:12];
se #(9) se9 (_imm9, imm9);
assign shamt = inst[15:10];
assign rm = inst[20:16];
assign rn = inst[9:5];
assign rd = inst[4:0];

//opcode recognition
always_comb
if(inst[31:26] == 6'h5)
opcode = `B;
else if(inst[31:24] == 8'hb4)
opcode = `CBZ;
else if(inst[31:24] == 8'h54 && rd == 5'hb)
opcode = `BLT;
else if(inst[31:22] == 10'h244)
opcode = `ADDI;
else
case(inst[31:21]) //begin
// 11'h69a : assign opcode = LSR;
11'h69a : opcode = `LSR;
11'h69b : opcode = `LSL;
11'h758 : opcode = `SUBS;
11'h7c0 : opcode = `STUR;
11'h7c2 : opcode = `LDUR;
11'h558 : opcode = `ADDS;
11'h4d8 :
if(shamt == 5'h1f)
opcode = `MUL;
else begin
opcode = `INV;
$error("MUL instruction without appropriate 'shamt'!");
end
default : begin
opcode = `INV;
end
endcase
endmodule