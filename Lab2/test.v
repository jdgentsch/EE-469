`timescale 1ns/100ps
`include "registerFile.v"
`include "register.v"
`include "mux32.v"
`include "decoder.v"
`include "memory.v"
`include "sram.v"
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
module memory_tb();

	wire [31:0] rdRF1, rdRF0, data;				
	wire clk, sramNotOutEn, sramRead, rfWriteEn;
	wire [10:0] sramAdrx;
	wire [4:0] rfWriteAdrx, rfRdAdrx1, rfRdAdrx0;
	wire [1:0] dataMuxSel;

	// declare instances of dut and tester modules
	memory dut (rdRF1, rdRF0, data, clk, sramAdrx, sramNotOutEn, sramRead,		// o, o, io, i, i, i, i
					rfWriteAdrx, rfRdAdrx1, rfRdAdrx0, rfWriteEn, dataMuxSel);	// i, i, i, i, i
	memory_tester test0 (rdRF1, rdRF0, data, clk, sramAdrx, sramNotOutEn, sramRead,		// i, i, io, o, o, o, o
					rfWriteAdrx, rfRdAdrx1, rfRdAdrx0, rfWriteEn, dataMuxSel);				// o,o,o,o,o

	// creating simulation file
	initial begin
		$dumpfile ("memory.vcd");
		$dumpvars (1, dut);
	end

endmodule

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
module memory_tester(rdRF1, rdRF0, data, clk, sramAdrx, sramNotOutEn, sramRead,		// i, i, io, o, o, o, o
					rfWriteAdrx, rfRdAdrx1, rfRdAdrx0, rfWriteEn, dataMuxSel);			 // o,o,o,o,o

	input [31:0] rdRF1, rdRF0;
	output reg [31:0] data;
	output reg clk, sramNotOutEn, sramRead, rfWriteEn;
	output reg [10:0] sramAdrx;
	output reg [4:0] rfWriteAdrx, rfRdAdrx1, rfRdAdrx0;
	output reg [1:0] dataMuxSel;
	
	parameter DELAY = 2;
	initial clk = 0;
	always begin
	#(DELAY/2);
	clk = !clk;
	end	
	
	initial begin
	sramNotOutEn = 1; sramRead = 0 ; data = 32'b0; rfWriteEn = 0; rfWriteAdrx = 4'b0;
	rfRdAdrx1 = 4'b0; rfRdAdrx0 = 4'b0; sramAdrx = 11'd0; dataMuxSel = 2'd0;
	#DELAY	
	sramRead = 0;
	#DELAY
	sramRead = 1;
	#(DELAY*4);
	$finish;
	end
endmodule
