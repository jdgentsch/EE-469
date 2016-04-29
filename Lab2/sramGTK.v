//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 2: SRAM test vector for iVerilog
//EE 469 with James Peckol 4/15/16
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

	// declare an instance of the testbench
	Tester aTester (swBench, keyBench, clockBench, ledrBench);

	// file for gtkwave
	initial
		begin
			$dumpfile("sramGTK.vcd");
			$dumpvars(1, mySramDemo);
		end
		
endmodule

module Tester (swTest, keyTest, clockTest, ledrTest);

	output reg [9:0] swTest;
	output reg [3:0] keyTest;
	output reg clockTest;
	input [9:0] ledrTest;

	parameter stimDelay = 150;

	always begin
		#(stimDelay/10) clockTest= ~clockTest;
	end

	initial // Stimulus
	begin

			clockTest = 0;
			#stimDelay swTest[9] = 1;
			#stimDelay swTest[9] = 0;
			#stimDelay keyTest[1] = 0;
			#stimDelay keyTest[1] = 1;
			#(60*stimDelay); 
			#stimDelay keyTest[0] = 0;
			#stimDelay keyTest[0] = 1;
			#(60*stimDelay); 			// needed to see END of simulation
			$finish; 					// finish simulation
	end
endmodule
