// A four-stage Johnson counter with active low reset- Counter 3 of EE 469 Lab 1
// Note that this lower level module is the behavioral level model of the counter.

// Written by Jack Gentsch, Jacky Wang, and Chinh Bui
// 4/3/2016 instructed by Professor Peckol

module syncJohn(out, clk, rst);
	output reg [3:0] out; // present state output
	input clk, rst;

	// DFF
	always @(posedge clk)
		if (!rst)
			out <= 4'b0000;	
		else begin
			out[3]  <= ~out[0];
			out[2:0] <= out[3:1];
		end
endmodule
