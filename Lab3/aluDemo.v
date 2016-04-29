//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 2: memory system demo
//EE 469 with James Peckol 4/15/16

//This top-level driver will interface directly with the reg file and sram system,
//reading and writing between the two modules
module aluDemo (LEDR, HEX3, HEX2, HEX1, HEX0, SW, KEY, CLOCK_50);
	//DE1-SoC wire interface for driving hardware
	output [9:0] LEDR;
	output [6:0] HEX3, HEX2, HEX1, HEX0;
	input CLOCK_50;
	input [9:0] SW;
	input [3:0] KEY;
	
	wire clk; // choosing from 32 different clock speeds
	wire [3:0] operand;
	wire [2:0] control;
	wire [1:0] modeSel;
	wire cFlag, nFlag, vFlag, zFlag;
	wire enter;
	wire run;
	
	reg [15:0] op0;
	reg [15:0] op1;
	wire [31:0] result;
	
	assign LEDR = {6'b0, cFlag, nFlag, vFlag, zFlag}; //Disable LEDs
	assign operand = SW[3:0];
	assign control = SW[6:4];
	assign modeSel = SW[9:8];
	
	// Press detect for the enter and run keys
	pressDetectDelay myEnterToggle (.outToggle(enter), .inPress(~KEY[0]), .clk(clk));
	pressDetectDelay myRunToggle (.outToggle(run), .inPress(~KEY[1]), .clk(clk));
	
	// instantiate clock_divider module
 	clock_divider cdiv (.clk_out(clk), .clk_in(CLOCK_50), .slowDown(SW[7]));

	// instantiate the register file module
	alu myALU (.busOut(result), .zero(zFlag), .overflow(vFlag), .carry(cFlag), .neg(nFlag),
				  .busA({16'b0, op0}), .busB({16'b0, op1}), .control(control));

	// Drivers for the 7-segment 4 hex displays
	hexDriver myHex3 (HEX3, in);
	hexDriver myHex2 (HEX2, in);
	hexDriver myHex1 (HEX1, in);
	hexDriver myHex0 (HEX0, in);
	
 	// state encoding
	//Necessary states: idle, write to SRAM, write to RF, read from RF, writeback to sram (4x).
	//register block[1:0] keeps track of the sram block being written/read at a time 
 	parameter [2:0] idle = 3'b000, writeDo = 3'b001, writeSet = 3'b010,
						 rfWrite = 3'b011, rfRead = 3'b100, writeBackDo = 3'b101, writeBackSet = 3'b110;
	
	parameter [1:0] modifyA = 2'b00, modifyB = 2'b01;
	
	always @(posedge clk) begin
		//Initialize the system to allow reading and writing
		case (modeSel)
			modifyA:
			
			modifyB:
			
			default: //display result
			
		endcase
	end
	/*
		
		if (rst) begin
			block <= 2'b11;
			writeEn <= 1'b0; //Disable RF write
			sramDataIn <= 32'h007F; //Begin writing 127 to address 0
			adrx <= 11'b0;
			//SRAM setup
			sramNotOutEn <= 1'b1;
			sramRead <= 1'b0;
			state <= writeDo;		
		end else begin
			case (state)
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
				//Write a block to the register file
				rfWrite: begin
					if (adrx[10:0] < {4'b0, block[1:0], 5'b11111}) begin
						//Keep writing to the RF
						adrx <= adrx + 11'b1;
						state <= rfWrite;
					end else begin
						//Begin reading the previously written values
						adrx <= {4'b0, block[1:0], 5'b0};
						writeEn <= 1'b0;
						//Disable sram output so we can view readlines
						sramNotOutEn <= 1'b1;
						state <= rfRead;
					end
				end
				
				//Read from the register file
				rfRead: begin
					if (adrx[10:0] < {4'b0, block[1:0], 5'b01111}) begin
						writeEn <= 1'b0;
						adrx <= adrx + 11'b1;
						state <= rfRead;
					end else begin
						countWrites = 4'b0;
						sramRead <= 1'b0;
						sramNotOutEn <= 1'b1;
						//SRAM address to be written to, determined by the current block
						case (block)
							2'b00: adrx <= 11'd128;
							2'b01: adrx <= 11'd144;
							2'b10: adrx <= 11'd160;
							2'b11: adrx <= 11'd176;
							default: adrx <= 11'b0;
						endcase
						state <= writeBackDo;
					end
				end
				
				//Trigger SRAM read to writeback from RF to SRAM
				writeBackDo: begin
					sramRead <= 1'b1;
					state <= writeBackSet;
				end
				
				//Initializes conditions for writing the next byte to SRAM
				writeBackSet: begin
					if (adrx == 11'd191) begin
						//Have processed all three blocks, demo is concluded
						state <= idle;
					end else if (countWrites == 4'b1111) begin
						//Conclude writing to the SRAM, transfer to the next block
						//and write values to the register file
						countWrites <= 4'b0;
						sramRead <= 1'b1;
						sramNotOutEn <= 1'b0;
						adrx <= {4'b0, block[1:0] + 2'b01, 5'b0};
						writeEn <= 1'b1;
						block <= block + 2'b01;
						state <= rfWrite;
					end else begin
						//Continue writing to the SRAM from RF
						adrx <= adrx + 11'b1;
						countWrites <= countWrites + 4'b1;
						sramRead <= 1'b0;
						state <= writeBackDo;
					end
				end
				default: begin
					state <= idle;
				end
			endcase
		end
	end*/
endmodule


// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...
module clock_divider (clk_out, clk_in, slowDown);
	output clk_out;
	reg [31:0] divided_clocks;
	input clk_in, slowDown;
	
	//Choose clock frequency for signal tap display or LED display
	assign clk_out = slowDown ? divided_clocks[23] : clk_in;
	
	initial
		divided_clocks = 0;
	
	always @(posedge clk_in)
		divided_clocks = divided_clocks + 1;
		
endmodule