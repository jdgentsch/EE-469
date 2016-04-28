//Jack Gentsch, Jacky Wang, Chinh Bui
//EE 469, Dr. Peckol 4/15/16
// 32-bit Carry Look Ahead (cla) Adder built using 4-bit clas
module cla32 (sum, Cout, inA, inB, Cin);
	output [31:0] sum;
	output Cout;
	input [31:0] inA, inB;
	input Cin;

	wire [7:0] c; // carry in

	assign c[0] = Cin;

	// staking 8 4-bit clas to form 32-bit clas
	cla4 cla4_7 (sum[31:28], Cout, inA[31:28], inB[31:28], c[7]);
	cla4 cla4_6 (sum[27:24], c[7], inA[27:24], inB[27:24], c[6]);
	cla4 cla4_5 (sum[23:20], c[6], inA[23:20], inB[23:20], c[5]);
	cla4 cla4_4 (sum[19:16], c[5], inA[19:16], inB[19:16], c[4]);
	cla4 cla4_3 (sum[15:12], c[4], inA[15:12], inB[15:12], c[3]);
	cla4 cla4_2 (sum[11:8], c[3], inA[11:8], inB[11:8], c[2]);
	cla4 cla4_1 (sum[7:4], c[2], inA[7:4], inB[7:4], c[1]);
	cla4 cla4_0 (sum[3:0], c[1], inA[3:0], inB[3:0], c[0]);

endmodule

// 4-bit cla
module cla4 (sum, Cout, inA, inB, Cin);
	output [3:0] sum;
	output Cout;
	//, pG, gG; // propagate and generate group
	input [3:0] inA, inB;
	input Cin;

	wire [3:0] p, g, c; // propagate, generate and carry in for adders

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
