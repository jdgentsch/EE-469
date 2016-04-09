module register (result, writeEn, writeSel, writeData);
	output [31:0] result;
	input writeEn;
	input [31:0] writeSel;
	input [31:0] writeData;

	wire writeClk;
	assign writeClk[0] = writeEn & writeSel[0];

	dff bit0 (result[0], writeClk, writeData[0]);

endmodule

module dff (out, clk, in);
	output reg out;
	input in;
	input clk;

	always @(posedge clk)
		out <= in;
endmodule