// A four-stage ripple down counter with active low reset- Counter 1 of EE 469 Lab 1
// Note that this upper level module is intended 
// for use with the DE1_SoC and Spinal Tap.

// Written by Jack Gentsch, Jacky Wang, and Chinh Bui
// 4/3/2016 instructed by Professor Peckol

//Declaration of DE1_SoC inputs and outputs: LED as output,
//an active-low reset on Switch 0 and a 50 MHz clock
module counter_DE1(LEDR, CLOCK_50, SW);
	//Declaration of clocks, switches, and LEDs for usage
	output [9:0] LEDR;
	input [9:0] SW;
	input CLOCK_50;
	wire [31:0] clk;
	
	//A 50 MHz clock is used for the DE1_SoC and Signal Tap
	//Testing live on the DE1-SoC uses a value of "25" to create 0.75 Hz
	parameter clkBit = 0;
	
	//Set unused LED's to low
	assign LEDR[9:4] = 0;
	
	//Declare an instance of the synthesized schematic module
	rippleDownCounter myRippleDown (.out(LEDR[3:0]), .clk(clk[clkBit]), .rst(SW[9]));

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