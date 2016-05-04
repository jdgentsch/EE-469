//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 3: Barrel shifter with dataflow model
//EE 469 with James Peckol 5/1/16
module barrelShifter (out, overflow, carry, in, shift);
	input [31:0] in;
	input [1:0] shift;
	output [31:0] out;
	output overflow;
	output carry;

	//Temporary 33-bit wide buses needed to maintain carry
	wire [32:0] unshifted;
	wire [32:0] shiftedBy1;
	wire [32:0] shiftedBy2;

	//Input to the barrel shifter is equal to the sign extended input
	assign unshifted[32:0] = {in[31], in[31:0]};

	//Overflow of the shifter occurs when the input and output MSB differ in sign
	assign overflow = in[31] ^ out[31];
	assign carry = shiftedBy2[32];
	assign out[31:0] = shiftedBy2[31:0];

	// first row: shift 0..1
	mux2 muxRow1_bit0 (shiftedBy1[0], shift[0], {1'b0, unshifted[0]});			// bit0 mux, output 1'b0 or in[0]
	genvar i;
	generate
		for (i=1; i<33; i=i+1) begin : genRow1
			mux2 muxRow1 (shiftedBy1[i], shift[0], {unshifted[i-1], unshifted[i]});
		end
	endgenerate

	//2nd row: shift 0..2nd
	mux2 muxRow2_bit0 (shiftedBy2[0], shift[1], {1'b0, shiftedBy1[0]});			// out[0] mux, output 1'b0 or output [0] from 1st row
	mux2 muxRow2_bit1 (shiftedBy2[1], shift[1], {1'b0, shiftedBy1[1]});			// out[1] mux, output 1'b0 or output [1] from 1st row
	genvar j;
	generate
		for (j=2; j<33; j=j+1) begin : genRow2
			mux2 muxRow2 (shiftedBy2[j], shift[1],{shiftedBy1[j-2], shiftedBy1[j]});
		end
	endgenerate

endmodule