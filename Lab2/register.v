module register (readLine0, readLine1, writeEn, clk, rdSel0, rdSel1, writeData);
	output [31:0] readLine0, readLine1;
	input writeEn, clk;
	input rdSel0, rdSel1;
	input [31:0] writeData;
	
	wire writeClk;
	wire [31:0] result;
	
	// Tristate devices driving the two output read bitlines
	assign readLine0 = rdSel0 ? result : 32'bz;
	assign readLine1 = rdSel1 ? result : 32'bz;
	
	//And the enable and clock signal to determine exactly when a write occurs
	assign writeClk = writeEn & clk;
	
	// Instantiation of 32 flip-flops for the register
	genvar i;
		generate for (i = 0; i < 32; i = i + 1) begin : reg_bits_gen
			DFlipFlop reg_bit (result[i], writeClk, writeData[i]);
		end endgenerate

endmodule

// A simple DFF module
module DFlipFlop (out, clk, in);
	output reg out;
	input in;
	input clk;

	always @(posedge clk)
		out <= in;
endmodule