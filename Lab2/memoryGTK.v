//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 2: Memory integrated system test vector for iVerilog
//EE 469 with James Peckol 4/15/16
`timescale 1ns/100ps
`include "registerFile.v"
`include "register.v"
`include "mux32.v"
`include "decoder.v"
`include "memory.v"
`include "sram.v"

module memory_tb();

	wire [31:0] rdRF1, rdRF0, data;				
	wire clk, sramNotOutEn, sramRead, rfWriteEn;
	wire [10:0] sramAdrx;
	wire [4:0] rfWriteAdrx, rfRdAdrx1, rfRdAdrx0;
	wire [1:0] dataMuxSel;
	
	// declare instances of dut and tester modules
	memory dut (.rdRF1(rdRF1), .rdRF0(rdRF0), .data(data), .clk(clk), .sramAdrx(sramAdrx), .sramNotOutEn(sramNotOutEn), .sramRead(sramRead),		// i, i, io, o, o, o, o
					.rfWriteAdrx(rfWriteAdrx), .rfRdAdrx1(rfRdAdrx1), .rfRdAdrx0(rfRdAdrx0), .rfWriteEn(rfWriteEn), .dataMuxSel(dataMuxSel));	// i, i, i, i, i
	memory_tester test0 (.rdRF1(rdRF1), .rdRF0(rdRF0), .data(data), .clk(clk), .sramAdrx(sramAdrx), .sramNotOutEn(sramNotOutEn), .sramRead(sramRead),		// i, i, io, o, o, o, o
					.rfWriteAdrx(rfWriteAdrx), .rfRdAdrx1(rfRdAdrx1), .rfRdAdrx0(rfRdAdrx0), .rfWriteEn(rfWriteEn), .dataMuxSel(dataMuxSel));				// o,o,o,o,o

	// creating simulation file
	initial begin
		$dumpfile ("memoryGTK.vcd");
		$dumpvars (0, test0);
		$dumpvars (0, dut);
	end

endmodule

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
module memory_tester(rdRF1, rdRF0, data, clk, sramAdrx, sramNotOutEn, sramRead,		// i, i, io, o, o, o, o
					rfWriteAdrx, rfRdAdrx1, rfRdAdrx0, rfWriteEn, dataMuxSel);			 // o,o,o,o,o

	input [31:0] rdRF1, rdRF0;
	inout [31:0] data;
	output reg clk, sramNotOutEn, sramRead, rfWriteEn;
	output reg [10:0] sramAdrx;
	output reg [4:0] rfWriteAdrx, rfRdAdrx1, rfRdAdrx0;
	output reg [1:0] dataMuxSel;
	reg [31:0] sramWriteData;
	
	// Drive data bus based on mux select for the reg file
	assign data = dataMuxSel[1] | ~sramNotOutEn ? 32'bz : sramWriteData;
	
	integer i;
	parameter DELAY = 2;
	initial clk = 1;
	always begin
	#(DELAY/2);
	clk = !clk;
	end	
	
	initial begin
	sramNotOutEn = 1'b1; sramRead = 1'b0;
	rfWriteEn = 1'b0; rfWriteAdrx = 5'b0;
	rfRdAdrx1 = 5'b0; rfRdAdrx0 = 5'b0; sramAdrx = 11'b0; dataMuxSel = 2'b0;
	sramWriteData = 32'hFFFFFFFF;
	
	//Write values into the SRAM
	for (i = 0; i < 32; i = i + 1) begin
		#DELAY
		sramRead = 1'b1;
		#DELAY
		sramWriteData = sramWriteData - 32'b1;
		sramAdrx = sramAdrx + 32'b1;
		sramRead = 1'b0;
	end
	#DELAY
	sramNotOutEn = 1'b0; rfWriteEn = 1'b1; sramAdrx = 11'b0;
	sramRead = 1'b1;
	#DELAY
	//Write values from the sram into the regfile
	for (i = 0; i < 32; i = i + 1) begin
		#DELAY
		rfWriteAdrx = rfWriteAdrx + 5'b1;
		sramAdrx = sramAdrx + 11'b1;
		rfRdAdrx1 = rfRdAdrx1 + 5'b1;
	end
	#DELAY
	dataMuxSel = 2'b11; rfRdAdrx1 = 5'b0; sramAdrx = 11'b0;
	sramNotOutEn = 1'b1; rfWriteEn = 1'b0;
	#DELAY
	//Read values from the regfile
		for (i = 0; i < 32; i = i + 1) begin
		#DELAY
		rfRdAdrx1 = rfRdAdrx1 + 5'b1;
	end
	#(DELAY*4);
	$finish;
	end
endmodule
