// Ripple down counter - Counter 4 of EE 371 Lab 1, utilizes the schematic model.
// Note that this file uses Quartus synthesized Verilog, and is intended for
// use in programming the Cyclone V or running Spinal Tap directly.

// Written by Jack Gentsch and Jacky Wang
// 10/4/2015 instructed by Professor Peckol

//Declaration of DE1_SoC inputs and outputs: LED as output,
//an active-low reset on Switch 0 and a 50 MHz clock
module syncUp_DE1(LEDR, SW, CLOCK_50);

	//Declaration of clocks, switches, and LEDs for usage
	output [9:0] LEDR;
	input [3:0] SW;
	input CLOCK_50;
	wire [31:0] clk;
	
	//A 50 MHz clock is used for the DE1_SoC and Signal Tap
	parameter clkBit = 0;
	
	//Set unused LED's to low
	assign LEDR[9:4] = 0;
	
	//Declare an instance of the synthesized schematic module
	syncSchematic mySyncSchm (.q(LEDR[3:0]), .clk(clk[clkBit]), .reset(SW[0]));

	//Creates a clock divider to allow for a slower clock
	clockDiv clkDiv(.clkIn(CLOCK_50), .clkOut(clk));
endmodule

//Clock division module
module clockDiv(clkIn, clkOut);
	input clkIn;
	output reg [31:0] clkOut;
	
	initial clkOut = 0;
	
	//Many slow clocks are created based on the 50 MHz clock
	always @(posedge clkIn)
		clkOut = clkOut + 1;
endmodule