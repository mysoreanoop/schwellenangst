// The Holy ARM Register File with Register-31 zero'd out
// Does the smart write data bypass upon reading 
module regfile #(parameter delay = 50) 
		(ReadData1, ReadData2, WriteData, 
		ReadRegister1, ReadRegister2, WriteRegister, 
		RegWrite, clk);
	input logic clk, RegWrite;
	input logic [4:0] ReadRegister1, ReadRegister2, WriteRegister;
	input logic [63:0] WriteData;
	output logic [63:0] ReadData2, ReadData1;
	reg rst;
	initial rst = 0;
	
	logic [31:0][63:0] ro, ri; // Wired into and out of register bank below
	logic [31:0] we; // Individualized wires to enable each of the Registers exclusively

	// The below Muxes each select one 64 bit data bundle from each of the 32 registers independantly
	mux64 #(delay) m0(.out(ReadData1), .in(ro), .read_reg(ReadRegister1));
	mux64 #(delay) m1(.out(ReadData2), .in(ro), .read_reg(ReadRegister2));

	// Enables the Write Enable for one of 32 registers
	decoder5_32 #(delay) d(WriteRegister, we, RegWrite);

	// The Compendium of Registers each fed from WriteData
	register_bank_32 r(.data_out(ro), .data_in(ri), .clk(clk), .reset(rst), .write_en(we));
	genvar i;
		for(i=0; i<32; i++) assign ri[i] = WriteData;
endmodule 
 
module rf_tb(); 
	logic clk, rst;
	reg RegWrite;
	reg [31:0][63:0] _rf; // Local copy to test against
	reg rw;
	reg [4:0] w, r1, r2;
	reg [63:0] d;
	reg [4:0] ReadRegister1;
	reg [4:0] ReadRegister2;
	reg [4:0] WriteRegister;
	reg [63:0] WriteData;
	logic [63:0] ReadData2, ReadData1;

	// Verbose for the curious; will be part of the Makefile if/when we have that
	parameter verbose=1;
	parameter delay=50;
	
	regfile #(delay) dut(ReadData1, ReadData2, d, r1, r2, w, rw, clk);
	
	initial begin
		clk=0;
		rst=1;
		#100 rst = 0;
		forever #100 clk = ~clk;
	end

	integer i;
	always_ff @(posedge clk) begin
		// Conformity for our local RF
		_rf[31] <= '0;
		if(!rst) begin
			// Random inputs -- unsigned
			r1 = $urandom%32;
			r2 = $urandom%32;
			ReadRegister1 <= r1;
			ReadRegister2 <= r2;
			w = $urandom%32;
			WriteRegister <= w;
			d = $urandom%1024;
			WriteData <= d;
			rw <= $urandom%2;
			RegWrite <= rw;
		end

		if(rw) begin
			if(w != 5'b11111) // Conformity and local copy update
			 	_rf[w] <= d;
			$display("Wrote %6x to %6x", d, w);
		end
		else 
			if(!RegWrite) begin // If previously a read was requested, then:
				if(ReadRegister1 == 5'd31) // Conformity
					assert(ReadData1 == '0) $display("Special case: Reading 31 @1 did return 0 :) %6x %6x", ReadRegister1, ReadData1); 
					else $error("Special case: Reading 31 @1 did __NOT__ return 0 %6x %6x", ReadRegister1, ReadData1) ;
				if(ReadRegister2 == 5'd31) // Conformity
					assert(ReadData2 == '0) $display("Special case: Reading 31 @2 did return 0 :) %6x %6x", ReadRegister2, ReadData2); 
					else $error("Special case: Reading 31 @2 did __NOT__ return 0 :) %6x %6x", ReadRegister2, ReadData2) ;

				assert((_rf[ReadRegister1] === ReadData1) && (_rf[ReadRegister2] === ReadData2)) 
					$display("Read %6x %6x; matches %6x %6x at %2x %2x!!", 
				     		ReadData1, ReadData2, _rf[ReadRegister1], _rf[ReadRegister2], 
						ReadRegister1, ReadRegister2);
				else $error("Read %6x %6x; doesn't match local registry's %6x %6x at %2x %2x!!", 
					ReadData1, ReadData2, _rf[ReadRegister1], _rf[ReadRegister2], ReadRegister1, ReadRegister2);
			end
		if(verbose)
			$display("t=%6x | ReadRegister1=%6x | ReadRegister2=%6x | WriteRegister=%6x |",
		      		$time, r1, r2, w,
		         	" %s | ReadData1=%6x | ReadData2=%6x | WriteData=%6x \n\n", 
		      		(rw)? "w" : "r", ReadData1, ReadData2, d);
	end
endmodule 
