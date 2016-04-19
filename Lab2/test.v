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
	//wire [31:0] datum;

	//assign data = (1'b1 == 1'b1) ? 32'b0 : 32'b1;
	//assign datum = 32'b0;
	
	// declare instances of dut and tester modules
	memory dut (.rdRF1(rdRF1), .rdRF0(rdRF0), .data(data), .clk(clk), .sramAdrx(sramAdrx), .sramNotOutEn(sramNotOutEn), .sramRead(sramRead),		// i, i, io, o, o, o, o
					.rfWriteAdrx(rfWriteAdrx), .rfRdAdrx1(rfRdAdrx1), .rfRdAdrx0(rfRdAdrx0), .rfWriteEn(rfWriteEn), .dataMuxSel(dataMuxSel));	// i, i, i, i, i
	memory_tester test0 (.rdRF1(rdRF1), .rdRF0(rdRF0), .data(data), .clk(clk), .sramAdrx(sramAdrx), .sramNotOutEn(sramNotOutEn), .sramRead(sramRead),		// i, i, io, o, o, o, o
					.rfWriteAdrx(rfWriteAdrx), .rfRdAdrx1(rfRdAdrx1), .rfRdAdrx0(rfRdAdrx0), .rfWriteEn(rfWriteEn), .dataMuxSel(dataMuxSel));				// o,o,o,o,o

	// creating simulation file
	initial begin
		$dumpfile ("memory.vcd");
		$dumpvars (0, test0);
		$dumpvars (0, dut);
	end

endmodule

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
module memory_tester(rdRF1, rdRF0, data, clk, sramAdrx, sramNotOutEn, sramRead,		// i, i, io, o, o, o, o
					rfWriteAdrx, rfRdAdrx1, rfRdAdrx0, rfWriteEn, dataMuxSel);			 // o,o,o,o,o

	input [31:0] rdRF1, rdRF0;
	inout wire [31:0] data;
	output reg clk, sramNotOutEn, sramRead, rfWriteEn;
	output reg [10:0] sramAdrx;
	output reg [4:0] rfWriteAdrx, rfRdAdrx1, rfRdAdrx0;
	output reg [1:0] dataMuxSel;
	reg [31:0] sramWriteData;
	
	assign data = dataMuxSel[1] | ~sramNotOutEn ? 32'bz : sramWriteData;
	
	parameter DELAY = 2;
	initial clk = 1;
	always begin
	#(DELAY/2);
	clk = !clk;
	end	
	
	initial begin
	sramNotOutEn = 1'b1; sramRead = 1'b0; //data = 32'b0; 
	rfWriteEn = 1'b0; rfWriteAdrx = 5'b0;
	rfRdAdrx1 = 5'b0; rfRdAdrx0 = 5'b0; sramAdrx = 11'b0; dataMuxSel = 2'b0;
	sramWriteData = 32'hFFFFFFFF;
	#DELAY	
	sramRead = 0;
	#DELAY
	sramRead = 1;
	#DELAY
	sramNotOutEn = 1'b0; sramWriteData = 32'b0; rfWriteEn = 1'b1;
	#DELAY
	rfWriteAdrx = 5'b1;
	sramAdrx = 11'b1;
	rfRdAdrx1 = 5'b1;
	//dataMuxSel = 2'b01;
	#DELAY
	//dataMuxSel = 2'b10;
	#DELAY
	//dataMuxSel = 2'b11;
	#(DELAY*4);
	$finish;
	end
endmodule
