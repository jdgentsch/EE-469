//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 4: Single cycle cpu
//EE 469 with James Peckol 5/7/16
module cpu(LEDR, SW, CLOCK_50);
	//DE1-SoC wire interface for driving hardware
	output [9:0] LEDR;
	input CLOCK_50;
	input [9:0] SW;

	reg [6:0] pc;
	
	wire [6:0] instruction;
	wire reset;
	wire [4:0] rfRdAdrx0, rfRdAdrx1, rfWrAdrx;
	wire [2:0] aluCtl;
	wire rfRead, aluBusBSel, dmemResultSel;
	wire [15:0] dmemOutput;
	
	assign reset = SW[9];
	
	//Instruction memory, a 32 x 128 SRAM
	imem cpuInstructionMem(.dataOut(instruction), .adrx(pc));
	
	//Data memory, a 16 x 2k SRAM
	dmem cpuDataMem(.dataOut(dmemOutput), .clk(clk), .dataIn(dmemDataIn), .adrx(dmemAdrx), .read(dmemRead));

	datapath cpuDatapath(cFlag, nFlag, vFlag, zFlag, dmemDataIn, dmemAdrx, clk, immData, rfRdAdrx0, rfRdAdrx1,
					  rfWrAdrx, aluCtl, rfRead, aluBusBSel, dmemResultSel, dmemOutput);

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