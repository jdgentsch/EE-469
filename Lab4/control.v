//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 4: Control system for the cpu
//EE 469 with James Peckol 5/7/16

module control (rfRdAdrx0, rfRdAdrx1, rfWrAdrx, aluCtl, rfWriteEn, aluBusBSel, dmemResultSel,
					branch, jump, immediate);
	//(regDest, jump, branch, memRead, mem2Reg, aluCtl, memWrite, aluSrc, regWrite, instruction, aluResult);
	//output regDest, jump, branch, memRead, mem2Reg, memWrite, aluSrc, regWrite;
	output [4:0] rfRdAdrx0, rfRdAdrx1, rfWrAdrx;
	output [2:0] aluCtl;
	output rfWriteEn, aluBusBSel, dmemResultSel, branch, jump;
	output [15:0] immediate;
	input [31:0] instruction;
	input [31:0] aluResult;
	
	wire [8:0] pc;
	wire [8:0] pcDest;

	pc myPC(.pc(pc), .branchAdrx(pcDest), .branch(branch), .jump(jump), .rst(rst), .clk(clk));
	
	//Instruction memory, a 32 x 128 SRAM
	imem controlInstructionMem(.dataOut(instruction), .adrx(pc[8:2]));
	
	decode controlDecode(rfRdAdrx0, rfRdAdrx1, rfWrAdrx, aluCtl, rfWriteEn, aluBusBSel, dmemResultSel,
					branch, jump, immediate, pcDest, instruction, aluResult);


endmodule