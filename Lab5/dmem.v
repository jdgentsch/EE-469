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
	
	//A small negedge triggered register to ensure that the write signal doesn't change on the posedge
	//Ensures we meet the hold time for our dmem system, as we are writing on posedge
	reg negedgeWriteCtl;

	//Continously read from the input address
	assign dataOut = mem[adrx];
	
	//Perform the write operation @posedge clk & write is asserted
	always @(posedge clk) begin
		//Loader unit, initializes variables in data memory (based on the program)
		if (reset) begin
			if (~loadControl) begin
				mem[0] <= 16'h7; //A = 7, typical branch if (A-B) > 3
				mem[1] <= 16'h5; //B = 5
			end else begin
				mem[0] <= 16'h8; //thus attempt A = 8 if control signal is high
				mem[1] <= 16'h3; //B = 3
			end
			mem[2] <= 16'h3; //C = 3
			mem[3] <= 16'h5; //D = 5
			mem[4] <= 16'h5A5A; //E = 0x5A5A
			mem[5] <= 16'h6767; //F = 0x6767
			mem[6] <= 16'h3C; //G = 0x3C
			mem[7] <= 16'hFF; //H = 0xFF

		end else if (negedgeWriteCtl) begin
			mem[adrx] <= dataIn[15:0];
		end
	end
	
	always @(negedge clk) begin
		negedgeWriteCtl <= write;
	end
endmodule