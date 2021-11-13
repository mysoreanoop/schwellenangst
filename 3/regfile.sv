///REGFILE - 64bit 32 regs 
//implement write data bypass on read-write addr conflict
module regfile(ReadData1, ReadData2, WriteData, ReadRegister1, ReadRegister2, WriteRegister, RegWrite, clk);
 input logic clk, RegWrite;
 input logic [4:0] ReadRegister1, ReadRegister2, WriteRegister;
 input logic [63:0] WriteData;
 output logic [63:0] ReadData2, ReadData1;

 reg [0:31][63:0] mem;
 assign ReadData1 = ReadRegister1 != '1 ? mem[ReadRegister1] : '0;
 assign ReadData2 = ReadRegister2 != '1 ? mem[ReadRegister2] : '0;
 always@(posedge clk) begin
  mem[31] <= '0;
  //if(ReadRegister1 == '1) 
  //  ReadData1 <= '0;
  //else ReadData1 <= mem[ReadRegister1];

  //if(ReadRegister2 == '1)
  //  ReadData2 <= '0;
  //else ReadData2 <= mem[ReadRegister2];
 end
 always@(posedge clk) begin
  if(RegWrite)
    if(WriteRegister != '1)
      mem[WriteRegister] <= WriteData;
 end
// reg rst;
// initial rst = 0;
// 
// logic [31:0][63:0] ro, ri; //register bank out, in
// logic [31:0] we;
//
// mux64 m0(ReadData1, ro, ReadRegister1);
// mux64 m1(ReadData2, ro, ReadRegister2);
// decoder5_32 d(WriteRegister, we, RegWrite);
// register_bank_32 r(.data_out(ro), .data_in(ri), .clk(clk), .reset(rst), .write_en(we));
//
// genvar i;
// for(i=0; i<32; i++) assign ri[i] = WriteData;

 always @(negedge clk)
  $strobe("RF Inside:%x %x %x %x %x %x %b\n", ReadData1, ReadData2, WriteData, ReadRegister1, ReadRegister2, WriteRegister, RegWrite);
endmodule 
 
module rf_tb(); 
 logic clk, rst;
 reg RegWrite;
 reg [31:0][63:0] _rf;
 reg [4:0] ReadRegister1;
 reg [4:0] ReadRegister2;
 reg [4:0] WriteRegister;
 reg [63:0] WriteData;
 logic [63:0] ReadData2, ReadData1;

 regfile dut(ReadData1, ReadData2, WriteData, ReadRegister1, ReadRegister2, WriteRegister, RegWrite, clk);
 
 initial begin
 clk=0;
 rst=1;
 #100 rst = 0;
 forever #100 clk = ~clk;
 end
 integer i;
 always_ff @(posedge clk) begin
  if(~rst) begin
  ReadRegister1 <= $urandom%32; 
  ReadRegister2 <= $urandom%32; 
  WriteRegister <= $urandom%32; 
  WriteData <= $urandom%999;
  RegWrite <= $urandom%2;
  if(rst) begin
    for(i=0; i<32; i++) _rf[i] <= 0;
  end
  if(RegWrite) _rf[WriteRegister] <= WriteData;
  else begin
   assert((_rf[ReadRegister1] === ReadData1) && (_rf[ReadRegister2] === ReadData2)) $display("Jesus is real!"); //AM: Turns out === matches X's as well; == doesn't!!
    else $error("Read %6x %6x; doesn't match local registry's %6x %6x!!", _rf[ReadRegister1], _rf[ReadRegister2], ReadData1, ReadData2);
  end
  end
 end
 initial $monitor("t=%6x | ReadRegister1=%d | ReadRegister2=%d | WriteRegister=%d \n",clk, ReadRegister1, ReadRegister2, WriteRegister,
           "%s | ReadData2=%6x | ReadData1=%6x | WriteData=%6x \n\n", (RegWrite)? "w" : "r", ReadData2, ReadData1, WriteData);
endmodule 
