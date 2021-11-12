module idecode(
  input logic [31:0] inst,
  output logic [3:0] opcode,
  output logic [11:0] imm12,
  output logic [25:0] imm26,
  output logic [18:0] imm19,
  output logic [8:0] imm9,
  output logic [5:0] shamt,
  output logic w,
  output logic [4:0] rm, rn, rd,
  output logic [2:0] aluc
);
  typedef enum logic[3:0] 
    { ADDI, ADDS, BLT, B, CBZ, LDUR, LSL, LSR, MUL, STUR, SUBS , INV } ops;

  //From the instruction encodings
  ze ze(inst[21:10], imm12);
  se se0(inst[25:0], imm26);
  se se1( inst[23:5], imm19);
  se se2( inst[20:12], imm9);
  assign shamt = inst[15:10];
  assign rm = inst[20:16];
  assign rn = inst[9:5];
  assign rd = inst[4:0];

  //ALU operation select (CTRL) //SUB=3'b011; ADD=3'b010
  assign aluc = opcode == SUBS ? 3'b011 : 3'b010;

  //opcode recognition
  always_comb
    if(inst[31:26] == 6'h5)
      opcode = B;
    else if(inst[31:24] == 8'hb4) 
      opcode = CBZ;
    else if(inst[31:24] == 8'h54 && rd == 5'hb)
      opcode = BLT;
    else if(inst[31:22] == 10'h244)
      opcode = ADDI;
    else
      case(inst[31:21]) //begin
       // 11'h69a : assign opcode = LSR;
		  11'h69a : opcode = LSR;
        11'h69b : opcode = LSL;
        11'h758 : opcode = SUBS;
        11'h7c0 : opcode = STUR;
        11'h7c2 : opcode = LDUR;
        11'h558 : opcode = ADDS;
        11'h4d8 : 
          if(shamt == 5'h1f)
            opcode = MUL;
          else $error("MUL instruction without appropriate 'shamt'!");
        default : $error("Invalid instruction, fix me! %x", inst);
      endcase
 // end
//ALU operation select
  //assign aluc = opcode == SUBS ? SUB : ADD;
 // assign aluc = opcode == SUBS ? 3'b011 : 3'b010;
  endmodule
