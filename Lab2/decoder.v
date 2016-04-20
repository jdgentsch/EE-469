`timescale 1ns/100ps
//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 2: Individual register module for our memory subsystem
//EE 469 with James Peckol 4/8/16
// The decoder selects 1 out of 32 selectlines according to the provided address
// Structural verilog:  Uses an array of 32 6-input and gates and 5 inverters
module decoder (select, adrx);
	output [31:0] select;
	input [4:0] adrx;
	wire [4:0] adrx_bar;

	// invert input stage
	not (adrx_bar[4], adrx[4]);
	not (adrx_bar[3], adrx[3]);
	not (adrx_bar[2], adrx[2]);
	not (adrx_bar[1], adrx[1]);
	not (adrx_bar[0], adrx[0]);

	// 6-input and gate array with enable
	and (select[31], 	 adrx[4],		adrx[3],			adrx[2], 		adrx[1], 		adrx[0]);			// 11111
	and (select[30], 	 adrx[4],		adrx[3],			adrx[2], 		adrx[1], 		adrx_bar[0]);		// 11110
	and (select[29], 	 adrx[4],		adrx[3],			adrx[2], 		adrx_bar[1], 	adrx[0]);			// 11101
	and (select[28], 	 adrx[4],		adrx[3],			adrx[2], 		adrx_bar[1],	adrx_bar[0]);		// 11100
	and (select[27], 	 adrx[4], 		adrx[3],			adrx_bar[2], 	adrx[1], 		adrx[0]);			// 11011	
	and (select[26], 	 adrx[4], 		adrx[3],			adrx_bar[2], 	adrx[1], 		adrx_bar[0]);		// 11010
	and (select[25], 	 adrx[4], 		adrx[3],			adrx_bar[2], 	adrx_bar[1],	adrx[0]);			// 11001
	and (select[24], 	 adrx[4], 		adrx[3],			adrx_bar[2], 	adrx_bar[1],	adrx_bar[0]);		// 11000
	and (select[23], 	 adrx[4], 		adrx_bar[3],	adrx[2], 		adrx[1],			adrx[0]);			// 10111
	and (select[22], 	 adrx[4], 		adrx_bar[3],	adrx[2], 		adrx[1], 		adrx_bar[0]);		// 10110
	and (select[21], 	 adrx[4], 		adrx_bar[3],	adrx[2], 		adrx_bar[1],	adrx[0]);			// 10101
	and (select[20], 	 adrx[4], 		adrx_bar[3],	adrx[2], 		adrx_bar[1], 	adrx_bar[0]);		// 10100
	and (select[19], 	 adrx[4], 		adrx_bar[3],	adrx_bar[2], 	adrx[1], 		adrx[0]);			// 10011
	and (select[18], 	 adrx[4], 		adrx_bar[3],	adrx_bar[2], 	adrx[1], 		adrx_bar[0]);		// 10010
	and (select[17], 	 adrx[4], 		adrx_bar[3],	adrx_bar[2], 	adrx_bar[1], 	adrx[0]);			// 10001
	and (select[16], 	 adrx[4], 		adrx_bar[3],	adrx_bar[2], 	adrx_bar[1], 	adrx_bar[0]);		// 10000
	and (select[15], 	 adrx_bar[4], 	adrx[3], 		adrx[2], 		adrx[1], 		adrx[0]);			// 01111
	and (select[14], 	 adrx_bar[4], 	adrx[3], 		adrx[2], 		adrx[1],			adrx_bar[0]);		// 01110
	and (select[13], 	 adrx_bar[4], 	adrx[3], 		adrx[2], 		adrx_bar[1], 	adrx[0]);			// 01101
	and (select[12], 	 adrx_bar[4], 	adrx[3], 		adrx[2], 		adrx_bar[1], 	adrx_bar[0]);		// 01100
	and (select[11], 	 adrx_bar[4], 	adrx[3], 		adrx_bar[2], 	adrx[1], 		adrx[0]);			// 01011
	and (select[10], 	 adrx_bar[4], 	adrx[3], 		adrx_bar[2], 	adrx[1], 		adrx_bar[0]);		// 01010
	and (select[9],  	 adrx_bar[4], 	adrx[3], 		adrx_bar[2], 	adrx_bar[1],	adrx[0]);			// 01001
	and (select[8],  	 adrx_bar[4], 	adrx[3], 		adrx_bar[2], 	adrx_bar[1], 	adrx_bar[0]);		// 01000
	and (select[7],  	 adrx_bar[4], 	adrx_bar[3], 	adrx[2], 		adrx[1], 		adrx[0]);			// 00111
	and (select[6],  	 adrx_bar[4], 	adrx_bar[3], 	adrx[2],	 		adrx[1], 		adrx_bar[0]);		// 00110
	and (select[5],  	 adrx_bar[4], 	adrx_bar[3], 	adrx[2], 		adrx_bar[1], 	adrx[0]);			// 00101
	and (select[4],  	 adrx_bar[4], 	adrx_bar[3], 	adrx[2], 		adrx_bar[1], 	adrx_bar[0]);		// 00100
	and (select[3],  	 adrx_bar[4], 	adrx_bar[3], 	adrx_bar[2], 	adrx[1], 		adrx[0]);			// 00011
	and (select[2],  	 adrx_bar[4], 	adrx_bar[3], 	adrx_bar[2], 	adrx[1], 		adrx_bar[0]);		// 00010
	and (select[1],  	 adrx_bar[4], 	adrx_bar[3], 	adrx_bar[2], 	adrx_bar[1], 	adrx[0]);			// 00001
	and (select[0],  	 adrx_bar[4], 	adrx_bar[3], 	adrx_bar[2], 	adrx_bar[1], 	adrx_bar[0]);		// 00000

endmodule
