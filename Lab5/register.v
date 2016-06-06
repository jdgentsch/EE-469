//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 2: Individual register module for our memory subsystem
//EE 469 with James Peckol 4/8/16
module register (result, writeEn, clk, writeData);
	output [31:0] result;
	input writeEn, clk;
	input [31:0] writeData;
	
	wire [31:0] enabledData;
	
	// Instantiation of 32 flip-flops for the register
	genvar i;
		generate for (i = 0; i < 32; i = i + 1) begin : reg_bits_gen
			//Input to the register is dependent on write enable
			assign enabledData[i] = writeEn ? writeData[i] : result[i];
			//mux2 rf_input_sel (enabledData[i], writeEn, {writeData[i], result[i]});
			//bufif1(enabledData[i], writeData[i], writeEn);
			//bufif0(enabledData[i], result[i], writeEn);
			DFlipFlop reg_bit (result[i], clk, enabledData[i]);
		end endgenerate
endmodule

// A simple DFF module
module DFlipFlop (out, clk, in);
	output reg out;
	input in;
	input clk;

	always @(negedge clk)
		out <= in;
endmodule