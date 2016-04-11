`timescale 1ns/100ps
// when enabled, decoder select 1 out of 31 wordlines according to the provided address
// structural verilog:  using an array of 31 7-input and gates and 5 inverters
// wordline[0] will always be high Z since the data will always be 0

module decoder (wr_adx, wr_en, wr_word);

input [4:0] wr_adx;
input wr_en;
output [31:0] wr_word;
wire [4:0] wr_adx_b;

// invert input stage
not (wr_adx_b[4], wr_adx[4]);
not (wr_adx_b[3], wr_adx[3]);
not (wr_adx_b[2], wr_adx[2]);
not (wr_adx_b[1], wr_adx[1]);
not (wr_adx_b[0], wr_adx[0]);

// 7-input and gate array with enable
// skip wordline address 00000 of wr_word[0]
and (wr_word[31], wr_en,	 wr_adx[4],		wr_adx[3],		wr_adx[2], 		wr_adx[1], 		wr_adx[0]);				// 11111
and (wr_word[30], wr_en,	 wr_adx[4],		wr_adx[3],		wr_adx[2], 		wr_adx[1], 		wr_adx_b[0]);			// 11110
and (wr_word[29], wr_en,	 wr_adx[4],		wr_adx[3],		wr_adx[2], 		wr_adx_b[1], 	wr_adx[0]);				// 11101
and (wr_word[28], wr_en,	 wr_adx[4],		wr_adx[3],		wr_adx[2], 		wr_adx_b[1],	wr_adx_b[0]);			// 11100
and (wr_word[27], wr_en,	 wr_adx[4], 	wr_adx[3],		wr_adx_b[2], 	wr_adx[1], 		wr_adx[0]);				// 11011	
and (wr_word[26], wr_en,	 wr_adx[4], 	wr_adx[3],		wr_adx_b[2], 	wr_adx[1], 		wr_adx_b[0]);			// 11010
and (wr_word[25], wr_en,	 wr_adx[4], 	wr_adx[3],		wr_adx_b[2], 	wr_adx_b[1],	wr_adx[0]);				// 11001
and (wr_word[24], wr_en,	 wr_adx[4], 	wr_adx[3],		wr_adx_b[2], 	wr_adx_b[1],	wr_adx_b[0]);			// 11000
and (wr_word[23], wr_en,	 wr_adx[4], 	wr_adx_b[3],	wr_adx[2], 		wr_adx[1],		wr_adx[0]);				// 10111
and (wr_word[22], wr_en,	 wr_adx[4], 	wr_adx_b[3],	wr_adx[2], 		wr_adx[1], 		wr_adx_b[0]);			// 10110
and (wr_word[21], wr_en,	 wr_adx[4], 	wr_adx_b[3],	wr_adx[2], 		wr_adx_b[1],	wr_adx[0]);				// 10101
and (wr_word[20], wr_en,	 wr_adx[4], 	wr_adx_b[3],	wr_adx[2], 		wr_adx_b[1], 	wr_adx_b[0]);			// 10100
and (wr_word[19], wr_en,	 wr_adx[4], 	wr_adx_b[3],	wr_adx_b[2], 	wr_adx[1], 		wr_adx[0]);				// 10011
and (wr_word[18], wr_en,	 wr_adx[4], 	wr_adx_b[3],	wr_adx_b[2], 	wr_adx[1], 		wr_adx_b[0]);			// 10010
and (wr_word[17], wr_en,	 wr_adx[4], 	wr_adx_b[3],	wr_adx_b[2], 	wr_adx_b[1], 	wr_adx[0]);				// 10001
and (wr_word[16], wr_en,	 wr_adx[4], 	wr_adx_b[3],	wr_adx_b[2], 	wr_adx_b[1], 	wr_adx_b[0]);			// 10000
and (wr_word[15], wr_en,	 wr_adx_b[4], 	wr_adx[3], 		wr_adx[2], 		wr_adx[1], 		wr_adx[0]);				// 01111
and (wr_word[14], wr_en,	 wr_adx_b[4], 	wr_adx[3], 		wr_adx[2], 		wr_adx[1],		wr_adx_b[0]);			// 01110
and (wr_word[13], wr_en,	 wr_adx_b[4], 	wr_adx[3], 		wr_adx[2], 		wr_adx_b[1], 	wr_adx[0]);				// 01101
and (wr_word[12], wr_en,	 wr_adx_b[4], 	wr_adx[3], 		wr_adx[2], 		wr_adx_b[1], 	wr_adx_b[0]);			// 01100
and (wr_word[11], wr_en,	 wr_adx_b[4], 	wr_adx[3], 		wr_adx_b[2], 	wr_adx[1], 		wr_adx[0]);				// 01011
and (wr_word[10], wr_en,	 wr_adx_b[4], 	wr_adx[3], 		wr_adx_b[2], 	wr_adx[1], 		wr_adx_b[0]);			// 01010
and (wr_word[9], 	wr_en,	 wr_adx_b[4], 	wr_adx[3], 		wr_adx_b[2], 	wr_adx_b[1],	wr_adx[0]);				// 01001
and (wr_word[8], 	wr_en,	 wr_adx_b[4], 	wr_adx[3], 		wr_adx_b[2], 	wr_adx_b[1], 	wr_adx_b[0]);			// 01000
and (wr_word[7], 	wr_en,	 wr_adx_b[4], 	wr_adx_b[3], 	wr_adx[2], 		wr_adx[1], 		wr_adx[0]);				// 00111
and (wr_word[6], 	wr_en,	 wr_adx_b[4], 	wr_adx_b[3], 	wr_adx[2],	 	wr_adx[1], 		wr_adx_b[0]);			// 00110
and (wr_word[5], 	wr_en,	 wr_adx_b[4], 	wr_adx_b[3], 	wr_adx[2], 		wr_adx_b[1], 	wr_adx[0]);				// 00101
and (wr_word[4], 	wr_en,	 wr_adx_b[4], 	wr_adx_b[3], 	wr_adx[2], 		wr_adx_b[1], 	wr_adx_b[0]);			// 00100
and (wr_word[3], 	wr_en,	 wr_adx_b[4], 	wr_adx_b[3], 	wr_adx_b[2], 	wr_adx[1], 		wr_adx[0]);				// 00011
and (wr_word[2], 	wr_en,	 wr_adx_b[4], 	wr_adx_b[3], 	wr_adx_b[2], 	wr_adx[1], 		wr_adx_b[0]);			// 00010
and (wr_word[1], 	wr_en,	 wr_adx_b[4], 	wr_adx_b[3], 	wr_adx_b[2], 	wr_adx_b[1], 	wr_adx[0]);				// 00001

endmodule
