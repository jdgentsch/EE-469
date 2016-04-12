//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 2: SRAM Demo
//EE 469 with James Peckol 4/8/16

//This top-level driver will interface directly with the SRAM, reading or writing
//0 to 127 in the first 128 addresses of the SRAM
module sramDemo (LEDR, SW, KEY, CLOCK_50);
	output [9:0] LEDR;
	input CLOCK_50;
	input [9:0] SW;
	input [3:0] KEY;

	reg nOE;
	reg read;
	reg [10:0] adrx;
	reg [15:0] mem;

	wire [15:0] data;
	wire rst;
	wire enterWrite;
	wire enterRead;
	reg [9:0] ledDriver;

	wire [31:0] clk; // choosing from 32 different clock speeds

	// instantiate clock_divider module
 	clock_divider cdiv (CLOCK_50, clk);

	// instantiate the sram module
 	sram mySram (.data(data), .clk(CLOCK_50), .adrx(adrx), .nOE(nOE), .read(read));

  	// tri-state driver for our inout port
 	assign data = nOE ? mem : 16'bz;

  	assign rst = SW[9];
 	assign enterRead = ~KEY[0];
	assign enterWrite = ~KEY[1];
	assign LEDR = ledDriver;

 	// state encoding
 	parameter [2:0] idle = 3'b000, writeSet = 3'b001, writeDo = 3'b011; 
 	parameter [2:0] readSet = 3'b111, readDo = 3'b110;

  	reg [2:0] state;

	always @(posedge CLOCK_50) begin
		//Initialize the system to allow reading and writing
		if (rst) begin
			ledDriver[0] <= 1;
			ledDriver[1] <= 0;
			nOE <= 1;
			read <= 1;
			adrx <= 11'b0;
			mem <= 16'b0000000001111111;
			state <= idle;

		end else begin
			case (state)
				// transition state between write and read
				idle: begin
					if (enterRead) begin
						ledDriver <= 10'b0;
						adrx <= 11'b0;
						nOE <= 0;
						read <= 1;
						state <= readDo;
					end else if (enterWrite) begin
						ledDriver <= 10'b0000000011;
						adrx <= 11'b0;
						mem <= 16'b0000000001111111;
						nOE <= 1;
						read <= 0;
						state <= writeDo;
					end else begin
						//When waiting for a command, light up led[1]
						ledDriver <= 10'b0000000010;
					end
				end

				//Tells the SRAM to write the prepared byte of data
				writeDo: begin
					read <= 1;
					state <= writeSet;
				end

				//Initializes conditions for writing the next byte
				writeSet: begin
					if (adrx[7:0] == 8'b01111111) begin
						read <= 1;
						state <= idle;
					end else begin
						mem <= mem - 1'b1;
						adrx <= adrx + 1'b1;
						read <= 0;
						state <= writeDo;
					end
				end

				//Displays the read byte on the output LEDs
				readDo: begin
					ledDriver[9:2] <= data[7:0];
					state <= readSet;
				end

				//Prepares to read the next byte of data from the SRAM
				readSet: begin
					if (adrx[7:0] == 8'b01111111) begin
						adrx <= 11'b0;
						state <= idle;
					end else begin
						adrx <= adrx + 1'b1;
						state <= readDo;
					end
				end

				default: begin
					state <= idle;
				end
			endcase
		end
	end

endmodule


 // divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...
module clock_divider (clock, divided_clocks);
	input clock;
	output [31:0] divided_clocks;
	reg [31:0] divided_clocks;
	
	initial
		divided_clocks = 0;
	
	always @(posedge clock)
		divided_clocks = divided_clocks + 1;
		
endmodule
