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
		generate for (i = 0; i < 32; i = i + 1) begin : regs_gen
			and(writeEnAndSel[i], writeEn, writeSel[i]);
			register myReg (.result(regResult[i]), .writeEn(writeEnAndSel[i]), .clk(clk),
								 .writeData(writeData));
			mux32 read0Mux (.out(rdData0[i]), .sel(rdAdrx0), .in(regResult[i]));
			mux32 read1Mux (.out(rdData1[i]), .sel(rdAdrx1), .in(regResult[i]));
		end endgenerate


	
	
	endmodule