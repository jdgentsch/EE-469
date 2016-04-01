// EE 469
// Coders: Chinh Bui, Jack Gentsch, Jacky Wang
// Spring 2016
// Lab 1

// Top level module for syncUp.v

module syncUpTop (LEDR, CLOCK_50, SW);
	output [3:0] LEDR; // present state output
	input CLOCK_50;
    input [9:0] SW;

 	wire [31:0] clk; // choosing from 32 different clock speeds

 	syncUp mySyncUp (LEDR[3:0], clk[25], SW[9]); // Instantiate syncUp module; clock speed 0.75Hz

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
