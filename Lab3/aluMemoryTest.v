//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 3: ALU and memory interface demo
//EE 469 with James Peckol 5/1/16

//This top-level driver will interface directly with the ALU for testing
//Controlled by user input to the DE1-SoC to input and read values from the ALU
module aluMemoryTest (LEDR, HEX5, HEX3, HEX2, HEX1, HEX0, SW, KEY, CLOCK_50);
	//DE1-SoC wire interface for driving hardware
	output [9:0] LEDR;
	output [6:0] HEX5, HEX3, HEX2, HEX1, HEX0;
	input CLOCK_50;
	input [9:0] SW;
	input [3:0] KEY;
	
	wire clk; // choosing from 32 different clock speeds
	wire reset;
	
	wire [31:0] data;
	wire [31:0] aluResult, aluBusA, aluBusB;
	wire [4:0] rdAdrx1, rdAdrx0;
	wire cFlag, nFlag, vFlag, zFlag;
	wire [2:0] aluControl;
	wire [15:0] rdData0, rdData1;
	
	reg [10:0] adrx;
	reg [4:0] writeAdrx;
	reg [4:0] rdAdrx;
	reg [1:0] dataMuxSel;
	reg [15:0] sramDataIn;
	reg writeEn;
	reg sramRead;
	reg sramNotOutEn;
	reg sramDoWrite;
	reg [2:0] state;
	reg [6:0] iterCount;
	
	parameter [2:0] boot = 3'b000, load = 3'b001, decode = 3'b010, store = 3'b011, writeback = 3'b100;
	
	assign reset = SW[9];
	
	clock_divider cdiv (.clk_out(clk), .clk_in(CLOCK_50), .slowDown(SW[8]));
	
	alu myALU (.busOut(aluResult), .zero(zFlag), .overflow(vFlag), .carry(cFlag), .neg(nFlag),
				  .busA(aluBusA), .busB(aluBusB), .control(aluControl));

	memory myMemory (.rdRF1(rdData1), .rdRF0(rdData0), .data(data), .clk(clk), .sramAdrx(adrx),
						  .sramNotOutEn(sramNotOutEn), .sramRead(sramRead), .rfWriteAdrx(writeAdrx),
						  .rfRdAdrx1(rdAdrx1), .rfRdAdrx0(rdAdrx0), .rfWriteEn(writeEn), .dataMuxSel(dataMuxSel));

	//Operand input into the ALU is the register output lines for this demo sign-extended
	assign aluBusA = {{16{rdData0[15]}}, rdData0[15:0]};
	assign aluBusB = {{16{rdData1[15]}}, rdData1[15:0]};
	
	//Instruction decode is encoded simply as noted below
	//Because all executed instructions in this demo are ALU operations
	assign aluControl = data[2:0];
	assign rdAdrx0 = (state < writeback) ? data[7:3] : rdAdrx;
	assign rdAdrx1 = data[12:8];
	
	always @(posedge clk) begin
		if (reset) begin
			state <= boot; //Begin by booting the SRAM
			adrx <= 11'b0; //SRAM begins writing at address 0
			dataMuxSel <= 2'b0; //Allow SRAM to output to data lines on boot
			writeAdrx <= 5'b0;
			writeEn <= 1'b0;
			sramRead <= 1'b0;
			sramDoWrite <= 1'b1;
			sramNotOutEn <= 1'b1;
			rdAdrx <= 5'b0;
			//More reset conditions here... for SRAM, RF ctl mostly.
		end else begin
			case (state)
				boot: begin //Write instructions and operand data into the SRAM
					//Trigger the read signal to write prepared data to the SRAM
					if (sramDoWrite == 1'b1) begin
						sramRead <= 1'b1;
						sramDoWrite <= 1'b0;
					//Setup data for input into the SRAM
					end else begin
						sramDataIn <= 16'b0; //FIX ADD ACTUAL INSTRUCTIONS
						sramDoWrite <= 1'b1;
						iterCount <= iterCount + 7'b1;
						if (iterCount == 7'b110000) begin //Write 16 instructions and 32 data values
							state <= load;
							sramRead <= 1'b1;
							sramNotOutEn <= 1'b0;
							adrx <= 11'b0;
							writeEn <= 1'b1;
						end else begin
							sramRead <= 1'b0;
							adrx <= adrx + 11'b1; //Write to the next adrx in SRAM
						end
					end
				end
				load: begin //Transfer operand data from the SRAM to registers
					if (adrx[10:0] < 11'b110000) begin
						//Write operand data to the regfile
						adrx <= adrx + 11'b1;
						writeAdrx <= writeAdrx + 5'b1;
						state <= load;
					end else begin
						//Disable RF writing, begin decoding
						state <= decode;
						writeAdrx <= 5'b0;
						adrx <= 11'b0;
						writeEn <= 1'b0;
					end
				end
				decode: begin //Interpret and execute SRAM data as ALU instructions
					//Control signals should read from SRAM and allow ALU to calculate
					state <= store;
					writeEn <= 1'b1;
					sramNotOutEn <= 1'b1;
				end
				store: begin //Save ALU results in the register file
					//Allow reading from the SRAM next cycle
					writeEn <= 1'b0;
					if (writeAdrx == 5'b11111) begin
						sramNotOutEn <= 1'b1;
						adrx <= 11'b0;
						sramDoWrite <= 1'b1;
						state <= writeback;
					end else begin
						sramNotOutEn <= 1'b0;
						adrx <= adrx + 11'b1;
						writeAdrx <= writeAdrx + 5'b1;
						state <= decode;
					end
				end
				writeback: begin //Move results from registers into SRAM
					if (sramDoWrite) begin
						sramRead <= 1'b1;
						sramDoWrite <= 1'b0;
					end else begin
						sramDoWrite <= 1'b1;
						sramRead <= 1'b0;
						rdAdrx <= rdAdrx + 5'b1;
						adrx <= adrx + 11'b1;
					end
				end
				default: state <= boot;
			endcase
		end
	end
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