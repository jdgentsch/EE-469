//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 4: Single cycle cpu
//EE 469 with James Peckol 5/7/16
//A single-cycle cpu for usage on the DE1-SoC
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
	
	assign reset = SW[9];
	
	//Control module including pc, imem, decoder
	control cpuControl(.decodeRfRdAdrx0(decodeRfRdAdrx0), .decodeRfRdAdrx1(decodeRfRdAdrx1), .decodeRfWrAdrx(decodeRfWrAdrx), .decodeAluCtl(decodeAluCtl), 
							 .decodeRfWriteEn(decodeRfWriteEn), .decodeAluBusBSel(decodeAluBusBSel), .decodeDmemResultSel(decodeDmemResultSel),
							 .decodeDmemWrite(decodeDmemWrite), .decodeImmediate(decodeImmediate), .decodeRegDest(decodeRegDest), 
							 .execRfRdData0Short(execRfRdData0Short), .reset(reset), .clk(clk), 
							 .execZFlag(execZFlag), .altProgram(SW[6]));
	
	//Data memory, a 16 x 2k SRAM
	dmem cpuDataMem(.dataOut(dmemOutput), .clk(clk), .dataIn(dmemDataIn), .adrx(aluResultShort),
						 .write(decodeDmemWrite), .loadControl(SW[7]), .reset(reset));

	pipeDatapath cpuDatapath(.execCFlag(execCFlag), .execNFlag(execNFlag), .execVFlag(execVFlag), .execZFlag(execZFlag),
									 .dmemDataIn(dmemDataIn), .aluResultShort(aluResultShort),
									 .execRfRdData0Short(execRfRdData0Short), .clk(clk), .decodeImmediate(decodeImmediate),
									 .decodeRfRdAdrx0(decodeRfRdAdrx0), .decodeRfRdAdrx1(decodeRfRdAdrx1),
									 .decodeRfWrAdrx(decodeRfWrAdrx), .decodeAluCtl(decodeAluCtl),
									 .decodeRfWriteEn(decodeRfWriteEn), .decodeAluBusBSel(decodeAluBusBSel),
									 .decodeDmemResultSel(decodeDmemResultSel), .dmemOutput(dmemOutput), .decodeRegDest(decodeRegDest));

	clock_divider cdiv (.clk_out(clk), .clk_in(CLOCK_50), .slowDown(SW[8]));
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