//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 4: Data memory module for the cpu
//EE 469 with James Peckol 5/7/16
//Data memory implemented similarly to the SRAM
module dmem (dataOut, clk, dataIn, adrx, write, loadControl, reset);
	output [15:0] dataOut;
	input clk;
	input [15:0] dataIn;
	input [10:0] adrx;
	input write;
	input loadControl;
	input reset;
	
	//Data is 16 bits wide, with 2048 locations
	reg [15:0] mem [0:2047];

	//Continously read from the input address
	assign dataOut = mem[adrx];
	
	//Perform the write operation @posedge clk & write is asserted
	always @(posedge clk) begin
		//Loader unit, initializes variables in data memory (based on the program)
		if (reset) begin
			if (~loadControl) begin
				mem[0] <= 16'h7; //A = 7, typical branch if (A-B) > 3
			end else begin
				mem[0] <= 16'h9; //thus attempt A = 9 if control signal is high
			end
			mem[1] <= 16'h5; //B = 5 
			mem[2] <= 16'h2; //C = 2
			mem[3] <= 16'h4; //D = 3
		end else if (write) begin
			mem[adrx] <= dataIn[15:0];
		end
	end
endmodule