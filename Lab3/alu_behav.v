//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 3: ALU with behavioural model
//EE 469 with James Peckol 4/28/16
module alu (busOut, zero, overflow, carry, neg, busA, busB, control);
	output [31:0] busOut;
	output zero, overflow, carry, neg;
	input [31:0] busA, busB;
	input [2:0] control;

	wire [31:0] adderBusB;
	
	// state encoding
	parameter [2:0] NOP = 3'b000, ADD = 3'b001, SUB = 3'b010, AND = 3'b011,
				    OR = 3'b100, XOR = 3'b101, SLT = 3'b110, SLL = 3'b111;

	// flip the bits if in subtraction mode
	assign adderBusB = control[1]? ~busB : busB; 

	// 8 control modes
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

			AND: begin 
				busOut = busA & busB;
				carry = 1'b0;
				overflow = 1'b0;
			end

			OR: begin 
				busOut = busA | busB;
				carry = 1'b0;
				overflow = 1'b0;
			end

			XOR: begin 
				busOut = busA ^ busB;
				carry = 1'b0;
				overflow = 1'b0;
			end

			SLT: begin 
				busOut = (busA < busB) ? 32'b1 : 32'b0;
				carry = 1'b0;
				overflow = 1'b0;
			end

			SLL: begin 
				busOut = busA << busB[1:0];
				carry = 1'b0;
				overflow = 1'b0;
			end
		endcase
	end

	// zero and negative status flag
	always @(*) begin 
		zero = ~| busOut;; 
		neg = busOut[31];
	end 
endmodule