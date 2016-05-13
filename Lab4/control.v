//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 4: Control system for the cpu
//EE 469 with James Peckol 5/7/16

module control (rfRdAdrx0, rfRdAdrx1, rfWrAdrx, aluCtl, rfWriteEn, aluBusBSel, dmemResultSel,
					dmemWrite, immediate, regDest, rfRdData0, reset, clk,
					cFlag, nFlag, vFlag, zFlag);
	output [4:0] rfRdAdrx0, rfRdAdrx1, rfWrAdrx;
	output [2:0] aluCtl;
	output rfWriteEn, aluBusBSel, dmemResultSel, dmemWrite;
	output [15:0] immediate;
	output regDest;
	input [8:0] rfRdData0; //Data for jump register
	input reset, clk, cFlag, nFlag, vFlag, zFlag;

	reg [31:0] instructionReg;
	wire [31:0] instruction;	
	wire [8:0] pc;
	wire [8:0] pcDest;
	wire [1:0] branchCtl;

	//Program counter and output pc register
	pc myPC(.pc(pc), .nextAdrx(pcDest), .rfRdData0(rfRdData0), .branchCtl(branchCtl), .rst(reset), .clk(clk));
	
	//Instruction memory, a 32 x 128 SRAM
	imem controlInstructionMem(.dataOut(instruction), .adrx(pc[8:2]));
	
	//Instruction decoder using the instruction register
	decode controlDecode(.rfRdAdrx0(rfRdAdrx0), .rfRdAdrx1(rfRdAdrx1), .rfWrAdrx(rfWrAdrx), .aluCtl(aluCtl), 
								.rfWriteEn(rfWriteEn), .aluBusBSel(aluBusBSel), .dmemResultSel(dmemResultSel),
								.dmemWrite(dmemWrite), .branchCtl(branchCtl), .regDest(regDest),
								.immediate(immediate), .pcDest(pcDest), .instruction(instructionReg),
								.cFlag(cFlag), .nFlag(nFlag), .vFlag(vFlag), .zFlag(zFlag));

	//Update status of the instruction register
	always @(posedge clk) begin
		instructionReg <= instruction;
	end

endmodule