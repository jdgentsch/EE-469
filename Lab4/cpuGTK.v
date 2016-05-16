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
	wire [9:0] LEDR, SW;
	wire CLOCK_50;
	
	cpu dut (LEDR, SW, CLOCK_50);
	cpu_tester tester (LEDR, SW, CLOCK_50);
	
	initial begin
		$dumpfile ("cpu.vcd");
		$dumpvars (0, dut);
	end

endmodule

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
module cpu_tester (LEDR, SW, CLOCK_50);
	output reg CLOCK_50;
	output reg [9:0] SW;
	input [9:0] LEDR;
	
	parameter period = 2;
	initial CLOCK_50 = 0;
	always begin
		#(period/2);
		CLOCK_50 = !CLOCK_50;
	end
	
	initial begin
		SW = 10'b1000000000;
		#(period*5);
		SW[9] = 0;
		#(period*50);
		$finish;
	end
endmodule