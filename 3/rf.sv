//TODO
//implement write data bypass on read-write addr conflict
module regfile(clk, rst, ra0, ra1, wa, wd, rd0, rd1, rw); 
 input logic clk, rst, rw;
 input logic [4:0] ra0, ra1, wa;
 input logic [63:0] wd;
 output logic [63:0] rd0, rd1;
 
 logic [31:0][63:0] ro, ri; //register bank out, in
 logic [31:0] we;

 mux64 m0(rd0, ro, ra0);
 mux64 m1(rd1, ro, ra1);
 decoder5_32 d(wa, we, rw);
 register_bank_32 r(.data_out(ro), .data_in(ri), .clk(clk), .reset(rst), .write_en(we));
 genvar i;
 for(i=0; i<32; i++) assign ri[i] = wd;
endmodule 
 
module rf_tb(); 
 logic clk, rst;
 reg rw;
 reg [31:0][63:0] _rf;
 reg [4:0] ra0;
 reg [4:0] ra1;
 reg [4:0] wa;
 reg [63:0] wd;
 logic [63:0] rd0, rd1;

 regfile dut(clk, rst, ra0, ra1, wa, wd, rd0, rd1, rw);
 
 initial begin
 clk=0;
 rst=1;
 #100 rst = 0;
 forever #100 clk = ~clk;
 end
 integer i;
 always_ff @(posedge clk) begin
  if(~rst) begin
  ra0 <= $urandom%32; 
  ra1 <= $urandom%32; 
  wa <= $urandom%32; 
  wd <= $urandom%999;
  rw <= $urandom%2;
  if(rst) begin
    for(i=0; i<32; i++) _rf[i] <= 0;
  end
  if(rw) _rf[wa] <= wd;
  else begin
   assert((_rf[ra0] === rd0) && (_rf[ra1] === rd1)) $display("Jesus is real!"); //AM: Turns out === matches X's as well; == doesn't!!
    else $error("Read %6x %6x; doesn't match local registry's %6x %6x!!", _rf[ra0], _rf[ra1], rd0, rd1);
  end
  end
 end
 initial $monitor("t=%6x | ra0=%d | ra1=%d | wa=%d \n",clk, ra0, ra1, wa,
           "%s | rd0=%6x | rd1=%6x | wd=%6x \n\n", (rw)? "w" : "r", rd0, rd1, wd);
endmodule 
