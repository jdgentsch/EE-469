// Jack Gentsch, Jacky Wang, Chinh Bui
// EE 469, Dr. Peckol 4/15/16
// 32-bit Carry Look Ahead (CLA) Adder built using two 16-bit CLAs
// Dataflow level modeling
module cla32 (sum, Cout, overflow, inA, inB, Cin);
	output [31:0] sum;
	output Cout, overflow;
	input [31:0] inA, inB;
	input Cin;

	wire [1:0] p, g, c; // propagate, generate and carrys passed between CLA modules

	assign c[0] = Cin;

	cla16 cla16_0 (sum[15:0], c[1], inA[15:0], inB[15:0], c[0]);
	cla16 cla16_1 (sum[31:16], Cout, inA[31:16], inB[31:16], c[1]);

	// compute overflow
	// This is incorrect - should be Cout ^ carry_input_to_msb_full_adder
	assign overflow = Cout ^ cla16_1.cla4_3.c[3];

endmodule


// 4-bit CLA
module cla4 (sum, Cout, inA, inB, Cin);
	output [3:0] sum;
	output Cout;
	//pGroup, gGroup;
	input [3:0] inA, inB;
	input Cin;

	wire [3:0] p, g, c; // propagate, generate and carry in for adders
	//wire pGroup, gGroup; // group propagate and generate

	assign p = inA ^ inB;
	assign g = inA & inB;

	// compute carry
	assign c[0] = Cin;
	assign c[1] = g[0] | (p[0] & c[0]);
	assign c[2] = g[1] | (g[0] & p[1]) | (c[0] & p[0] & p[1]);
	assign c[3] = g[2] | (g[1] & p[2]) | (g[0] & p[1] & p[2]) | (c[0] & p[0] & p[1] & p[2]);
	assign Cout = g[3] | (g[2] & p[3]) | (g[1] & p[3] & p[2]) | (g[0] & p[3] & p[2] & p[1]) | (p[0] & p[1] & p[2] & p[3] & c[0]);

	// compute group propagate and generate
	//assign pGroup = p[0] & p[1] & p[2] & p[3];
	//assign gGroup = g[3] | (g[2] & p[3]) | (g[1] & p[3] & p[2]) | (g[0] & p[3] & p[2] & p[1]);

	// compute sum
	assign sum = p ^ c;

endmodule


// stacking four 4-bit CLAs to form 16-bit CLA
module cla16 (sum, Cout, inA, inB, Cin);
	output [15:0] sum;
	output Cout;
	//output pGroup, gGroup;
	input [15:0] inA, inB;
	input Cin;

	wire [3:0] p, g, c; /// propagate, generate and carrys passed between CLA modules

	assign c[0] = Cin;

	cla4 cla4_0 (sum[3:0], c[1], inA[3:0], inB[3:0], c[0]);
	cla4 cla4_1 (sum[7:4], c[2], inA[7:4], inB[7:4], c[1]);
	cla4 cla4_2 (sum[11:8], c[3], inA[11:8], inB[11:8], c[2]);
	cla4 cla4_3 (sum[15:12], Cout, inA[15:12], inB[15:12], c[3]);
 
	//assign pGroup = p[0] & p[1] & p[2] & p[3];
	//assign gGroup = g[3] | (g[2] & p[3]) | (g[1] & p[3] & p[2]) | (g[0] & p[3] & p[2] & p[1]);

endmodule
