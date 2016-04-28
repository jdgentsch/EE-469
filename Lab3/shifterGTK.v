`timescale 1ns/100ps
`include "shifter.v"
`include "mux32.v"
//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 3: shifter iVerilog system test
//EE 469 with James Peckol 5/5/16
module shifter_tb();

	wire [31:0]in, out;
	wire [1:0] shift;

	//declare instances of dut and tester modules
	barrelShifter dut (out,in,shift);	// dut (out,in,in)
	shiftTester test0 (out,in,shift);				// tester0 (in,out,out)

	//creating simulation file
	initial begin
		$dumpfile ("shifter.vcd");
		$dumpvars (1, dut);
	end

endmodule

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
module shiftTester(out, in, shift);				// port types by order: out, out, in

	output reg [31:0] in;
	output reg [1:0] shift;
	input [31:0] out;

	// begin sending stimulus
	// sending address from location 1 to 31
	initial begin
		#10 in = 32'hFFFFFFFF; shift = 2'b00;
		#10 shift = 2'b01;
		#10 shift = 2'b10;
		#10 shift = 2'b11;
		#10 $finish;
	end
endmodule
