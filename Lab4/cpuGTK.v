//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 4: GTKwave for the CPU
//EE 469 with James Peckol 5/16/16
`include "control.v"
`include "pc.v"
`include "imem.v"
`include "dmem.v"
`include "datapath.v"
`include "../Lab3/resultMux.v"
`include "../Lab3/logicUnit.v"
`include "../Lab3/cla32.v"
`include "../Lab3/alu.v"
`include "../Lab2/registerFile.v"
`include "../Lab2/register.v"
`include "../Lab2/decoder.v"
`include "../Lab2/mux32.v"
`include "cpu.v"
`include "decode.v"
`include "shifter.v"

module cpu_tb ();
	wire loadControl, altProgram;
	wire reset, clk;
	wire [4:0] rfRdAdrx0, rfRdAdrx1, rfWrAdrx;
	wire [2:0] aluCtl;
	wire rfWriteEn, aluBusBSel, dmemResultSel, dmemWrite;
	wire cFlag, nFlag, vFlag, zFlag;
	wire [15:0] dmemOutput, dmemDataIn, immediate;
	wire [10:0] aluResultShort;
	wire regDest;
	wire [8:0] rfRdData0Short, rfRdData0;
	
	//Control module including pc, imem, decoder
	control cpuControl_dut (.rfRdAdrx0(rfRdAdrx0), .rfRdAdrx1(rfRdAdrx1), .rfWrAdrx(rfWrAdrx), .aluCtl(aluCtl), 
							 .rfWriteEn(rfWriteEn), .aluBusBSel(aluBusBSel), .dmemResultSel(dmemResultSel),
							 .immediate(immediate), .regDest(regDest), .rfRdData0(rfRdData0Short), .reset(reset), .clk(clk), 
							 .cFlag(cFlag), .nFlag(nFlag), .vFlag(vFlag), .zFlag(zFlag), .altProgram(altProgram));
	
	//Data memory, a 16 x 2k SRAM
	dmem cpuDataMem_dut (.dataOut(dmemOutput), .clk(clk), .dataIn(dmemDataIn), .adrx(aluResultShort), .write(dmemWrite), .loadControl(loadControl), .reset(reset));

	datapath cpuDatapath_dut (cFlag, nFlag, vFlag, zFlag, dmemDataIn, aluResultShort, rfRdData0Short, clk, immediate, rfRdAdrx0, rfRdAdrx1,
					  rfWrAdrx, aluCtl, rfWriteEn, aluBusBSel, dmemResultSel, dmemOutput, regDest);

	cpu_tester tester (clk, reset, loadControl, altProgram);
	
	initial begin
		$dumpfile ("cpu.vcd");
		$dumpvars (0, cpu_tb);
	end

endmodule

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
module cpu_tester (clk, reset, loadControl, altProgram);
	output reg clk, reset, loadControl, altProgram;
	
	parameter period = 2;
	initial begin
	clk = 0;
	reset = 1;
	loadControl = 0;
	altProgram = 0;
	end
	always begin
		#(period/2);
		clk = !clk;
	end
	
	initial begin
		#(period*5); 	reset = 0;											//program 1, A=7
		#(period*20);	reset = 1; loadControl = 1;
		#period;		reset = 0;											//program 1, A=9
		#(period*25);	reset = 1; loadControl = 0; altProgram = 1;
		#period; 		reset = 0;											//program 2, A=7, loop and halt ?
		#(period*20);	reset = 1; loadControl = 1;
		#period;		reset = 0;											//program 2, A=9
		#(period*20);
		$finish;
	end
endmodule