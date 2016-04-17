`include "register.v"
`include "mux32.v"

module regGTK;
	wire [31:0] rdData0, rdData1;
	reg [4:0] rdAdrx0, rdAdrx1, writeAdrx;
	reg [31:0] writeData;
	reg clk, writeEn;
	
	reg [31:0] writeSel, rdSel0, rdSel1;
	wire [31:0] regResult [0:31];
	wire [31:0] writeEnAndSel;	

	// connect the two modules
	wire [31:0] rdData0, rdData1, writeData;
	wire [4:0] rdAdrx0, rdAdrx1, writeAdrx;
	wire clk, writeEn;
	
	// declare an instance of the sramTop module
	registerFile myRegFile (rdData0, rdData1, rdAdrx0, rdAdrx1, writeAdrx, writeData, clk, writeEn);

	// declare an instance of the testIt module
	Tester myTestbench (rdAdrx0, rdAdrx1, writeAdrx, writeData, clk, writeEn);

	// file for gtkwave
	initial
		begin
			$dumpfile("regfileGTK.vcd");
			$dumpvars(1, myRegFile);
		end
		
endmodule

module Tester (rdAdrx0, rdAdrx1, writeAdrx, writeData, clk, writeEn);

	output reg [4:0] rdAdrx0, rdAdrx1, writeAdrx;
	output reg [31:0] writeData;
	output reg clk, writeEn;
	
	parameter stimDelay = 150;

	// initial // Response
	// begin
	// 	$display("\t\t rstTest clkTest outTest ");
	// 	$monitor("\t\t %b\t %b \t %b", rstTest, clkTest, outTest );
	// end

	always begin
		#(stimDelay/10) clk= ~clk;
	end

	integer i;
	
	initial // Stimulus
	begin
			clk = 0;
			//rdAdrx0, rdAdrx1, writeAdrx, writeData, clk, writeEn
			writeEn = 1;
			writeData = 32'b0;
			writeAdrx = 5'b0;
			rdAdrx0 = 5'b0;
			rdAdrx1 = 5'b10000;
			//Write data
			for (i = 0; i < 32; i = i + 1) begin
				#stimDelay 
				writeAdrx = writeAdrx + 5'b1; 
				writeData = writeData + 32'b1;
			end
			writeEn = 1'b0;
			//Read data
			for (i = 0; i < 16; i = i + 1) begin
				#stimDelay 
				rdAdrx1 = rdAdrx1 + 5'b1; 
				rdAdrx0 = rdAdrx0 + 5'b1; 
			end
			#(60*stimDelay); 			// needed to see END of simulation
			$finish; 					// finish simulation
		end
endmodule
