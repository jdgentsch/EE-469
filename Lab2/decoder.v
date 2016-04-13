`timescale 1ns/100ps
// when enabled, decoder select 1 out of 32 wordlines according to the provided address
// structural verilog:  using an array of 32 7-input and gates and 5 inverters

module decoder (word, adx, en);

output [31:0] word;
input [4:0] adx;
input en;
wire [4:0] adx_bar;

// invert input stage
not (adx_bar[4], adx[4]);
not (adx_bar[3], adx[3]);
not (adx_bar[2], adx[2]);
not (adx_bar[1], adx[1]);
not (adx_bar[0], adx[0]);

// 7-input and gate array with enable
and (word[31], en,	 adx[4],			adx[3],			adx[2], 			adx[1], 			adx[0]);				// 11111
and (word[30], en,	 adx[4],			adx[3],			adx[2], 			adx[1], 			adx_bar[0]);		// 11110
and (word[29], en,	 adx[4],			adx[3],			adx[2], 			adx_bar[1], 	adx[0]);				// 11101
and (word[28], en,	 adx[4],			adx[3],			adx[2], 			adx_bar[1],		adx_bar[0]);		// 11100
and (word[27], en,	 adx[4], 		adx[3],			adx_bar[2], 	adx[1], 			adx[0]);				// 11011	
and (word[26], en,	 adx[4], 		adx[3],			adx_bar[2], 	adx[1], 			adx_bar[0]);		// 11010
and (word[25], en,	 adx[4], 		adx[3],			adx_bar[2], 	adx_bar[1],		adx[0]);				// 11001
and (word[24], en,	 adx[4], 		adx[3],			adx_bar[2], 	adx_bar[1],		adx_bar[0]);		// 11000
and (word[23], en,	 adx[4], 		adx_bar[3],		adx[2], 			adx[1],			adx[0]);				// 10111
and (word[22], en,	 adx[4], 		adx_bar[3],		adx[2], 			adx[1], 			adx_bar[0]);		// 10110
and (word[21], en,	 adx[4], 		adx_bar[3],		adx[2], 			adx_bar[1],		adx[0]);				// 10101
and (word[20], en,	 adx[4], 		adx_bar[3],		adx[2], 			adx_bar[1], 	adx_bar[0]);		// 10100
and (word[19], en,	 adx[4], 		adx_bar[3],		adx_bar[2], 	adx[1], 			adx[0]);				// 10011
and (word[18], en,	 adx[4], 		adx_bar[3],		adx_bar[2], 	adx[1], 			adx_bar[0]);		// 10010
and (word[17], en,	 adx[4], 		adx_bar[3],		adx_bar[2], 	adx_bar[1], 	adx[0]);				// 10001
and (word[16], en,	 adx[4], 		adx_bar[3],		adx_bar[2], 	adx_bar[1], 	adx_bar[0]);		// 10000
and (word[15], en,	 adx_bar[4], 	adx[3], 			adx[2], 			adx[1], 			adx[0]);				// 01111
and (word[14], en,	 adx_bar[4], 	adx[3], 			adx[2], 			adx[1],			adx_bar[0]);		// 01110
and (word[13], en,	 adx_bar[4], 	adx[3], 			adx[2], 			adx_bar[1], 	adx[0]);				// 01101
and (word[12], en,	 adx_bar[4], 	adx[3], 			adx[2], 			adx_bar[1], 	adx_bar[0]);		// 01100
and (word[11], en,	 adx_bar[4], 	adx[3], 			adx_bar[2], 	adx[1], 			adx[0]);				// 01011
and (word[10], en,	 adx_bar[4], 	adx[3], 			adx_bar[2], 	adx[1], 			adx_bar[0]);		// 01010
and (word[9], 	en,	 adx_bar[4], 	adx[3], 			adx_bar[2], 	adx_bar[1],		adx[0]);				// 01001
and (word[8], 	en,	 adx_bar[4], 	adx[3], 			adx_bar[2], 	adx_bar[1], 	adx_bar[0]);		// 01000
and (word[7], 	en,	 adx_bar[4], 	adx_bar[3], 	adx[2], 			adx[1], 			adx[0]);				// 00111
and (word[6], 	en,	 adx_bar[4], 	adx_bar[3], 	adx[2],	 		adx[1], 			adx_bar[0]);		// 00110
and (word[5], 	en,	 adx_bar[4], 	adx_bar[3], 	adx[2], 			adx_bar[1], 	adx[0]);				// 00101
and (word[4], 	en,	 adx_bar[4], 	adx_bar[3], 	adx[2], 			adx_bar[1], 	adx_bar[0]);		// 00100
and (word[3], 	en,	 adx_bar[4], 	adx_bar[3], 	adx_bar[2], 	adx[1], 			adx[0]);				// 00011
and (word[2], 	en,	 adx_bar[4], 	adx_bar[3], 	adx_bar[2], 	adx[1], 			adx_bar[0]);		// 00010
and (word[1], 	en,	 adx_bar[4], 	adx_bar[3], 	adx_bar[2], 	adx_bar[1], 	adx[0]);				// 00001
and (word[0], 	en,	 adx_bar[4], 	adx_bar[3], 	adx_bar[2], 	adx_bar[1], 	adx_bar[0]);		// 00000

endmodule
