//Jack Gentsch, Jacky Wang, Chinh Bui
//EE 469, Dr. Peckol 4/15/16
//Multiplexing of the resulting data
module resultMux (busOut, cFlag, vFlag, control, adderResult, andResult, orResult, xorResult,
						shiftResult, adderCFlag, adderVFlag, shiftCFlag, shiftVFlag);
	output [31:0] busOut;
	output cFlag, vFlag;
	input [2:0] control;
	input [31:0] adderResult, andResult, orResult, xorResult, shiftResult;
	input adderCFlag, adderVFlag, shiftCFlag, shiftVFlag;

	wire [31:0] sltResult;
	
	assign sltResult = {31'b0, adderResult[31]};
	
	mux8 cFlagMux (.result(cFlag), .sel(control[2:0]),
					.in({shiftCFlag, adderCFlag, 1'b0, 1'b0,
					1'b0, adderCFlag, adderCFlag, 1'b0}));

	mux8 vFlagMux (.result(vFlag), .sel(control[2:0]),
					.in({shiftVFlag, adderVFlag, 1'b0, 1'b0,
					1'b0, adderVFlag, adderVFlag, 1'b0}));

	genvar i;
	generate for (i = 0; i < 32; i = i + 1) begin : alu_result_mux_gen
		mux8 myMux8 (.result(busOut[i]), .sel(control[2:0]),
						.in({shiftResult[i], sltResult[i], xorResult[i], orResult[i],
							  andResult[i], adderResult[i], adderResult[i], 1'b0}));
	end endgenerate

endmodule