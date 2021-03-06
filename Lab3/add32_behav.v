//Jack Gentsch, Jacky Wang, Chinh Bui
//EE 469, Dr. Peckol 4/15/16
// 32-bit behavioral model of the 32-bit Adder
module add32_behav (sum, Cout, oveflow, inA, inB, Cin);
	output [31:0] sum;
	output Cout, overflow;
	input [31:0] inA, inB;
	input Cin;
	
	assign {Cout, sum[31:0]} = inA + inB + Cin;
	assign overflow = (inA[31] & inB[31] & ~sum[31]) | (~inA[31] & ~inB[31] & sum[31]);
endmodule