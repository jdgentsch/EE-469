// andorTop0.v
`include "andOr0.v"

module andorTop0;
	// connect the two modules
	wire [1:0] X, Y;
	wire [1:0] XandY, XorY;

	// declare an instance of the AND module
	AndOr myAndOr (XandY[1:0], XorY[1:0], X[1:0], Y[1:0]);

	// declare an instance of the testIt module
	Tester aTester (X[1:0], Y[1:0], XandY[1:0], XorY[1:0]);

	// file for gtkwave
	initial
	begin
		$dumpfile("andor0.vcd");
		$dumpvars(1,myAndOr);
	end
endmodule 

// andorTop0.v cont.
module Tester (xOut, yOut, XandYin, XorYin);

	input [1:0] XandYin, XorYin;
	output [1:0] xOut, yOut;
	reg [1:0] xOut, yOut;
	parameter stimDelay = 20;

	initial // Response
	begin
		$display("\t\t xOut yOut \t XandYin XorYin \t Time ");
		$monitor("\t\t %b\t %b \t %b \t %b", xOut, yOut, XandYin,
					XorYin, $time );
	end

	initial // Stimulus
	begin
		xOut = 'b00; yOut = 'b10;
		#stimDelay xOut = 'b10;
		#stimDelay yOut = 'b01;
		#stimDelay xOut = 'b11;

		#(2*stimDelay); // needed to see END of simulation
		$finish; // finish simulation
	end
endmodule 