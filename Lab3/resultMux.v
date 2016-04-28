//Jack Gentsch, Jacky Wang, Chinh Bui
//EE 469, Dr. Peckol 4/15/16
//Multiplexing of the resulting data
module resultMux (busOut, control, adderResult, andResult, orResult, xorResult, shiftResult);
	output [31:0] busOut;
	input [2:0] control;
	input [31:0] adderResult, andResult, orResult, xorResult, shiftResult;

	genvar i;
	generate for (i = 0; i < 32; i = i + 1) begin : alu_result_mux_gen
		mux8 myMux8 (.result(busOut[i]), .sel(control[2:0]),
						.in({shiftResult[i], adderResult[i], xorResult[i], orResult[i],
							  andResult[i], adderResult[i], adderResult[i], 1'b0}));
	end endgenerate

endmodule