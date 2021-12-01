// structure with 32 64bit registers - actually 31 registers, Register 31 to be tied 0
module register_bank_32  (data_out, data_in, clk, reset, write_en); 
 output logic [31:0][63:0] data_out; 
 input logic [31:0][63:0] data_in;  // 31 registers (0 to 30)
 input logic clk; 
 input logic reset;
 input logic [31:0] write_en;
 assign data_out[31] = '0;
 
 genvar i; 
 generate 
  for(i=0; i<31; i++) begin : eachReg
   register64 r(data_out[i], data_in[i], clk, reset, write_en[i]); 
  end 
 endgenerate 
 // int k;
 // always @(posedge clk)
 //   for(k=0; k<8; k++)
 //     $display("Reg[%d]=%d\n",k, eachReg[k].r.data_out);
endmodule 

module register_bank_32_testbench(); 
 logic [31:0][63:0] data_out;
 logic [31:0][63:0] data_in;
 logic clk,reset; 
 logic [31:0] write_en;
 
register_bank_32 dut (data_out, data_in, clk, reset, write_en); 

initial begin
clk=0;
reset=1;
forever #5 clk=~clk;
end
 
 initial begin 
 write_en= 32'h08;
 data_in[0] = 5000; 
 data_in[3]= 0101;
 data_in[4]= 1010;
 data_in[30]= 600;
 #10 reset=0;
#100;
$stop;
 
 end 
endmodule 
