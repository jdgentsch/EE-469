`timescale 1ns/100ps
// when enabled, decoder select 1 out of 32 selectlines according to the provided address
// structural verilog:  using an array of 32 7-input and gates and 5 inverters

module decoder (select, adrx, en);

output [31:0] select;
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
and (select[31], en,	 adrx[4],		adrx[3],		adrx[2], 		adrx[1], 		adrx[0]);			// 11111
and (select[30], en,	 adrx[4],		adrx[3],		adrx[2], 		adrx[1], 		adrx_bar[0]);		// 11110
and (select[29], en,	 adrx[4],		adrx[3],		adrx[2], 		adrx_bar[1], 	adrx[0]);			// 11101
and (select[28], en,	 adrx[4],		adrx[3],		adrx[2], 		adrx_bar[1],	adrx_bar[0]);		// 11100
and (select[27], en,	 adrx[4], 		adrx[3],		adrx_bar[2], 	adrx[1], 		adrx[0]);			// 11011	
and (select[26], en,	 adrx[4], 		adrx[3],		adrx_bar[2], 	adrx[1], 		adrx_bar[0]);		// 11010
and (select[25], en,	 adrx[4], 		adrx[3],		adrx_bar[2], 	adrx_bar[1],	adrx[0]);			// 11001
and (select[24], en,	 adrx[4], 		adrx[3],		adrx_bar[2], 	adrx_bar[1],	adrx_bar[0]);		// 11000
and (select[23], en,	 adrx[4], 		adrx_bar[3],	adrx[2], 		adrx[1],		adrx[0]);			// 10111
and (select[22], en,	 adrx[4], 		adrx_bar[3],	adrx[2], 		adrx[1], 		adrx_bar[0]);		// 10110
and (select[21], en,	 adrx[4], 		adrx_bar[3],	adrx[2], 		adrx_bar[1],	adrx[0]);			// 10101
and (select[20], en,	 adrx[4], 		adrx_bar[3],	adrx[2], 		adrx_bar[1], 	adrx_bar[0]);		// 10100
and (select[19], en,	 adrx[4], 		adrx_bar[3],	adrx_bar[2], 	adrx[1], 		adrx[0]);			// 10011
and (select[18], en,	 adrx[4], 		adrx_bar[3],	adrx_bar[2], 	adrx[1], 		adrx_bar[0]);		// 10010
and (select[17], en,	 adrx[4], 		adrx_bar[3],	adrx_bar[2], 	adrx_bar[1], 	adrx[0]);			// 10001
and (select[16], en,	 adrx[4], 		adrx_bar[3],	adrx_bar[2], 	adrx_bar[1], 	adrx_bar[0]);		// 10000
and (select[15], en,	 adrx_bar[4], 	adrx[3], 		adrx[2], 		adrx[1], 		adrx[0]);			// 01111
and (select[14], en,	 adrx_bar[4], 	adrx[3], 		adrx[2], 		adrx[1],		adrx_bar[0]);		// 01110
and (select[13], en,	 adrx_bar[4], 	adrx[3], 		adrx[2], 		adrx_bar[1], 	adrx[0]);			// 01101
and (select[12], en,	 adrx_bar[4], 	adrx[3], 		adrx[2], 		adrx_bar[1], 	adrx_bar[0]);		// 01100
and (select[11], en,	 adrx_bar[4], 	adrx[3], 		adrx_bar[2], 	adrx[1], 		adrx[0]);			// 01011
and (select[10], en,	 adrx_bar[4], 	adrx[3], 		adrx_bar[2], 	adrx[1], 		adrx_bar[0]);		// 01010
and (select[9],  en,	 adrx_bar[4], 	adrx[3], 		adrx_bar[2], 	adrx_bar[1],	adrx[0]);			// 01001
and (select[8],  en,	 adrx_bar[4], 	adrx[3], 		adrx_bar[2], 	adrx_bar[1], 	adrx_bar[0]);		// 01000
and (select[7],  en,	 adrx_bar[4], 	adrx_bar[3], 	adrx[2], 		adrx[1], 		adrx[0]);			// 00111
and (select[6],  en,	 adrx_bar[4], 	adrx_bar[3], 	adrx[2],	 	adrx[1], 		adrx_bar[0]);		// 00110
and (select[5],  en,	 adrx_bar[4], 	adrx_bar[3], 	adrx[2], 		adrx_bar[1], 	adrx[0]);			// 00101
and (select[4],  en,	 adrx_bar[4], 	adrx_bar[3], 	adrx[2], 		adrx_bar[1], 	adrx_bar[0]);		// 00100
and (select[3],  en,	 adrx_bar[4], 	adrx_bar[3], 	adrx_bar[2], 	adrx[1], 		adrx[0]);			// 00011
and (select[2],  en,	 adrx_bar[4], 	adrx_bar[3], 	adrx_bar[2], 	adrx[1], 		adrx_bar[0]);		// 00010
and (select[1],  en,	 adrx_bar[4], 	adrx_bar[3], 	adrx_bar[2], 	adrx_bar[1], 	adrx[0]);			// 00001
and (select[0],  en,	 adrx_bar[4], 	adrx_bar[3], 	adrx_bar[2], 	adrx_bar[1], 	adrx_bar[0]);		// 00000

endmodule
