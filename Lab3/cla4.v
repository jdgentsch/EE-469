//Jack Gentsch, Jacky Wang, Chinh Bui
//EE 469, Dr. Peckol 4/15/16
// 32-bit Carry Look Ahead (cla) Adder built using 4-bit clas

module cla4 (sum, Cout, inA, inB, Cin);
	output [3:0] sum;
	output Cout
	//, pG, gG; // propagate and generate group
	input [3:0] inA, inB;
	input Cin;

	wire [3:0] p, g, c; // propagate, generate and carry for adders

	assign p = inA ^ inB;
	assign g = inA & inB;

	// compute carry
	assign c[0] = Cin;

	assign c[1] = g[0] | (p[0] & c[0]);

	assign c[2] = g[1] | (g[0] & p[1]) | (c[0] & p[0] & p[1]);

	assign c[3] = g[2] | (g[1] & p[2]) | (g[0] & p[1] & p[2]) | (c[0] & p[0] & p[1] & p[2]);

	assign Cout = g[3] | (g[2] & p[3]) | (g[1] & p[2] & p[3]) | (g[0] & p[1] & p[2] & p[3]) |
				  (c[0] & p[0] & p[1] & p[2] & p[3]);

	// compute group propagate and generate
	//assign pG = p[0] & (p[1] & p[2] & p[3]);
	//assign gG = g[3] | (g[2] & p[3]) | (g[1] & p[3] & p[2]) | (g[0] & p[3] & p[2] & p[1]);

	// compute sum
	assign sum = p ^ c;

endmodule
