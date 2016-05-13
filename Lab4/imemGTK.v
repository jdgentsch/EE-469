//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 4: GTKwave for instruction memory
//EE 469 with James Peckol 5/7/16

`include "imem.v"

module imemGTK;
	wire [31:0] dataOut;
	wire [6:0] adrx;

	imem myimem (dataOut, adrx);
	Tester aTester (adrx, dataOut);

	// file for gtkwave
	initial
		begin
			$dumpfile("imemGTK.vcd");
			$dumpvars(1, myimem);
		end
endmodule


module Tester(adrx, dataOut);
	input [31:0] dataOut;
	output reg [6:0] adrx;

	parameter stimDelay = 20;

	initial // Stimulus
	begin
		#stimDelay; adrx = 7'h0;
		#stimDelay;	adrx = 7'h1;
		#stimDelay;	adrx = 7'h2;
		#stimDelay;	adrx = 7'h3;
		#stimDelay; adrx = 7'h4;
		#stimDelay; adrx = 7'h5;
		#stimDelay; adrx = 7'h6;
		#stimDelay; adrx = 7'h7;
		#stimDelay; adrx = 7'h8;
		#stimDelay; adrx = 7'h9;
		#stimDelay; adrx = 7'hA;
		#stimDelay; adrx = 7'hB;
		#stimDelay; adrx = 7'hC;
		#stimDelay; adrx = 7'hD;
		#stimDelay; adrx = 7'hE;
		#stimDelay; adrx = 7'hF;
		$finish;
	end
endmodule
