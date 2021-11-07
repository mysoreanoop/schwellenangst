//31 64 bit Registers, Register-31 to be tied 0
module register_bank_32 (data_out, data_in, clk, reset, write_en); 
	output logic [31:0][63:0] data_out;
	input logic [30:0][63:0] data_in; // to 31 registers (64 bits each) sans Register-31
	input logic clk, reset; 
	input logic [30:0] write_en; // one per register sans Register-31
	
	initial data_out[31] = '0;

	genvar i; 
	generate 
	for(i=0; i<31; i++) begin : eachReg // 31 instances
		register64 r(data_out[i], data_in[i], clk, reset, write_en[i]); 
	end 
	endgenerate
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
		#100 reset=0;
		forever #5 clk=~clk;
	end
	genvar i; 
	always @(posedge clk) begin
		data_in <= $urandom%128;
		write_en <= 1 << $urandom%31;
	end 
endmodule 
