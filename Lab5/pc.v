//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 5: Program counter for the cpu
//EE 469 with James Peckol 5/25/16
// Program counter for the CPU
module pc (pc, nextAdrx, doBranch, rst, clk, halt);
	output reg [8:0] pc;				// current program count
	input [8:0] nextAdrx;			// branch absolute target adrx
	input doBranch;
	input rst, clk, halt;
	
	always @(negedge clk) begin
		if (rst)
			pc <= 9'h0;
		else if (halt)
			pc <= pc;
		else if (doBranch)
			pc <= nextAdrx;
		else
			pc <= pc + 9'h4;	// each instruction adrx is 4 bytes
	end
endmodule
