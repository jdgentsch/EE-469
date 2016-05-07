//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 4: Data memory module for the cpu
//EE 469 with James Peckol 5/7/16
module dmem (dataOut, clk, dataIn, adrx, read);
	output [15:0] dataOut;
	input clk;
	input [15:0] dataIn;
	input [10:0] adrx;
	input read;
	
	reg [15:0] mem [0:2047];
	
	assign dataOut = mem[adrx];
	
	//Perform the write operation when read signal is strobed high
	always @(posedge read) begin
		mem[adrx] <= dataIn[15:0];
	end
endmodule
