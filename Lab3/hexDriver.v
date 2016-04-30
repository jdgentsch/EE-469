//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 3: ALU with dataflow model
//EE 469 with James Peckol 4/29/16
// A simple 7-segment hex display converter, accepting a binary input between 0 and F,
// and outputting the signal to drive the DE1's HEX display.
module hexDriver(hexOut, binaryIn);
	output reg [6:0] hexOut;
	input [3:0] binaryIn;

	always @(*) begin
			case (binaryIn)
				4'b0000: hexOut <= 7'b1000000; //0
				4'b0001: hexOut <= 7'b1111001;
				4'b0010: hexOut <= 7'b0100100;
				4'b0011: hexOut <= 7'b0110000;
				4'b0100: hexOut <= 7'b0011001;
				4'b0101: hexOut <= 7'b0010010; //5
				4'b0110: hexOut <= 7'b0000010;
				4'b0111: hexOut <= 7'b1111000;
				4'b1000: hexOut <= 7'b0000000;
				4'b1001: hexOut <= 7'b0010000; //9
				4'b1010: hexOut <= 7'b0001000; //A
				4'b1011: hexOut <= 7'b0000011; //b
				4'b1100: hexOut <= 7'b0100111; //c
				4'b1101: hexOut <= 7'b0100001; //d
				4'b1110: hexOut <= 7'b0000110; //E
				4'b1111: hexOut <= 7'b0001110; //F
				default: hexOut <= 7'b1000000; //0
			endcase
		end
endmodule