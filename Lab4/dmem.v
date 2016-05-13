//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 4: Data memory module for the cpu
//EE 469 with James Peckol 5/7/16
module dmem (dataOut, clk, dataIn, adrx, write);
	output [15:0] dataOut;
	input clk;
	input [15:0] dataIn;
	input [10:0] adrx;
	input write;
	
	reg [15:0] mem [0:2047];

	initial
	begin
		mem[0] = 16'h7;
		mem[1] = 16'h5;
		mem[2] = 16'h2;
		mem[3] = 16'h3;
	end
	
	assign dataOut = mem[adrx];
	
	//Perform the write operation @posedge clk & write is asserted
	always @(posedge clk) begin
		if (write) begin
			mem[adrx] <= dataIn[15:0];
		end
	end
endmodule