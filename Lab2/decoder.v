`timescale 1ns/100ps
// when enabled, decoder select 1 out of 32 wordlines according to the provided address
// structural verilog:  using an array of 32 7-input and gates and 5 inverters

module decoder (word, adrx, en);

output [31:0] word;
input [4:0] adrx;
input en;
wire [4:0] adrx_bar;

// invert input stage
not (adrx_bar[4], adrx[4]);
not (adrx_bar[3], adrx[3]);
not (adrx_bar[2], adrx[2]);
not (adrx_bar[1], adrx[1]);
not (adrx_bar[0], adrx[0]);

// 7-input and gate array with enable
and (word[31], en,	 adrx[4],		adrx[3],			adrx[2], 		adrx[1], 		adrx[0]);			// 11111
and (word[30], en,	 adrx[4],		adrx[3],			adrx[2], 		adrx[1], 		adrx_bar[0]);		// 11110
and (word[29], en,	 adrx[4],		adrx[3],			adrx[2], 		adrx_bar[1], 	adrx[0]);			// 11101
and (word[28], en,	 adrx[4],		adrx[3],			adrx[2], 		adrx_bar[1],	adrx_bar[0]);		// 11100
and (word[27], en,	 adrx[4], 		adrx[3],			adrx_bar[2], 	adrx[1], 		adrx[0]);			// 11011	
and (word[26], en,	 adrx[4], 		adrx[3],			adrx_bar[2], 	adrx[1], 		adrx_bar[0]);		// 11010
and (word[25], en,	 adrx[4], 		adrx[3],			adrx_bar[2], 	adrx_bar[1],	adrx[0]);			// 11001
and (word[24], en,	 adrx[4], 		adrx[3],			adrx_bar[2], 	adrx_bar[1],	adrx_bar[0]);		// 11000
and (word[23], en,	 adrx[4], 		adrx_bar[3],	adrx[2], 		adrx[1],			adrx[0]);			// 10111
and (word[22], en,	 adrx[4], 		adrx_bar[3],	adrx[2], 		adrx[1], 		adrx_bar[0]);		// 10110
and (word[21], en,	 adrx[4], 		adrx_bar[3],	adrx[2], 		adrx_bar[1],	adrx[0]);			// 10101
and (word[20], en,	 adrx[4], 		adrx_bar[3],	adrx[2], 		adrx_bar[1], 	adrx_bar[0]);		// 10100
and (word[19], en,	 adrx[4], 		adrx_bar[3],	adrx_bar[2], 	adrx[1], 		adrx[0]);			// 10011
and (word[18], en,	 adrx[4], 		adrx_bar[3],	adrx_bar[2], 	adrx[1], 		adrx_bar[0]);		// 10010
and (word[17], en,	 adrx[4], 		adrx_bar[3],	adrx_bar[2], 	adrx_bar[1], 	adrx[0]);			// 10001
and (word[16], en,	 adrx[4], 		adrx_bar[3],	adrx_bar[2], 	adrx_bar[1], 	adrx_bar[0]);		// 10000
and (word[15], en,	 adrx_bar[4], 	adrx[3], 		adrx[2], 		adrx[1], 		adrx[0]);			// 01111
and (word[14], en,	 adrx_bar[4], 	adrx[3], 		adrx[2], 		adrx[1],			adrx_bar[0]);		// 01110
and (word[13], en,	 adrx_bar[4], 	adrx[3], 		adrx[2], 		adrx_bar[1], 	adrx[0]);			// 01101
and (word[12], en,	 adrx_bar[4], 	adrx[3], 		adrx[2], 		adrx_bar[1], 	adrx_bar[0]);		// 01100
and (word[11], en,	 adrx_bar[4], 	adrx[3], 		adrx_bar[2], 	adrx[1], 		adrx[0]);			// 01011
and (word[10], en,	 adrx_bar[4], 	adrx[3], 		adrx_bar[2], 	adrx[1], 		adrx_bar[0]);		// 01010
and (word[9], 	en,	 adrx_bar[4], 	adrx[3], 		adrx_bar[2], 	adrx_bar[1],	adrx[0]);			// 01001
and (word[8], 	en,	 adrx_bar[4], 	adrx[3], 		adrx_bar[2], 	adrx_bar[1], 	adrx_bar[0]);		// 01000
and (word[7], 	en,	 adrx_bar[4], 	adrx_bar[3], 	adrx[2], 		adrx[1], 		adrx[0]);			// 00111
and (word[6], 	en,	 adrx_bar[4], 	adrx_bar[3], 	adrx[2],	 		adrx[1], 		adrx_bar[0]);		// 00110
and (word[5], 	en,	 adrx_bar[4], 	adrx_bar[3], 	adrx[2], 		adrx_bar[1], 	adrx[0]);			// 00101
and (word[4], 	en,	 adrx_bar[4], 	adrx_bar[3], 	adrx[2], 		adrx_bar[1], 	adrx_bar[0]);		// 00100
and (word[3], 	en,	 adrx_bar[4], 	adrx_bar[3], 	adrx_bar[2], 	adrx[1], 		adrx[0]);			// 00011
and (word[2], 	en,	 adrx_bar[4], 	adrx_bar[3], 	adrx_bar[2], 	adrx[1], 		adrx_bar[0]);		// 00010
and (word[1], 	en,	 adrx_bar[4], 	adrx_bar[3], 	adrx_bar[2], 	adrx_bar[1], 	adrx[0]);			// 00001
and (word[0], 	en,	 adrx_bar[4], 	adrx_bar[3], 	adrx_bar[2], 	adrx_bar[1], 	adrx_bar[0]);		// 00000

endmodule
