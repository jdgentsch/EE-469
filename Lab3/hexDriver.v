module hexDriver(hexOut, binaryIn);
	output [6:0] hexOut;
	input [3:0] binaryIn;

	always @(*) begin
			case (binaryIn)
				3'b0000: hex1 <= 7'b1000000; //0
				3'b0001: hex1 <= 7'b1111001;
				3'b0010: hex1 <= 7'b0100100;
				3'b0011: hex1 <= 7'b0110000;
				3'b0100: hex1 <= 7'b0011001;
				3'b0101: hex1 <= 7'b0010010; //5
				3'b0110: hex1 <= 7'b0000010;
				3'b0111: hex1 <= 7'b1111000;
				3'b1000: hex1 <= 7'b0000000;
				3'b1001: hex1 <= 7'b0010000; //9
				default: hex1 <= 7'b1111111; //Not lit
			endcase
		end
endmodule