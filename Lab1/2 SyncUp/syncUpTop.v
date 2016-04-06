// A four-stage synchrnous up counter counter with active low reset- Counter 2 of EE 469 Lab 1
// Note that this upper level module is intended for use with the DE1_SoC and Spinal Tap.

// Written by Jack Gentsch, Jacky Wang, and Chinh Bui
// 4/3/2016 instructed by Professor Peckol

module syncUpTop (LEDR, CLOCK_50, SW);
	output [3:0] LEDR; // present state output
	input CLOCK_50;
    input [9:0] SW;

 	wire [31:0] clk; // choosing from 32 different clock speeds

 	syncUp mySyncUp (LEDR[3:0], clk[0], SW[9]); // Instantiate syncUp module; clock speed 0.75Hz

 	clock_divider cdiv (CLOCK_50, clk); // Instantiate clock_divider module

endmodule

 // divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...
module clock_divider (clock, divided_clocks);
	input clock;
	output [31:0] divided_clocks;
	reg [31:0] divided_clocks;
	
	initial
		divided_clocks = 0;
	
	always @(posedge clock)
		divided_clocks = divided_clocks + 1;
		
endmodule
