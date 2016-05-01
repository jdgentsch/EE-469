//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 3: ALU Functionality Demo
//EE 469 with James Peckol 4/29/16

//This top-level driver will interface directly with the ALU for testing
//Controlled by user input to the DE1-SoC to input and read values from the ALU
module aluDemo (LEDR, HEX5, HEX3, HEX2, HEX1, HEX0, SW, KEY, CLOCK_50);
	//DE1-SoC wire interface for driving hardware
	output [9:0] LEDR;
	output [6:0] HEX5, HEX3, HEX2, HEX1, HEX0;
	input CLOCK_50;
	input [9:0] SW;
	input [3:0] KEY;
	
	wire clk; // choosing from 32 different clock speeds
	wire [3:0] operand;
	wire [2:0] control;
	wire [1:0] modeSel;
	wire [31:0] result;
	wire cFlag, nFlag, vFlag, zFlag;
	wire enter;
	wire run;

	reg [15:0] resultDisp;
	reg [3:0] flagReg;
	reg [15:0] opA;
	reg [15:0] opB;
	reg [1:0] digitSel;
	reg [15:0] display;
	
	assign LEDR = {6'b0, flagReg}; //Disable LEDs
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
				  .busA({{16{opA[15]}}, opA}), .busB({{16{opB[15]}}, opB}), .control(control));

	// Drivers for the 7-segment 4 hex displays
	hexDriver myHex3 (HEX3, display[15:12]);
	hexDriver myHex2 (HEX2, display[11:8]);
	hexDriver myHex1 (HEX1, display[7:4]);
	hexDriver myHex0 (HEX0, display[3:0]);

	//Display which digit is being editted with HEX5
	hexDriver myHex5 (HEX5, {2'b0, digitSel[1:0]});
	
	parameter [1:0] modifyA = 2'b00, modifyB = 2'b01;
	
	always @(posedge clk) begin
		// Store the results of the ALU when run is toggled
		if (run) begin
			resultDisp <= result[15:0];
			flagReg <= {cFlag, nFlag, vFlag, zFlag};
		end else begin //Explicit latching
			resultDisp <= resultDisp;
			flagReg <= flagReg;
		end
		// Set the display dependent on switches 9 and 8
		case (modeSel)
			modifyA: begin
				if (enter) begin
					digitSel <= digitSel + 2'b1;
					case (digitSel)
						2'b00: opA[3:0] <= operand;
						2'b01: opA[7:4] <= operand;
						2'b10: opA[11:8] <= operand;
						2'b11: opA[15:12] <= operand;
						default: opA <= opA;
					endcase
				end
				display <= opA;
			end modifyB: begin
				if (enter) begin
					digitSel <= digitSel + 2'b1;
					case (digitSel)
						2'b00: opB[3:0] <= operand;
						2'b01: opB[7:4] <= operand;
						2'b10: opB[11:8] <= operand;
						2'b11: opB[15:12] <= operand;
						default: opB <= opB;
					endcase
				end
				display <= opB;
			end default:  begin//display result
				digitSel <= 2'b0;
				display <= resultDisp;
			end
		endcase
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