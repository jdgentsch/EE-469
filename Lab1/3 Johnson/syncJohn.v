// EE 469
// Coders: Chinh Bui, Jack Gentsch, Jacky Wang
// Spring 2016
// Lab 1

// A four stage (4 bit) synchronous Johnson counter,
// with active low reset, using a behavioural level
// model.

module syncJohn(out, clk, rst);
	output reg [3:0] out; // present state output
	input clk, rst;

	reg [3:0] ns; // next state output

	always @(*)
	begin
		ns[3] = ~out[0];
		ns[2:0] = out[3:1];
	end

	// DFF
	always @(posedge clk)
		if (!rst)
			out <= 4'b0000;	
		else
			out <= ns;

endmodule
