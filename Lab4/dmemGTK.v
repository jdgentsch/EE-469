//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 4: GTKwave for Data memory module
//EE 469 with James Peckol 5/7/16

`timescale 1ns/100ps
`include "dmem.v"

module dmem_tb();

wire [15:0] dataOut, dataIn;
wire [10:0] adrx;
wire clk, read, write;

dmem 			dut (dataOut, clk, dataIn, adrx, read, write);
dmem_tester		tet (dataOut, clk, dataIn, adrx, read, write);

initial begin
	$dumpfile ("dmem.vcd");
	$dumpvars (0, dut);
	end
	
endmodule

module dmem_tester (dataOut, clk, dataIn, adrx, read, write);

output reg clk, read, write;
output reg [15:0] dataIn;
output reg [10:0] adrx;
input [15:0] dataOut;

parameter period = 2;
initial clk = 1'b1;
always begin
#(period/2);
clk = !clk;
end

initial begin
#period;
read = 1; write = 1; adrx = 11'b0; dataIn = 16'h0;	//write and read new data simultaneously
#period;
read = 0; dataIn = 16'hFFFF;						// write new data, data from cycle 1 remain at output
#period;
write = 0; read = 1; dataIn = 16'h2222;				// read data from 2nd cycle, write signal off. dataIn change but doesn't get written
#(period*3);
$finish;
end

endmodule