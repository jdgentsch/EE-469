//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 3: ALU with behavioural model
//EE 469 with James Peckol 4/28/16
module alu (busOut, zero, overflow, carry, neg, busA, busB, control);
	output [31:0] busOut;
	output zero, overflow, carry, neg;
	input [31:0] busA, busB;
	input [2:0] control;

	wire [31:0] adderBusB;
	
	parameter [2:0] NOP = 3'b000, ADD = 3'b001, SUB = 3'b010, AND = 3'b011,
				    OR = 3'b100, XOR = 3'b101, SLT = 3'b110, SLL = 3'b111;

	assign adderBusB = control[1]? ~busB : busB; 

	always @(*) begin
		case(control)
			NOP: busOut = 32'b0;

			ADD: begin
				{carry, busOut} = busA + adderBusB + control[1];
				overflow = (busA[31] & adderBusB[31] & ~busOut[31]) | (~busA[31] & ~adderBusBB[31] & busOut[31]);
			end

			SUB: begin
				{carry, busOut} = busA + adderBusB + control[1];
				overflow = (busA[31] & adderBusB[31] & ~busOut[31]) | (~busA[31] & ~adderBusB[31] & busOut[31]);
			end

			AND: busOut = busA & busB;

			OR: busOut = busA | busB;

			XOR: busOut = busA ^ busB;

			SLT: busOut = (busA < busB) ? 32'b1 : 32'b0;

			SLL: busOut = busA << busB[1:0];
		endcase
	end
endmodule