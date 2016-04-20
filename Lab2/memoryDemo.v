//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 2: memory system demo
//EE 469 with James Peckol 4/15/16

//This top-level driver will interface directly with the reg file and sram system,
//reading and writing between the two modules
module memoryDemo (LEDR, SW, KEY, CLOCK_50);
	//DE1-SoC wire interface for driving hardware
	output [9:0] LEDR;
	input CLOCK_50;
	input [9:0] SW;
	input [3:0] KEY;
	wire rst;
	wire clk; // choosing from 32 different clock speeds
	wire [31:0] rdData0;
	wire [31:0] rdData1;
	
	assign rst = SW[9];
	
	//Displays the memory block being read on the upper two bits,
	//read data on lower eight (determined by the state of key 0)
	assign LEDR = {block[1:0], data[7:0]};
	//(KEY[0] ? rdData1[7:0] : rdData0[7:0])};
	
	// instantiate clock_divider module
 	clock_divider cdiv (.clk_out(clk), .clk_in(CLOCK_50), .slowDown(SW[8]));

	// instantiate the register file module
	memory myMemory (.rdRF1(rdData1), .rdRF0(rdData0), .data(data), .clk(clk), .sramAdrx(adrx), .sramNotOutEn(sramNotOutEn), .sramRead(sramRead),
					.rfWriteAdrx(writeAdrx), .rfRdAdrx1(rdAdrx1), .rfRdAdrx0(rdAdrx0), .rfWriteEn(writeEn), .dataMuxSel(dataMuxSel));
	
 	// state encoding
	//Necessary states: idle, write to SRAM, write to RF, read from RF, writeback to sram (4x).
	//block[1:0] keeps track of the sram block being written/read at a time 
 	parameter [2:0] idle = 3'b000, writeDo = 3'b001, writeSet = 3'b010,
						 rfWrite = 3'b011, rfRead = 3'b100, writeBackDo = 3'b101, writeBackSet = 3'b110;
	
	reg [2:0] state;
	reg [10:0] adrx;
	reg [31:0] sramDataIn;
	reg writeEn;
	reg sramRead;
	reg sramNotOutEn;
	reg [1:0] block; //The block of sram being dealt with
	reg [4:0] countWrites;
	
	wire [1:0] dataMuxSel;
	
	wire [4:0] rdAdrx1;
	wire [4:0] rdAdrx0;
	wire [4:0] writeAdrx;
	wire [31:0] data;
	
	//Force sram data driver to be disabled if sram output is enabled, or readline output
	assign data = dataMuxSel[1] | ~sramNotOutEn ? 32'bz : sramDataIn;
	
	//Allow read lines to output onto the shared data line only if the sram is disabled
	//Particularly, the rfRead and writeback stages
	assign dataMuxSel[1] = (state > rfWrite) & sramNotOutEn ? 1'b1 : 1'b0;
	assign dataMuxSel[0] = ~KEY[0];
	
	assign rdAdrx1 = {1'b1, adrx[3:0]};
	assign rdAdrx0 = {1'b0, adrx[3:0]};
	assign writeAdrx = adrx[4:0];
	
	always @(posedge clk) begin
		//Initialize the system to allow reading and writing
		if (rst) begin
			block <= 2'b11;
			writeEn <= 1'b0; //Disable RF write
			sramDataIn <= 32'h007F; //Begin writing 127 to address 0
			adrx <= 11'b0;
			
			//SRAM setup state
			sramNotOutEn <= 1'b1;
			sramRead <= 1'b0;
			state <= writeDo;		
		end else begin
			case (state)
				//Write to the lower 16 registers
				//Tells the SRAM to write the prepared byte of data
				writeDo: begin
					block <= 2'b10;
					sramRead <= 1'b1;
					state <= writeSet;
				end
				//Initializes conditions for writing the next byte
				writeSet: begin
					if (adrx[7:0] == 8'b01111111 && sramDataIn == 32'b0) begin
						//Conclude writing to the SRAM, transfer to the RF
						sramRead <= 1'b1;
						sramNotOutEn <= 1'b0;
						adrx <= 11'b0;
						writeEn <= 1'b1;
						//Begin valid notation of blocks, such that we can repeat
						//the sram read to RF and writeback process four times
						block <= 2'b00;
						state <= rfWrite;
					end else begin
						sramDataIn <= sramDataIn - 32'b1;
						adrx <= adrx + 11'b1;
						sramRead <= 1'b0;
						state <= writeDo;
					end
				end
				
				rfWrite: begin
					if (adrx[10:0] < {4'b0, block[1:0], 5'b11111}) begin
						adrx <= adrx + 11'b1;
						state <= rfWrite;
					end else begin
						adrx <= {4'b0, block[1:0], 5'b0};
						writeEn <= 1'b0;
						//Disable sram output so we can view readlines
						sramNotOutEn <= 1'b1;
						state <= rfRead;
					end
				end
				
				//Read from the lower registers
				rfRead: begin
					if (adrx[10:0] < {4'b0, block[1:0], 5'b01111}) begin
						writeEn <= 1'b0;
						adrx <= adrx + 11'b1;
						state <= rfRead;
					end else begin
						countWrites = 5'b0;
						case (block)
							2'b00: adrx <= 11'd128;
							2'b01: adrx <= 11'd145;
							2'b10: adrx <= 11'd162;
							2'b11: adrx <= 11'd179;
							default: adrx <= 11'b0;
						endcase
						state <= writeBackDo;
					end
				end
				
				writeBackDo: begin
					sramRead <= 1'b1;
					state <= writeBackSet;
				end
				
				//Initializes conditions for writing the next byte
				writeBackSet: begin
					if (adrx == 11'd195 && block == 2'b11) begin
						//Have processed all three blocks
						state <= idle;
					end else if (countWrites == 5'b11111) begin
						//Conclude writing to the SRAM, transfer to the next block
						countWrites <= 5'b0;
						sramRead <= 1'b1;
						sramNotOutEn <= 1'b0;
						adrx <= {4'b0, block[1:0], 5'b0};
						writeEn <= 1'b1;
						state <= rfWrite;
					end else begin
						adrx <= adrx + 11'b1;
						countWrites <= countWrites + 5'b1;
						sramRead <= 1'b0;
						state <= writeBackDo;
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
module clock_divider (clk_out, clk_in, slowDown);
	output clk_out;
	reg [31:0] divided_clocks;
	input clk_in, slowDown;
	
	assign clk_out = slowDown ? divided_clocks[1] : clk_in;
	
	initial
		divided_clocks = 0;
	
	always @(posedge clk_in)
		divided_clocks = divided_clocks + 1;
		
endmodule