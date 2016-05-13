//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 4: Single cycle cpu
//EE 469 with James Peckol 5/7/16
module cpu(LEDR, SW, CLOCK_50);
	//DE1-SoC wire interface for driving hardware
	output [9:0] LEDR;
	input CLOCK_50;
	input [9:0] SW;
	
	wire reset, clk;
	wire [4:0] rfRdAdrx0, rfRdAdrx1, rfWrAdrx;
	wire [2:0] aluCtl;
	wire rfWriteEn, aluBusBSel, dmemResultSel, dmemWrite;
	wire cFlag, nFlag, vFlag, zFlag;
	wire [15:0] dmemOutput, dmemDataIn, immediate;
	wire [10:0] aluResultShort;
	wire regDest;
	wire [8:0] rfRdData0Short;
	
	reg cFlagReg, nFlagReg, vFlagReg, zFlagReg;
	assign reset = SW[9];
	
	control cpuControl(.rfRdAdrx0(rfRdAdrx0), .rfRdAdrx1(rfRdAdrx1), .rfWrAdrx(rfWrAdrx), .aluCtl(aluCtl), 
							 .rfWriteEn(rfWriteEn), .aluBusBSel(aluBusBSel), .dmemResultSel(dmemResultSel),
							 .immediate(immediate), .regDest(regDest), .rfRdData0(rfRdData0Short), .reset(reset), .clk(clk), 
							 .cFlag(cFlag), .nFlag(nFlag), .vFlag(vFlag), .zFlag(zFlag));
	
	//Data memory, a 16 x 2k SRAM
	dmem cpuDataMem(.dataOut(dmemOutput), .clk(clk), .dataIn(dmemDataIn), .adrx(aluResultShort), .write(dmemWrite));

	datapath cpuDatapath(cFlag, nFlag, vFlag, zFlag, dmemDataIn, aluResultShort, rfRdData0Short, clk, immediate, rfRdAdrx0, rfRdAdrx1,
					  rfWrAdrx, aluCtl, rfWriteEn, aluBusBSel, dmemResultSel, dmemOutput, regDest);

	clock_divider cdiv (.clk_out(clk), .clk_in(CLOCK_50), .slowDown(SW[8]));

	//Flag registers -- CURRENTLY UNUSED will be needed in pipelined datapath...
	always @(posedge clk) begin
		cFlagReg <= cFlag;
		nFlagReg <= nFlag;
		vFlagReg <= vFlag;
		zFlagReg <= zFlag;
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