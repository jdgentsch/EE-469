//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 4: Control system for the cpu
//EE 469 with James Peckol 5/7/16

module control (regDest, jump, branch, memRead, mem2Reg, aluOp, memWrite, aluSrc, regWrite, instruction);
	output regDest, jump, branch, memRead, mem2Reg, memWrite, aluSrc, regWrite;
	output [3:0] aluOp;
	input [31:0] instruction;

	

endmodule