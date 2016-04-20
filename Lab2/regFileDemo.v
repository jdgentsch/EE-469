//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 2: regFile Demo
//EE 469 with James Peckol 4/15/16

//This top-level driver will interface directly with the reg file, reading and writing
module regFileDemo (LEDR, SW, KEY, CLOCK_50);
	output [9:0] LEDR;
	input CLOCK_50;
	input [9:0] SW;
	input [3:0] KEY;

	wire rst;
	wire clk; // choosing from 32 different clock speeds
	wire [31:0] rdData0;
	wire [31:0] rdData1;
	
	// instantiate clock_divider module
 	clock_divider cdiv (.clk_out(clk), .clk_in(CLOCK_50), .slowDown(SW[8]));

	// instantiate the register file module
	registerFile myRegFile (.rdData0(rdData0), .rdData1(rdData1), .rdAdrx0(rdAdrx0),
									.rdAdrx1(rdAdrx1), .writeAdrx(writeAdrx), .writeData(writeData), 
									.clk(clk), .writeEn(writeEn));

  	assign rst = SW[9];
	
	//Displays state on the upper two bits, read data on lower eight
	assign LEDR = {state[1:0], (KEY[0] ? rdData1[7:0] : rdData0[7:0])};
	
 	// state encoding
 	parameter [1:0] idle = 2'b11, writeLower = 2'b01, writeUpper = 2'b10, read = 2'b00;
  	reg [1:0] state;
	reg [4:0] adrx;
	reg [31:0] writeData;
	reg writeEn;
	
	wire [4:0] rdAdrx1;
	wire [4:0] rdAdrx0;
	wire [4:0] writeAdrx;
	
	assign rdAdrx1 = {1'b1, adrx[3:0]};
	assign rdAdrx0 = {1'b0, adrx[3:0]};
	assign writeAdrx = adrx;
	
	always @(posedge clk) begin
		//Initialize the system to allow reading and writing
		if (rst) begin
			writeEn <= 1'b1;
			writeData <= 32'hFFFF000F;
			adrx <= 5'b0;
			state <= writeLower;
		end else begin
			case (state)
				//Write to the lower 16 registers
				writeLower: begin
					adrx <= adrx + 5'b1;
					if (adrx < 5'b01111) begin
						writeData <= writeData - 32'b1;
						state <= writeLower;
					end else begin
						writeData <= 32'h0000FFF0;
						state <= writeUpper;
					end
				end
				//Write to the upper 16 registers
				writeUpper: begin
					adrx <= adrx + 5'b1;
					if (adrx < 5'b11111) begin
						writeData <= writeData + 1'b1;
						state <= writeUpper;
					end else begin
						writeData <= 32'h00000000;
						adrx <= 5'b0;
						writeEn <= 1'b0;
						state <= read;
					end
				end
				//Read from the lower registers
				read: begin
					writeEn <= 1'b0;
					state <= read;
					adrx <= adrx + 5'b1;
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
	
	assign clk_out = slowDown ? divided_clocks[23] : clk_in;
	
	initial
		divided_clocks = 0;
	
	always @(posedge clk_in)
		divided_clocks = divided_clocks + 1;
		
endmodule
