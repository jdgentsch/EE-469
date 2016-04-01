// andOr0.v
// Compute the logical AND and OR of inputs A and B.
module AndOr(AandB, AorB, A, B);
	output [1:0] AandB, AorB;
	input [1:0] A, B;
	and myAnd [1:0] (AandB[1:0], A[1:0], B[1:0]);
	or myOr [1:0] (AorB[1:0], A[1:0], B[1:0]);
endmodule 