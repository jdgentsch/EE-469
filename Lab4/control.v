//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 4: Control system for the cpu
//EE 469 with James Peckol 5/7/16

module control (rfRdAdrx0, rfRdAdrx1, rfWrAdrx, aluCtl, rfWriteEn, aluBusBSel, dmemResultSel,
					dmemRead, dmemWrite, branch, jump, immediate, regDest, aluResult, reset, clk);
	output [4:0] rfRdAdrx0, rfRdAdrx1, rfWrAdrx;
	output [2:0] aluCtl;
	output rfWriteEn, aluBusBSel, dmemResultSel, dmemRead, dmemWrite, branch, jump;
	output [15:0] immediate;
	output regDest;
	input [31:0] aluResult;
	input reset, clk;

	wire [31:0] instruction;	
	wire [8:0] pc;
	wire [8:0] pcDest;

	pc myPC(.pc(pc), .nextAdrx(pcDest), .branch(branch), .jump(jump), .rst(reset), .clk(clk));
	
	//Instruction memory, a 32 x 128 SRAM
	imem controlInstructionMem(.dataOut(instruction), .adrx(pc[8:2]));
	
	decode controlDecode(rfRdAdrx0, rfRdAdrx1, rfWrAdrx, aluCtl, rfWriteEn, aluBusBSel, dmemResultSel,
						 dmemRead, dmemWrite, branch, jump, regDest, immediate, pcDest, instruction, aluResult);


endmodule