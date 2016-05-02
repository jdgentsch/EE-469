//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 3: ALU with dataflow model
//EE 469 with James Peckol 4/28/16
module alu (busOut, zero, overflow, carry, neg, busA, busB, control);
	output [31:0] busOut;
	output zero, overflow, carry, neg;
	input [31:0] busA, busB;
	input [2:0] control;
	
	wire [31:0] andResult, orResult, xorResult, adderResult, shiftResult;
	wire [31:0] adderBusB;
	wire adderCFlag, adderVFlag, shiftCFlag, shiftVFlag;

	//Assignment of the status flags
	assign neg = busOut[31];
	assign zero = ~| busOut;
	
	//A multiplexer that asserts the result dependent on the control signals
	//NOP, ADD, SUB, AND, OR, XOR, SLT, SLL
	resultMux myMux (busOut, carry, overflow, control, adderResult, andResult, orResult, xorResult,
						  shiftResult, adderCFlag, adderVFlag, shiftCFlag, shiftVFlag);

	//Flips input bits for subtraction if necessary
	assign adderBusB = control[1] ? ~busB : busB;
	
	//Adder and subtractor unit, composed of carry look-ahead blocks
	cla32 myAdder (.sum(adderResult), .Cout(adderCFlag), .overflow(adderVFlag), .inA(busA), .inB(adderBusB), .Cin(control[1]));
	
	//Barrel shifter for shift left instructions
	barrelShifter myBarrelShifter (.out(shiftResult), .overflow(shiftVFlag), .carry(shiftCFlag), .in(busA), .shift(busB[1:0]));
	
	//Logical units for and, or, xor operations
	logicUnit myLogicUnit (.andResult(andResult), .orResult(orResult), .xorResult(xorResult), .inA(busA), .inB(busB));
	
	
endmodule
