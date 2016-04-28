module barrelShifter (out, in, shift);

input [31:0] in;
input [1:0] shift;
output [31:0] out;

wire outRow1 [31:0];

// first row: shift 0..1
mux2 muxRow1_bit0 (outRow1[0], shift[0], {1'b0, in[0]});			// bit0 mux, output 1'b0 or in[0]
genvar i;
generate
	for (i=1; i<32; i=i+1) begin : genRow1
		mux2 muxRow1 (outRow1[i], shift[0], {in[i-1], in[i]});
	end
endgenerate

//2nd row: shift 0..2nd
mux2 muxRow2_bit0 (out[0], shift[1], {1'b0, outRow1[0]});			// out[0] mux, output 1'b0 or output [0] from 1st row
mux2 muxRow2_bit1 (out[1], shift[1], {1'b0, outRow1[1]});			// out[1] mux, output 1'b0 or output [1] from 1st row
genvar j;
generate
	for (j=2; j<32; j=j+1) begin : genRow2
		mux2 muxRow2 (out[j], shift[1],{outRow1[j-2], outRow1[j]});
	end
endgenerate

endmodule