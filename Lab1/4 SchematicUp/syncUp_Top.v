// Ripple down counter - Counter 4 of EE 371 Lab 1, utilizes the schematic model.
// Note that this file uses Quartus synthesized Verilog, and is intended for
// use in running GTKwave on the PC.

// Written by Jack Gentsch and Jacky Wang
// 10/4/2015 instructed by Professor Peckol

//Create a connection between the testbench and converted schematic .bdf file
//`include "syncSchematic.v"

module syncUp_Top;

	// Connect the two modules
	wire [3:0] qBench;
	wire clkBench, rstBench;

	// Declare an instance of the converted schematic module
	syncSchematic mySyncSchm (.q(qBench), .clk(clkBench), .reset(rstBench));

	// Declare an instance of the tester module
	Tester aTester (clkBench, rstBench, qBench);

	// Generates waveform using iVerilog
	initial
		begin
			$dumpfile("syncSchematic.vcd");
			$dumpvars(1, mySyncSchm);
		end
endmodule

//A test module that acts as our testbench. Required for iVerilog analysis
module Tester (clkTest, rstTest, qTest);

	//Input and output decleration to connect to DUT
	output reg rstTest, clkTest;
	input [3:0] qTest;

	parameter stimDelay = 20;

	initial // Stimulus
	begin
			//Manually changing clock and applying reset
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