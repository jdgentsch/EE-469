//Jack Gentsch, Jacky Wang, Chinh Bui
//EE 469, Dr. Peckol 4/15/16
// 32-bit model of the logical operations unit
module logicUnit (andResult, orResult, xorResult, inA, inB);
	output [31:0] andResult, orResult, xorResult;
	input [31:0] inA, inB;

	assign andResult = inA & inB;
	assign orResult = inA | inB;
	assign xorResult = inA ^ inB;

endmodule