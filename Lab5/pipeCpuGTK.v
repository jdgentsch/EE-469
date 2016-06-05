//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 5: GTKwave for the Pipelined CPU
//EE 469 with James Peckol 6/1/16
`include "control.v"
`include "pc.v"
`include "imem.v"
`include "dmem.v"
`include "pipeDatapath.v"
`include "resultMux.v"
`include "logicUnit.v"
`include "cla32.v"
`include "alu.v"
`include "registerFile.v"
`include "register.v"
`include "decoder.v"
`include "mux32.v"
`include "pipeCpu.v"
`include "decode.v"
`include "shifter.v"
`include "icache.v"
`include "next.v"

module pipeCpu_tb ();
	wire CLOCK_50;
	wire [9:0] LEDR;
	wire [9:0] SW;
	
	pipeCpu myPipelinedCpu(LEDR, SW, CLOCK_50);

	pipeCpu_tester tester (CLOCK_50, SW, LEDR);
	
	initial begin
		$dumpfile ("pipeCpu.vcd");
		$dumpvars (0, pipeCpu_tb);
	end

endmodule

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
module pipeCpu_tester (CLOCK_50, SW, LEDR);
	output CLOCK_50;
	output [9:0] SW;
	input [9:0] LEDR;
	
	assign CLOCK_50 = clk;
	assign SW[9] = reset;
	assign SW[8] = slowDown;
	assign SW[7] = dmemLoadControl;
	assign SW[6] = imemAltProgram;
	assign SW[5:0] = 1'b0;
	
	reg reset, slowDown, dmemLoadControl, imemAltProgram, clk;
	
	parameter period = 2;
	
	initial begin
		clk = 0;
		reset = 1;
		slowDown = 0;
		dmemLoadControl = 0;
		imemAltProgram = 0;
	end
	
	always begin
		#(period/2);
		clk = !clk;
	end
	
	initial begin
		#(period*5); 	reset = 0;											//program 1, A=7
		#(period*50);	reset = 1; dmemLoadControl = 1;
		#period;			reset = 0;											//program 1, A=9
		#(period*50);	reset = 1; dmemLoadControl = 0; imemAltProgram = 1;
		#period; 		reset = 0;											//program 2, A=7, loop and halt ?
		#(period*50);	reset = 1; dmemLoadControl = 1;
		#period;		reset = 0;												//program 2, A=9
		#(period*50);
		$finish;
	end
endmodule