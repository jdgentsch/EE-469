//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 4: Control system for the cpu
//EE 469 with James Peckol 5/7/16
//Control module for the single-cycle cpu
module control (decodeRfRdAdrx0, decodeRfRdAdrx1, decodeRfWrAdrx, decodeAluCtl,
					 decodeRfWriteEn, decodeAluBusBSel, decodeDmemResultSel,
					 decodeDmemWrite, decodeImmediate, decodeRegDest, execRfRdData0Short, reset, clk,
					 execCFlag, execNFlag, execVFlag, execZFlag, altProgram);
	output reg [4:0] decodeRfRdAdrx0, decodeRfRdAdrx1, decodeRfWrAdrx;
	output reg [3:0] decodeAluCtl;
	output reg decodeRfWriteEn, decodeAluBusBSel, decodeDmemResultSel, decodeDmemWrite;
	output reg [15:0] decodeImmediate;
	output reg decodeRegDest;
	input [8:0] execRfRdData0Short; //Data for jump register
	input reset, clk, execCFlag, execNFlag, execVFlag, execZFlag;
	input altProgram;
	
	reg [31:0] fetchInstructionReg;
	reg [8:0] wbRfRdData0Short;
	
	//Inputs to decode stage register bank
	wire [4:0] rfRdAdrx0, rfRdAdrx1, rfWrAdrx;
	wire [2:0] aluCtl;
	wire rfWriteEn, aluBusBSel, dmemResultSel, dmemWrite;
	wire [15:0] immediate;
	wire regDest;

	wire [31:0] instruction;	
	wire [8:0] pc;
	wire [8:0] pcDest;
	wire [1:0] branchCtl;
	wire halt;

	//Program counter, with input branching control signals, and output pc register
	pc myPC(.pc(pc), .nextAdrx(pcDest), .rfRdData0(wbRfRdData0Short), .branchCtl(branchCtl), .rst(reset), .clk(clk), .halt(halt));
	
	//Instruction memory, a 32 x 128 SRAM
	imem controlInstructionMem(.dataOut(instruction), .adrx(pc[8:2]), .clk(clk), .reset(reset), .altProgram(altProgram));
	
	//Instruction decoder using the instruction register
	decode controlDecode(.rfRdAdrx0(rfRdAdrx0), .rfRdAdrx1(rfRdAdrx1), .rfWrAdrx(rfWrAdrx), .aluCtl(aluCtl), 
								.rfWriteEn(rfWriteEn), .aluBusBSel(aluBusBSel), .dmemResultSel(dmemResultSel),
								.dmemWrite(dmemWrite), .branchCtl(branchCtl), .regDest(regDest), .halt(halt),
								.immediate(immediate), .pcDest(pcDest), .instruction(fetchInstructionReg),
								.cFlag(execCFlag), .nFlag(execNFlag), .vFlag(execVFlag), .zFlag(execZFlag));

	//Update status of the instruction register
	always @(posedge clk) begin
		fetchInstructionReg <= instruction;
		decodeRfRdAdrx0 <= rfRdAdrx0;
		decodeRfRdAdrx1 <= rfRdAdrx1;
		decodeRfWrAdrx <= rfWrAdrx;
		decodeAluCtl <= aluCtl;
		decodeRfWriteEn <= rfWriteEn;
		decodeAluBusBSel <= aluBusBSel;
		decodeDmemResultSel <= dmemResultSel;
		decodeDmemWrite <= dmemWrite;
		//decodeBranchCtl <= branchCtl; Input to PC
		decodeRegDest <= regDest;
		//decodeHalt <= halt; Input to PC
		decodeImmediate <= immediate;
		//decodePcDest <= pcDest; Input to PC
		wbRfRdData0Short <= execRfRdData0Short;
	end

endmodule