`include "sramDemo.v"
`include "sram.v"

module sramGTK;

	// connect the two modules
	wire [9:0] ledrBench;
	wire clockBench;
	wire [9:0] swBench;
	wire [3:0] keyBench;

	// declare an instance of the sramTop module
	sramDemo mySramDemo (ledrBench, swBench, keyBench, clockBench);

	// declare an instance of the testIt module
	Tester aTester (swBench, keyBench, clockBench, ledrBench);

	// file for gtkwave
	initial
		begin
			$dumpfile("sramDemo.vcd");
			$dumpvars(1, mySramDemo);
		end
		
endmodule

module Tester (swTest, keyTest, clockTest, ledrTest);

	output reg [9:0] swTest;
	output reg [3:0] keyTest;
	output reg clockTest;
	input [9:0] ledrTest;

	parameter stimDelay = 150;

	// initial // Response
	// begin
	// 	$display("\t\t rstTest clkTest outTest ");
	// 	$monitor("\t\t %b\t %b \t %b", rstTest, clkTest, outTest );
	// end

	always begin
		#(stimDelay/10) clockTest= ~clockTest;
	end

	initial // Stimulus
	begin

			clockTest = 0;
			#stimDelay swTest[9] = 1;
			#stimDelay swTest[9] = 0;
			#stimDelay keyTest[1] = 1;
			#stimDelay keyTest[1] = 0;
			#(60*stimDelay); 
			#stimDelay keyTest[0] = 1;
			#stimDelay keyTest[0] = 0;
			#(60*stimDelay); 			// needed to see END of simulation
			$finish; 					// finish simulation
		end
endmodule
