`timescale 1ns/100ps
//`include "decoder.v"

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
module decoder_tb();

	wire wr_en;
	wire [4:0] wr_adrx;
	wire [31:0] wr_word;

	//declare instances of dut and tester modules
	decoder dut (.word(wr_word), .adrx(wr_adrx), en(wr_en), );	// dut (in, in, out)
	decoder_tester test0 (wr_adrx, wr_en, wr_word);				// tester0 (out, out, in)

	//creating simulation file
	initial begin
		$dumpfile ("decoder.vcd");
		$dumpvars (1, dut);
	end

endmodule

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
module decoder_tester(wr_adrx, wr_en, wr_word);				// port types by order: out, out, in

	output reg [4:0] wr_adrx;
	output reg wr_en;
	input [31:0] wr_word;

	// begin sending stimulus
	// sending address from location 1 to 31
	initial begin
		#10 wr_en = 0; wr_adrx = 5'b00001;
		#10 wr_en = 1; wr_adrx = 5'b00001;
		#10 wr_en = 1; wr_adrx = 5'b00010;
		#10 wr_en = 1; wr_adrx = 5'b00011;
		#10 wr_en = 1; wr_adrx = 5'b00100;
		#10 wr_en = 1; wr_adrx = 5'b00101;
		#10 wr_en = 1; wr_adrx = 5'b00110;
		#10 wr_en = 1; wr_adrx = 5'b00111;
		#10 wr_en = 1; wr_adrx = 5'b01000;
		#10 wr_en = 1; wr_adrx = 5'b01001;
		#10 wr_en = 1; wr_adrx = 5'b01010;
		#10 wr_en = 1; wr_adrx = 5'b01011;
		#10 wr_en = 1; wr_adrx = 5'b01100;
		#10 wr_en = 1; wr_adrx = 5'b01101;
		#10 wr_en = 1; wr_adrx = 5'b01110;
		#10 wr_en = 1; wr_adrx = 5'b01111;
		#10 wr_en = 1; wr_adrx = 5'b10000;
		#10 wr_en = 1; wr_adrx = 5'b10001;
		#10 wr_en = 1; wr_adrx = 5'b10010;
		#10 wr_en = 1; wr_adrx = 5'b10011;
		#10 wr_en = 1; wr_adrx = 5'b10100;
		#10 wr_en = 1; wr_adrx = 5'b10101;
		#10 wr_en = 1; wr_adrx = 5'b10110;
		#10 wr_en = 1; wr_adrx = 5'b10111;
		#10 wr_en = 1; wr_adrx = 5'b11000;
		#10 wr_en = 1; wr_adrx = 5'b11001;
		#10 wr_en = 1; wr_adrx = 5'b11010;
		#10 wr_en = 1; wr_adrx = 5'b11011;
		#10 wr_en = 1; wr_adrx = 5'b11100;
		#10 wr_en = 1; wr_adrx = 5'b11101;
		#10 wr_en = 1; wr_adrx = 5'b11110;
		#10 wr_en = 1; wr_adrx = 5'b11111;
		#10
		$finish;
	end
endmodule
