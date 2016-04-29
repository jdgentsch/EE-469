// Jack Gentsch, Jacky Wang, Chinh Bui
// EE 469, Dr. Peckol 4/15/16
// 32-bit CLA GTKwave Test

`include "cla32.v"

module cla32GTK;
	wire [31:0] sum;
	wire Cout, overflow;
	wire [1:0] pGroup, gGroup;
	wire [31:0] inA, inB;
	wire Cin;

	//declare instances of dut and tester modules
	cla32 mycla32 (sum, Cout, overflow, pGroup, gGroup, inA, inB, Cin);
	Tester aTester (inA, inB, Cin, sum, Cout, overflow, pGroup, gGroup);

	// file for gtkwave
	initial
		begin
			$dumpfile("cla32GTK.vcd");
			$dumpvars(1, mycla32);
		end
endmodule


module Tester (inA, inB, Cin, sum, Cout, overflow, pGroup, gGroup);
	output reg [31:0] inA, inB;
	output reg Cin;
	input [31:0] sum;
	input Cout, overflow;
	input [1:0] pGroup, gGroup;

	parameter stimDelay = 20;

	initial // Stimulus
		begin
				#stimDelay inA = 32'h76543210; inB = 32'h87654321; Cin = 1'b0; // should yield FDB97531
				#stimDelay
				#stimDelay
				#stimDelay
				#stimDelay
				#stimDelay
				$finish;
		end
endmodule