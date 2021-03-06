//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 5: Single cycle cpu
//EE 469 with James Peckol 5/25/16
//A single-cycle pipelined cpu for usage on the DE1-SoC
module pipeCpu(LEDR, SW, CLOCK_50);
	//DE1-SoC wire interface for driving hardware
	output [9:0] LEDR;
	input CLOCK_50;
	input [9:0] SW;
	
	wire reset, clk;
	wire [4:0] decodeRfRdAdrx0, decodeRfRdAdrx1, decodeRfWrAdrx;
	wire [2:0] decodeAluCtl;
	wire decodeRfWriteEn, decodeAluBusBSel, decodeDmemResultSel, decodeDmemWrite;
	wire execCFlag, execNFlag, execVFlag, execZFlag;
	wire [15:0] dmemOutput, dmemDataIn, decodeImmediate;
	wire [10:0] aluResultShort;
	wire decodeRegDest;
	wire [8:0] execRfRdData0Short;
	wire doBranch3Held;
	wire icacheStallPC;
	wire [8:0] pc;
	wire [127:0] imemInstructions;
	wire [31:0] icacheInstruction;
	wire altProgram;
	
	reg execDmemWrite;
	reg [15:0] execDmemDataIn;
	
	assign reset = SW[9];
	assign altProgram = SW[6];
	
	//Control module including pc, imem, decoder
	control cpuControl(.decodeRfRdAdrx0(decodeRfRdAdrx0), .decodeRfRdAdrx1(decodeRfRdAdrx1), .decodeRfWrAdrx(decodeRfWrAdrx), .decodeAluCtl(decodeAluCtl), 
							 .decodeRfWriteEn(decodeRfWriteEn), .decodeAluBusBSel(decodeAluBusBSel), .decodeDmemResultSel(decodeDmemResultSel),
							 .decodeDmemWrite(decodeDmemWrite), .decodeImmediate(decodeImmediate), .decodeRegDest(decodeRegDest), 
							 .pc(pc), .doBranch3Held(doBranch3Held), .execRfRdData0Short(execRfRdData0Short), .reset(reset), .clk(clk), 
							 .execZFlag(execZFlag), .altProgram(altProgram), .icacheStallPC(icacheStallPC), .instruction(icacheInstruction));
	
	//Data memory, a 16 x 2k SRAM
	dmem cpuDataMem(.dataOut(dmemOutput), .clk(clk), .execDataIn(execDmemDataIn), .readAdrx(aluResultShort),
						 .execWrite(execDmemWrite & ~doBranch3Held), .loadControl(SW[7]), .reset(reset));

	//Instruction memory, a 32 x 128 SRAM
	imem cpuImem(.dataOut(imemInstructions), .adrx(pc[8:2]), .clk(clk), .reset(reset), .altProgram(altProgram));
	
	//A 4-block, 4 words per block instruction cache
	icache controlInstructionCache(.instructionOut(icacheInstruction), .stallPC(icacheStallPC), .adrx(pc[8:2]),
											 .clk(clk), .reset(reset), .imemInstructions(imemInstructions));

	pipeDatapath cpuDatapath(.execCFlag(execCFlag), .execNFlag(execNFlag), .execVFlag(execVFlag), .execZFlag(execZFlag),
									 .dmemDataIn(dmemDataIn), .aluResultShort(aluResultShort),
									 .execRfRdData0Short(execRfRdData0Short), .clk(clk), .decodeImmediate(decodeImmediate),
									 .decodeRfRdAdrx0(decodeRfRdAdrx0), .decodeRfRdAdrx1(decodeRfRdAdrx1),
									 .decodeRfWrAdrx(decodeRfWrAdrx), .decodeAluCtl(decodeAluCtl),
									 .decodeRfWriteEn(decodeRfWriteEn), .decodeAluBusBSel(decodeAluBusBSel),
									 .decodeDmemResultSel(decodeDmemResultSel), .dmemOutput(dmemOutput), .decodeRegDest(decodeRegDest),
									 .doBranch3Held(doBranch3Held));

	clock_divider cdiv (.clk_out(clk), .clk_in(CLOCK_50), .slowDown(SW[8]));
	
	always @(posedge clk) begin
		execDmemWrite <= decodeDmemWrite;
		execDmemDataIn <= dmemDataIn;
	end
	
endmodule

// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...
module clock_divider (clk_out, clk_in, slowDown);
	output clk_out;
	reg [31:0] divided_clocks;
	input clk_in, slowDown;
	
	//Choose clock frequency for signal tap display or LED display
	assign clk_out = slowDown ? divided_clocks[1] : clk_in;
	
	initial
		divided_clocks = 0;
	
	always @(posedge clk_in)
		divided_clocks = divided_clocks + 1;
		
endmodule