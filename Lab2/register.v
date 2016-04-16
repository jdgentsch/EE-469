module register (result, writeEn, clk, writeData);
	output [31:0] result;
	input writeEn, clk;
	input [31:0] writeData;
	
	wire [31:0] enabledData;
	
	// Instantiation of 32 flip-flops for the register
	genvar i;
		generate for (i = 0; i < 32; i = i + 1) begin : reg_bits_gen
			bufif1(enabledData[i], writeData[i], writeEn);
			bufif0(enabledData[i], result[i], writeEn);
			DFlipFlop reg_bit (result[i], clk, enabledData[i]);
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