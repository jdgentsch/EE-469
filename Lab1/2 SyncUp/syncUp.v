// A four-stage synchrnous up counter with active low reset- Counter 1 of EE 469 Lab 1
// Note that this lower level module is the dataflow level model of the counter.

// Written by Jack Gentsch, Jacky Wang, and Chinh Bui
// 4/3/2016 instructed by Professor Peckol

module syncUp(q, clk, rst);
	output [3:0] q;
	input clk, rst;
	wire [3:0] d, qb; 

	// Connecting DFFs to form a 4 bit counter
	assign d[3] = (qb[0] & q[3]) | (qb[1] & q[3]) | (qb[2] & q[3]) | (qb[3] & q[2] & q[1] & q[0]);
	DFlipFlop dff3 (q[3], qb[3], d[3], clk, rst);
	
	assign d[2] = (q[2] & qb[0]) | (qb[1] & q[2]) | (qb[2] & q[1] & q[0]);
	DFlipFlop dff2 (q[2], qb[2], d[2], clk, rst);
	
	assign d[1] = q[1] ^ q[0];
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