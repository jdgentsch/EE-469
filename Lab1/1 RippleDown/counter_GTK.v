// A four-stage ripple down counter with active low reset- Counter 1 of EE 469 Lab 1
// Note that this upper level module is intended for use with GTKwave on the PC.

// Written by Jack Gentsch, Jacky Wang, and Chinh Bui
// 4/3/2016 instructed by Professor Peckol

//Create a connection between the testbench and converted schematic .bdf file
`include "rippleDownCounter.v"

module counter_GTK;
	// connect the two modules
	wire clk, rst;
	wire [3:0] out;

	// Declare an instance of the ripple counter module
	rippleDownCounter myRippleCounter(out[3:0], clk, rst);

	// Declare an instance of the testbench module
	Tester myTester (clk, rst, out[3:0]);

	// File specifications for gtkwave
	initial
		begin
			$dumpfile("rippleCount.vcd");
			$dumpvars(1,myRippleCounter);
		end
endmodule

//The testbench module used to apply inputs to our counter
module Tester (clk, rst, out);

	input [3:0] out;
	output reg clk, rst;
	parameter stimDelay = 20;

	initial // Creates output in CMD
	begin
		$display("\t\t Reset \t Out[3] Out[2] Out[1] Out[0] \t Time ");
		$monitor("\t\t %b\t %b \t %b \t %b", rst, out[3], out[2], out[1], out[0], $time );
	end

	initial // Stimulus, manually cycles clock
		begin
			clk = 1'b1; rst = 1'b0;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk; rst = 1'b1;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#stimDelay clk = ~clk;
			#(2*stimDelay); // needed to see END of simulation
			$finish; // finish simulation
		end
endmodule
