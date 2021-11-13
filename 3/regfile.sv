///REGFILE - 64bit 32 regs 
//implement write data bypass on read-write addr conflict
module regfile(ReadData1, ReadData2, WriteData, ReadRegister1, ReadRegister2, WriteRegister, RegWrite, clk);
 input logic clk, RegWrite;
 input logic [4:0] ReadRegister1, ReadRegister2, WriteRegister;
 input logic [63:0] WriteData;
 output logic [63:0] ReadData2, ReadData1;
 reg rst;
 initial rst = 0;
 
 logic [31:0][63:0] ro, ri; //register bank out, in
 logic [31:0] we;

 mux64 m0(ReadData1, ro, ReadRegister1);
 mux64 m1(ReadData2, ro, ReadRegister2);
 decoder5_32 d(WriteRegister, we, RegWrite);
 register_bank_32 r(.data_out(ro), .data_in(ri), .clk(clk), .reset(rst), .write_en(we));

 genvar i;
 for(i=0; i<32; i++) assign ri[i] = WriteData;
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
   assert((_rf[ReadRegister1] === ReadData2) && (_rf[ReadRegister2] === ReadData1)) $display("Jesus is real!"); //AM: Turns out === matches X's as well; == doesn't!!
    else $error("Read %6x %6x; doesn't match local registry's %6x %6x!!", _rf[ReadRegister1], _rf[ReadRegister2], ReadData2, ReadData1);
  end
  end
 end
 initial $monitor("t=%6x | ReadRegister1=%d | ReadRegister2=%d | WriteRegister=%d \n",clk, ReadRegister1, ReadRegister2, WriteRegister,
           "%s | ReadData2=%6x | ReadData1=%6x | WriteData=%6x \n\n", (RegWrite)? "w" : "r", ReadData2, ReadData1, WriteData);
endmodule 
