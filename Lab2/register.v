module register (result, writeEn, writeSel, writeData);
	output [31:0] result;
	input writeEn;
	input [31:0] writeSel;
	input [31:0] writeData;
	
	wire [31:0] writeClk;
	assign writeClk[31:0] = {32{writeEn}} & writeSel[31:0];
	
	DFlipFlop bit0 (result[0], writeClk[0], writeData[0]);
	DFlipFlop bit1 (result[1], writeClk[1], writeData[1]);
	DFlipFlop bit2 (result[2], writeClk[2], writeData[2]);
	DFlipFlop bit3 (result[3], writeClk[3], writeData[3]);
	DFlipFlop bit4 (result[4], writeClk[4], writeData[4]);
	DFlipFlop bit5 (result[5], writeClk[5], writeData[5]);
	DFlipFlop bit6 (result[6], writeClk[6], writeData[6]);
	DFlipFlop bit7 (result[7], writeClk[7], writeData[7]);
	DFlipFlop bit8 (result[8], writeClk[8], writeData[8]);
	DFlipFlop bit9 (result[9], writeClk[9], writeData[9]);
	DFlipFlop bit10 (result[10], writeClk[10], writeData[10]);
	DFlipFlop bit11 (result[11], writeClk[11], writeData[11]);
	DFlipFlop bit12 (result[12], writeClk[12], writeData[12]);
	DFlipFlop bit13 (result[13], writeClk[13], writeData[13]);
	DFlipFlop bit14 (result[14], writeClk[14], writeData[14]);
	DFlipFlop bit15 (result[15], writeClk[15], writeData[15]);
	DFlipFlop bit16 (result[16], writeClk[16], writeData[16]);
	DFlipFlop bit17 (result[17], writeClk[17], writeData[17]);
	DFlipFlop bit18 (result[18], writeClk[18], writeData[18]);
	DFlipFlop bit19 (result[19], writeClk[19], writeData[19]);
	DFlipFlop bit20 (result[20], writeClk[20], writeData[20]);
	DFlipFlop bit21 (result[21], writeClk[21], writeData[21]);
	DFlipFlop bit22 (result[22], writeClk[22], writeData[22]);
	DFlipFlop bit23 (result[23], writeClk[23], writeData[23]);
	DFlipFlop bit24 (result[24], writeClk[24], writeData[24]);
	DFlipFlop bit25 (result[25], writeClk[25], writeData[25]);
	DFlipFlop bit26 (result[26], writeClk[26], writeData[26]);
	DFlipFlop bit27 (result[27], writeClk[27], writeData[27]);
	DFlipFlop bit28 (result[28], writeClk[28], writeData[28]);
	DFlipFlop bit29 (result[29], writeClk[29], writeData[29]);
	DFlipFlop bit30 (result[30], writeClk[30], writeData[30]);
	DFlipFlop bit31 (result[31], writeClk[31], writeData[31]);

endmodule

module DFlipFlop (out, clk, in);
	output reg out;
	input in;
	input clk;

	always @(posedge clk)
		out <= in;
endmodule