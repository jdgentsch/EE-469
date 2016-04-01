`include "syncUp.v"

module syncUpGTK;

	// connect the two modules
	wire [3:0] qBench;
	wire clkBench, rstBench;

	// declare an instance of the syncUp module
	syncUp mySyncUp (qBench, clkBench, rstBench);

	// declare an instance of the testIt module
	Tester aTester (clkBench, rstBench, qBench);

	// file for gtkwave
	initial
		begin
			$dumpfile("syncUp.vcd");
			$dumpvars(1, mySyncUp);
		end
		
endmodule

module Tester (clkTest, rstTest, qTest);

	output reg rstTest, clkTest;
	input [3:0] qTest;

	parameter stimDelay = 20;

	initial // Response
	begin
		$display("\t\t rstTest clkTest qTest ");
		$monitor("\t\t %b\t %b \t %b", rstTest, clkTest, qTest );
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