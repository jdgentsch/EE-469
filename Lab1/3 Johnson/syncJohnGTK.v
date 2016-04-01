`include "syncJohn.v"

module syncJohnGTK;

	// connect the two modules
	wire [3:0] outBench;
	wire clkBench, rstBench;

	// declare an instance of the syncJohn module
	syncJohn mySyncJohn (outBench, clkBench, rstBench);

	// declare an instance of the testIt module
	Tester aTester (rstBench, clkBench, outBench);

	// file for gtkwave
	initial
		begin
			$dumpfile("syncJohn.vcd");
			$dumpvars(1, mySyncJohn);
		end
		
endmodule

module Tester (rstTest, clkTest, outTest);

	output reg rstTest, clkTest;
	input [3:0] outTest;

	parameter stimDelay = 20;

	initial // Response
	begin
		$display("\t\t rstTest clkTest outTest ");
		$monitor("\t\t %b\t %b \t %b", rstTest, clkTest, outTest );
	end

	initial // Stimulus
	begin
			clkTest = 0;	rstTest = 0;
			#stimDelay clkTest = ~clkTest; 
			#stimDelay clkTest = ~clkTest; rstTest = 1;
			#stimDelay clkTest = ~clkTest;
			#stimDelay clkTest = ~clkTest;
			#stimDelay clkTest = ~clkTest;
			#stimDelay clkTest = ~clkTest;
			#stimDelay clkTest = ~clkTest;
			#stimDelay clkTest = ~clkTest;
			#stimDelay clkTest = ~clkTest;
			#stimDelay clkTest = ~clkTest;
			#stimDelay clkTest = ~clkTest;
			#stimDelay clkTest = ~clkTest;
			#stimDelay clkTest = ~clkTest;
			#stimDelay clkTest = ~clkTest;
			#stimDelay clkTest = ~clkTest;
			#stimDelay clkTest = ~clkTest;
			#stimDelay clkTest = ~clkTest;
			#stimDelay clkTest = ~clkTest;
			#stimDelay clkTest = ~clkTest;
			#stimDelay clkTest = ~clkTest;
			#stimDelay clkTest = ~clkTest;
			#stimDelay clkTest = ~clkTest;
			#stimDelay clkTest = ~clkTest;
			#(2*stimDelay); 			// needed to see END of simulation
			$finish; 					// finish simulation
		end
endmodule
