// Jack Gentsch, Jacky Wang, Chinh Bui
// EE 469, Dr. Peckol 4/15/16
// ALU GTKwave Test

`include "alu_behav.v"

module aluGTK;
	wire [31:0] busOut;
	wire zero, overflow, carry, neg;
	wire [31:0] busA, busB;
	wire [2:0] control;

	//declare instances of dut and tester modules
	alu_behav myalu (busOut, zero, overflow, carry, neg, busA, busB, control);
	Tester aTester (busA, busB, control, busOut, zero, overflow, carry, neg);

	// file for gtkwave
	initial
		begin
			$dumpfile("aluGTK.vcd");
			$dumpvars(1, myalu);
		end
endmodule


module Tester (busA, busB, control, busOut, zero, overflow, carry, neg);
	output reg [31:0] busA, busB;
	output reg [2:0] control;
	input [31:0] busOut;
	input zero, overflow, carry, neg;

	parameter stimDelay = 20;

	initial // Stimulus
		begin
				#stimDelay busA = 32'hFFFFFFFF; busB = 32'h00000001; control = 3'b000;
				#stimDelay control = 3'b001;
				#stimDelay control = 3'b010;
				#stimDelay control = 3'b011;
				#stimDelay control = 3'b100;
				#stimDelay control = 3'b101;
				#stimDelay control = 3'b110;
				#stimDelay control = 3'b111;
				#stimDelay
				$finish;
		end
endmodule