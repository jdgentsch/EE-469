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
	wire [1:0] dataMuxSel;
	
	reg [10:0] adrx;
	reg [4:0] writeAdrx;
	reg [4:0] rdAdrx;
	reg [15:0] sramDataIn [0:47];
	reg writeEn;
	reg sramRead;
	reg sramNotOutEn;
	reg sramDoWrite;
	reg [2:0] state;
	reg [5:0] iterCount;
	reg [15:0] memoryInput;
	
	parameter [2:0] boot = 3'b000, load = 3'b001, decode = 3'b010, store = 3'b011, writeback = 3'b100;
	
	//Manage drive of the data lines, input to the SRAM during boot stage
	assign data = dataMuxSel[1] | ~sramNotOutEn ? 32'bz : ((state == boot) ? memoryInput : aluResult);
	assign reset = SW[9];
	assign dataMuxSel[1] = (state == writeback) & sramNotOutEn ? 1'b1 : 1'b0;
	assign dataMuxSel[0] = 1'b0;
	
	clock_divider cdiv (.clk_out(clk), .clk_in(CLOCK_50), .slowDown(SW[8]));
	//FIX need to route aluResult to the register inputs for storage, need to carefully manage who is on the common data line, sram output with the instruction or alu with the result?
	//Idea: put alu result into a register, save it on the next edge in reg file
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
	
	initial begin
		sramDataIn[0] <= 16'b000_10000_00000_000; //NOOP
		sramDataIn[1] <= 16'b000_10001_00001_001; //ADD FFFF FFFF
		sramDataIn[2] <= 16'b000_10010_00010_010; //SUB 9 C
		sramDataIn[3] <= 16'b000_10011_00011_011; //AND 1F A
		sramDataIn[4] <= 16'b000_10100_00100_100; //OR 1F A
		sramDataIn[5] <= 16'b000_10101_00101_101; //XOR 1F A
		sramDataIn[6] <= 16'b000_10110_00110_110; //SLT 8 F
		sramDataIn[7] <= 16'b000_10111_00111_111; //SLL C 3
		sramDataIn[8] <= 16'b000_11000_01000_000; //NOOP
		sramDataIn[9] <= 16'b000_11001_01001_001; //ADD 1C 8
		sramDataIn[10] <= 16'b000_11010_01010_010; //SUB 6 D
		sramDataIn[11] <= 16'b000_11011_01011_011; //AND 15 3
		sramDataIn[12] <= 16'b000_11100_01100_100; //OR 7 1E
		sramDataIn[13] <= 16'b000_11101_01101_101; //XOR 1B 9
		sramDataIn[14] <= 16'b000_11110_01110_110; //SLT 1F 2
		sramDataIn[15] <= 16'b000_11111_01111_111; //SLL B 1
		//END INSTRUCTIONS
		sramDataIn[16] <= 16'b0000_0000_0000_0000; //NOOP A B
		sramDataIn[17] <= 16'b0000_0000_0000_0001; //ADD 9 C
		sramDataIn[18] <= 16'b0000_0000_0000_0010; //SUB 9 C
		sramDataIn[19] <= 16'b0000_0000_0000_0011; //AND 1F A
		sramDataIn[20] <= 16'b0000_0000_0000_0100; //OR 1F A
		sramDataIn[21] <= 16'b0000_0000_0000_0101; //XOR 1F A
		sramDataIn[22] <= 16'b0000_0000_0000_0110; //SLT 8 F
		sramDataIn[23] <= 16'b0000_0000_0000_0111; //SLL C 3
		sramDataIn[24] <= 16'b0000_0000_0000_1000; //NOOP
		sramDataIn[25] <= 16'b0000_0000_0000_1001; //ADD 1C 8
		sramDataIn[26] <= 16'b0000_0000_0000_1010; //SUB 6 D
		sramDataIn[27] <= 16'b0000_0000_0000_1011; //AND 15 3
		sramDataIn[28] <= 16'b0000_0000_0000_1100; //OR 7 1E
		sramDataIn[29] <= 16'b0000_0000_0000_1101; //XOR 1B 9
		sramDataIn[30] <= 16'b0000_0000_0000_1110; //SLT 1F 2
		sramDataIn[31] <= 16'b0000_0000_0000_1111; //SLL B 1
		//END OPERAND FOR BITLINE A
		sramDataIn[32] <= 16'b0000_0000_0001_0000; //NOOP
		sramDataIn[33] <= 16'b0000_0000_0001_0001; //ADD 9 C
		sramDataIn[34] <= 16'b0000_0000_0001_0010; //SUB 9 C
		sramDataIn[35] <= 16'b0000_0000_0001_0011; //AND 1F A
		sramDataIn[36] <= 16'b0000_0000_0001_0100; //OR 1F A
		sramDataIn[37] <= 16'b0000_0000_0001_0101; //XOR 1F A
		sramDataIn[38] <= 16'b0000_0000_0001_0110; //SLT 8 F
		sramDataIn[39] <= 16'b0000_0000_0001_0111; //SLL C 3
		sramDataIn[40] <= 16'b0000_0000_0001_1000; //NOOP
		sramDataIn[41] <= 16'b0000_0000_0001_1001; //ADD 1C 8
		sramDataIn[42] <= 16'b0000_0000_0001_1010; //SUB 6 D
		sramDataIn[43] <= 16'b0000_0000_0001_1011; //AND 15 3
		sramDataIn[44] <= 16'b0000_0000_0001_1100; //OR 7 1E
		sramDataIn[45] <= 16'b0000_0000_0001_1101; //XOR 1B 9
		sramDataIn[46] <= 16'b0000_0000_0001_1110; //SLT 1F 2
		sramDataIn[47] <= 16'b0000_0000_0001_1111; //SLL B 1
	end
	
	always @(posedge clk) begin
		if (reset) begin
			state <= boot; //Begin by booting the SRAM
			adrx <= 11'b0; //SRAM begins writing at address 0
			writeAdrx <= 5'b0;
			writeEn <= 1'b0;
			sramRead <= 1'b0;
			sramDoWrite <= 1'b1;
			sramNotOutEn <= 1'b1;
			rdAdrx <= 5'b0;
			iterCount <= 6'b0;
			memoryInput <= sramDataIn[0];
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
						sramDoWrite <= 1'b1;
						if (iterCount == 6'b110000) begin //Write 16 instructions and 32 data values
							iterCount <= 6'b0;
							state <= load;
							sramRead <= 1'b1;
							sramNotOutEn <= 1'b0;
							adrx <= 11'b10000; //Data values start at address 16
							writeEn <= 1'b1;
						end else begin
							iterCount <= iterCount + 6'b1;
							memoryInput <= sramDataIn[adrx + 1];
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
					//write that reg into the RF;
					writeEn <= 1'b1;
					sramNotOutEn <= 1'b1;
				end
				store: begin //Save ALU results in the register file
					//Allow reading from the SRAM next cycle
					writeEn <= 1'b0;
					//aluResReg <= aluResult;
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