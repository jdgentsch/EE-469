// EE 371
// Coders: Beck Pang, Jack Gentsch, Jacky Wang
// Autumn 2015
// Lab 1

// A four stage (4 bit) synchronous down counter, with
// active low reset, using a dataflow level model and
// the D flip-flop model given in part 1.

module syncDown(q, clk, rst);
	output [3:0] q;
	input clk, rst;
	wire [3:0] d, qb; 

	// Connecting DFFs to form a 4 bit counter
	assign d[3] = (q[3] & q[2]) | (q[3] & q[0]) | (q[3] & q[1]) | (qb[3] & qb[2] & qb[1] & qb[0]);
	DFlipFlop dff3 (q[3], qb[3], d[3], clk, rst);
	
	assign d[2] = (q[2] & q[0]) | (q[1] & q[2]) | (qb[2] & qb[1] & qb[0]);
	DFlipFlop dff2 (q[2], qb[2], d[2], clk, rst);
	
	assign d[1] = q[1] ~^ q[0];
	DFlipFlop dff1 (q[1], qb[1], d[1], clk, rst);
	
	assign d[0] = qb[0];
	DFlipFlop dff0 (q[0], qb[0], d[0], clk, rst);

endmodule

// DFF
module DFlipFlop(q, qBar, D, clk, rst);
	input D, clk, rst;
	output q, qBar;
	reg q;
	not n1 (qBar, q);
		always@ (negedge rst or posedge clk)
		begin
			if(!rst)
				q = 0;
			else
				q = D;
		end
endmodule