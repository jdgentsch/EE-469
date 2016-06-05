//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 5: Control system for the cpu
//EE 469 with James Peckol 5/25/16
//Control module for the single-cycle pipelined cpu
module control (decodeRfRdAdrx0, decodeRfRdAdrx1, decodeRfWrAdrx, decodeAluCtl,
					 decodeRfWriteEn, decodeAluBusBSel, decodeDmemResultSel,
					 decodeDmemWrite, decodeImmediate, decodeRegDest, doBranch3Held, execRfRdData0Short, reset, clk,
					 execZFlag, altProgram);
	output reg [4:0] decodeRfRdAdrx0, decodeRfRdAdrx1, decodeRfWrAdrx;
	output reg [2:0] decodeAluCtl;
	output reg decodeRfWriteEn, decodeAluBusBSel, decodeDmemResultSel, decodeDmemWrite;
	output reg [15:0] decodeImmediate;
	output reg decodeRegDest;
	output doBranch3Held; //Forwarding logic to wb stage to determine if a branch is occuring, and data is to be ignored
	input [8:0] execRfRdData0Short; //Data for jump register
	input reset, clk, execZFlag;
	input altProgram;
	
	reg [31:0] fetchInstructionReg;
	reg [8:0] wbRfRdData0Short;
	reg [15:0] execImmediate, wbImmediate;
	reg [1:0] decodeBranchCtl, execBranchCtl, wbBranchCtl;
	reg wbZFlag;
	
	//Inputs to decode stage register bank
	wire [4:0] rfRdAdrx0, rfRdAdrx1, rfWrAdrx;
	wire [2:0] aluCtl;
	wire rfWriteEn, aluBusBSel, dmemResultSel, dmemWrite;
	wire [15:0] immediate;
	wire regDest;

	wire [31:0] instruction;	
	wire [8:0] pc;
	wire [8:0] nextAdrx;
	wire [1:0] branchCtl;
	wire halt;
	wire icacheStallPC;
	wire doBranch;

	//Program counter, with input branching control signals, and output pc register
	pc myPC(.pc(pc), .nextAdrx(nextAdrx), .doBranch(doBranch), .rst(reset), .clk(clk), .halt(halt | icacheStallPC));
	
	//Instruction memory, a 32 x 128 SRAM
	icache controlInstructionCache(.dataOut(instruction), .stallPC(icacheStallPC), .adrx(pc[8:2]),
											 .clk(clk), .reset(reset), .altProgram(altProgram));
	
	//Instruction decoder using the instruction register
	decode controlDecode(.rfRdAdrx0(rfRdAdrx0), .rfRdAdrx1(rfRdAdrx1), .rfWrAdrx(rfWrAdrx), .aluCtl(aluCtl), 
								.rfWriteEn(rfWriteEn), .aluBusBSel(aluBusBSel), .dmemResultSel(dmemResultSel),
								.dmemWrite(dmemWrite), .branchCtl(branchCtl), .regDest(regDest), .halt(halt),
								.immediate(immediate), .instruction(fetchInstructionReg));

	//Next stage, updates the PC based on a jump, jump reg, or conditional branch
	next controlNextStage(.doBranch(doBranch), .nextAdrx(nextAdrx), .wbBranchCtl(wbBranchCtl), .wbRfRdData0(wbRfRdData0Short),
								 .wbImmediate(wbImmediate), .wbZFlag(wbZFlag), .clk(clk), .reset(reset));
	
	holdBranchSignal myBranchHolder(.doBranch3Held(doBranch3Held), .doBranch(doBranch), .clk(clk), .reset(reset));
	
	//Update status of the instruction register
	always @(posedge clk) begin
		fetchInstructionReg <= instruction;
		decodeRfRdAdrx0 <= rfRdAdrx0;
		decodeRfRdAdrx1 <= rfRdAdrx1;
		decodeRfWrAdrx <= rfWrAdrx;
		decodeAluCtl <= aluCtl;
		decodeAluBusBSel <= aluBusBSel;
		decodeDmemResultSel <= dmemResultSel;
		decodeRfWriteEn <= rfWriteEn;
		decodeDmemWrite <= dmemWrite;
		decodeRegDest <= regDest;
		//branchCtl passing to next stage
		decodeBranchCtl <= branchCtl;
		execBranchCtl <= decodeBranchCtl;
		wbBranchCtl <= execBranchCtl;
		//
		//Immediate passing to next stage
		decodeImmediate <= immediate;
		execImmediate <= decodeImmediate;
		wbImmediate <= execImmediate;
		//
		wbZFlag <= execZFlag;
		wbRfRdData0Short <= execRfRdData0Short;
	end
endmodule

module holdBranchSignal(doBranch3Held, doBranch, clk, reset);

	output doBranch3Held;
	input doBranch;
	input clk, reset;

	reg [1:0] holdBranch;
	
	assign doBranch3Held = holdBranch[1] | holdBranch[0] | doBranch;
	
	//4 stages in our pipeline have been calculated to have invalid data if doBranch is true
	//Thus we must pass along a signal to disable writing for the duration of these 4 cycles
	always @(posedge clk) begin
		if (reset) begin
			holdBranch <= 2'b0;
		end else begin
			holdBranch[0] <= doBranch;
			holdBranch[1] <= holdBranch[0];
		end
	end

endmodule
