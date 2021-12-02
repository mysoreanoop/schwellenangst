///REGFILE - 64bit 32 regs 
//implement write data bypass on read-write addr conflict
`timescale 1ps/1ps
module regfile #(parameter delay = 50)
    (ReadData1, ReadData2, WriteData,
    ReadRegister1, ReadRegister2, WriteRegister,
    RegWrite, clk);
  input logic clk, RegWrite;
  input logic [4:0] ReadRegister1, ReadRegister2, WriteRegister;
  input logic [63:0] WriteData;
  output logic [63:0] ReadData2, ReadData1;


  logic [31:0][63:0] ro, ri; // Wired into and out of register bank below
  logic [31:0] we; // Individualized wires to enable each of the Registers exclusively

  mux64  m0(.out(ReadData1), .in(ro), .read_reg(ReadRegister1));
  mux64  m1(.out(ReadData2), .in(ro), .read_reg(ReadRegister2));
  //assign ReadData1 = ro[ReadRegister1]; //This works, above doesn't
  //assign ReadData2 = ro[ReadRegister2];

  decoder5_32  d(WriteRegister, we, RegWrite);

  // The Compendium of Registers each fed from WriteData
  logic nclk;
  not n(nclk, clk);
  register_bank_32 r(.data_out(ro), .data_in(ri), .clk(nclk), .reset(1'b0), .write_en(we));
  genvar i;
    for(i=0; i<32; i++) assign ri[i] = WriteData;

  always @(posedge clk)
    $display("RF:\n %d \n %d \n %d \n %d \n %d \n %d \n %d \n %d \n %d \n %d \nRFEND\n", 
    ro[0],
    ro[1],
    ro[2],
    ro[3],
    ro[4],
    ro[5],
    ro[6],
    ro[7],
    ro[8],
    ro[9]);
  always @(posedge clk) 
    if(RegWrite) 
      $display("WRITING: %d to %d", WriteData, WriteRegister);
endmodule

//module regfile #(parameter delay = 50) (ReadData1, ReadData2, WriteData, ReadRegister1, ReadRegister2, WriteRegister, RegWrite, clk);
//  input logic clk, RegWrite;
//  input logic [4:0] ReadRegister1, ReadRegister2, WriteRegister;
//  input logic [63:0] WriteData;
//  output logic [63:0] ReadData2, ReadData1;
//  
//  logic [31:0][63:0] ro, ri; // Wired into and out of register bank below
//  //reg [0:31][63:0] mem;
//  //assign ReadData1 = mem[ReadRegister1];
//  //assign ReadData2 = mem[ReadRegister2];
//  mux64  m0(.out(ReadData1), .in(ro), .read_reg(ReadRegister1));
//  mux64  m1(.out(ReadData2), .in(ro), .read_reg(ReadRegister2));
//  decoder5_32  d(WriteRegister, we, RegWrite);
//  register_bank_32 r(.data_out(ro), .data_in(ri), .clk(nclk), .reset(rst), .write_en(we));
//  always@(negedge clk) begin
//    //mem[31] <= '0;
//    ri[31] <= '0;
//    if(RegWrite)
//      if(WriteRegister != '1) begin
//        //mem[WriteRegister] <= WriteData;A
//        ri[WriteRegister] <= WriteData;
//        
//      end
//  end
//
//  always @(negedge clk)
//    $display("RF Inside:%x %x %x %x %x %x %b\n", ReadData1, ReadData2, WriteData, ReadRegister1, ReadRegister2, WriteRegister, RegWrite);
//endmodule 
 
module rf_tb(); 
 logic clk, rst;
 reg RegWrite;
 reg [31:0][63:0] _rf;
 reg [4:0] ReadRegister1;
 reg [4:0] ReadRegister2;
 reg [4:0] WriteRegister;
 reg [63:0] WriteData;
 logic [63:0] ReadData2, ReadData1;
 reg [8:0] inc;

 regfile dut(ReadData1, ReadData2, WriteData, ReadRegister1, ReadRegister2, WriteRegister, RegWrite, clk);
 
 initial begin
 clk=0;
 rst=1;
 #500 rst = 0;
 end
 initial
  forever #100 clk = ~clk;
 integer i;
 always_ff @(posedge clk) begin
  if(rst) begin
    inc <= '0;
    _rf[31] <= '0;
    for(i=0; i<31; i++) _rf[i] <= 'x;
  end
  else begin
    inc <= inc + 9'b1;
    _rf[31] <= '0;
    ReadRegister1 <= inc+9'd5;
    ReadRegister2 <= inc+9'd6;
    WriteRegister <= inc;
    WriteData <= $urandom%999;
    RegWrite <= 1'b1;
    if(RegWrite && (WriteRegister != '1)) 
      _rf[WriteRegister] <= WriteData;
    else begin
     assert((_rf[ReadRegister1] === ReadData1) && (_rf[ReadRegister2] === ReadData2)) $display("All is well"); //AM: Turns out === matches X's as well; == doesn't!!
      else $error("Read %6x %6x from local reg; doesn't match DUT's %6x %6x @%x %x!!", _rf[ReadRegister1], _rf[ReadRegister2], ReadData1, ReadData2, ReadRegister1, ReadRegister2);
    end
  end
 end
 initial $monitor("t=%6x | ReadRegister1=%x | ReadRegister2=%x | WriteRegister=%x \n",clk, ReadRegister1, ReadRegister2, WriteRegister,
           "%s | ReadData2=%6x | ReadData1=%6x | WriteData=%6x \n\n", (RegWrite)? "w" : "r", ReadData2, ReadData1, WriteData);
endmodule 
