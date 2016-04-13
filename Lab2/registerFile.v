module registerFile (rdData0, rdData1, rdAddr0, rdAddr1, writeAddr, writeData, clk, writeEn);
	output [31:0] rdData0;
	output [31:0] rdData1;
	input [31:0] rdAddr0;
	input [31:0] rdAddr1;
	input [31:0] writeAddr;
	input [31:0] writeData;
	input clk;
	input writeEn;
	
	wire [31:0] writeSel;
	wire [31:0] rdSel0;
	wire [31:0] rdSel1;
	
	decoder writeDecoder (writeSel, writeAddr, 1'b1);
	decoder readDecoder0 (rdSel0, rdAddr0, 1'b1);
	decoder readDecoder1 (rdSel1, rdAddr1, 1'b1);
	
	genvar i;
		generate for (i = 0; i < 32; i = i + 1) begin : regs_gen
			register myReg (.readLine0(rdData0), .readLine1(rdData1), .writeEn(writeEn & writeSel[i]), .clk(clk),
								 .rdSel0(rdSel0[i]), .rdSel1(rdSel1[i]), .writeData(writeData));
		end endgenerate

endmodule