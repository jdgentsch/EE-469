//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 2: SRAM Demo
//EE 469 with James Peckol 4/8/16

//This top-level driver will interface directly with the SRAM, reading or writing
//0 to 127 in the first 128 addresses of the SRAM
module sramDemo (LEDR, SW, KEY, CLOCK_50);
	output [9:0] LEDR;
	input CLOCK_50;
	input [9:0] SW;
	input [3:0] KEY;

	reg nOE;
	reg read;
	reg [7:0] adrx;
	reg [7:0] mem;

	wire data [7:0];
	wire rst;
	wire enterWrite;
	wire enterRead;
	reg [9:0] ledDriver;

	wire [31:0] clk; // choosing from 32 different clock speeds

	// instantiate clock_divider module
 	clock_divider cdiv (CLOCK_50, clk);

  	// tri-state driver for our inout port
 	assign data = nOE ? mem : 8'bz;

  	assign rst = SW[9];
 	assign enterRead = ~KEY[0];
	assign enterWrite = ~KEY[1];
	assign LEDR = ledDriver;

 	// state encoding
 	parameter [2:0] idle = 3'b000, writeSet = 3'b001, writeDo = 3'b011; 
 	parameter [2:0] readSet = 3'b111, readDo = 3'b110;

 	