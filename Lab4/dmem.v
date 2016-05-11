//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 4: Data memory module for the cpu
//EE 469 with James Peckol 5/7/16
module dmem (dataOut, clk, dataIn, adrx, read, write);
	output reg [15:0] dataOut;
	input clk;
	input [15:0] dataIn;
	input [10:0] adrx;
	input read, write;
	
	reg [15:0] mem [0:2047];
	
	//Perform the write operation @posedge clk & write is asserted
	always @(posedge clk) begin
		if (write) mem[adrx] <= dataIn[15:0];
	end
	
	always @(*) begin
		dataOut = read ? mem[adrx] : dataOut;
	end
endmodule