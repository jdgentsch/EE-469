//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 5: Data memory module for the cpu
//EE 469 with James Peckol 5/25/16
//Data memory implemented similarly to the SRAM
module dmem (dataOut, clk, execDataIn, readAdrx, execWrite, loadControl, reset);
	output [15:0] dataOut;
	input clk;
	input [15:0] execDataIn;
	input [10:0] readAdrx;
	input execWrite;
	input loadControl;
	input reset;
	
	//Data is 16 bits wide, with 2048 locations
	reg [15:0] mem [0:2047];
	
	//A small negedge triggered register to ensure that the write signal doesn't change on the posedge
	//Ensures we meet the hold time for our dmem system, as we are writing on posedge
	reg negedgeWriteCtl;
	reg [10:0] writeAdrx;

	//Continously read from the input address
	//Forwarding logic added, if we are reading from an address equal to where we are writing,
	//then the output data should be equal to what we are trying to write.
	assign dataOut = (execWrite && (readAdrx == writeAdrx)) ? execDataIn : mem[readAdrx];
	
	//Perform the write operation @posedge clk & write is asserted
	always @(posedge clk) begin
		//Delay writing by a cycle, for the writeback stage.
		writeAdrx <= readAdrx;
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
			mem[writeAdrx] <= execDataIn[15:0];
		end
	end
	
	always @(negedge clk) begin
		negedgeWriteCtl <= execWrite;
	end
endmodule