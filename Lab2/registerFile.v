module registerFile (rdData0, rdData1, rdAdrx0, rdAdrx1, writeAdrx, writeData, clk, writeEn);
	output [31:0] rdData0;
	output [31:0] rdData1;
	input [4:0] rdAdrx0;
	input [4:0] rdAdrx1;
	input [4:0] writeAdrx;
	input [31:0] writeData;
	input clk;
	input writeEn;
	
	wire [31:0] writeSel;
	wire [31:0] rdSel0;
	wire [31:0] rdSel1;
	wire [31:0] regResult [0:31];
	wire [31:0] writeEnAndSel;	
	
	decoder writeDecoder (writeSel, writeAdrx, 1'b1);
	decoder readDecoder0 (rdSel0, rdAdrx0, 1'b1);
	decoder readDecoder1 (rdSel1, rdAdrx1, 1'b1);
	
	genvar i;
		generate for (i = 0; i < 32; i = i + 1) begin : reg_gen
			and(writeEnAndSel[i], writeEn, writeSel[i]);
			register myReg (.result(regResult[i][31:0]), .writeEn(writeEnAndSel[i]), .clk(clk),
								 .writeData(writeData));
		end endgenerate

	genvar j;
		generate for (j = 0; j < 32; j = j + 1) begin : mux_gen
			mux32 read0Mux (.out(rdData0[j]), .sel(rdAdrx0),
					 .in({regResult[0][j], regResult[1][j], regResult[2][j], regResult[3][j],
							regResult[4][j], regResult[5][j], regResult[6][j], regResult[7][j],
							regResult[8][j], regResult[9][j], regResult[10][j], regResult[11][j],
							regResult[12][j], regResult[13][j], regResult[14][j], regResult[15][j],
							regResult[16][j], regResult[17][j], regResult[18][j], regResult[19][j],
							regResult[20][j], regResult[21][j], regResult[22][j], regResult[23][j],
							regResult[24][j], regResult[25][j], regResult[26][j], regResult[27][j],
							regResult[28][j], regResult[29][j], regResult[30][j], regResult[31][j]}));
			mux32 read1Mux (.out(rdData1[j]), .sel(rdAdrx1),
					 .in({regResult[0][j], regResult[1][j], regResult[2][j], regResult[3][j],
							regResult[4][j], regResult[5][j], regResult[6][j], regResult[7][j],
							regResult[8][j], regResult[9][j], regResult[10][j], regResult[11][j],
							regResult[12][j], regResult[13][j], regResult[14][j], regResult[15][j],
							regResult[16][j], regResult[17][j], regResult[18][j], regResult[19][j],
							regResult[20][j], regResult[21][j], regResult[22][j], regResult[23][j],
							regResult[24][j], regResult[25][j], regResult[26][j], regResult[27][j],
							regResult[28][j], regResult[29][j], regResult[30][j], regResult[31][j]}));
		end endgenerate
	endmodule