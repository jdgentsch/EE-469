//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 3: Barrel shifter with dataflow model
//EE 469 with James Peckol 5/1/16
module shifter (out, overflow, carry, in, shift);
	input [31:0] in;
	input [4:0] shift;
	output [31:0] out;
	output overflow;
	output carry;

	//Overflow of the shifter occurs when the input and output MSB differ in sign
	assign overflow = in[31] ^ out[31];
	assign {carry, out} = {1'b0, in} << shift[4:0];
endmodule