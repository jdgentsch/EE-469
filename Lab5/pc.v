//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 4: Program counter for the cpu
//EE 469 with James Peckol 5/7/16
// Program counter for the CPU
module pc (pc, nextAdrx, rfRdData0, branchCtl, rst, clk, halt);
	output reg [8:0] pc;				// current program count
	input [8:0] nextAdrx;			// branch absolute target adrx
	input [8:0] rfRdData0;			// jump reg input value from regfile
	input [1:0] branchCtl;
	input rst, clk, halt;
	
	always @(negedge clk) begin
		if (rst)
			pc <= 9'h0;
		else if (branchCtl == 2'b10 || branchCtl == 2'b01)
			pc <= nextAdrx;
		else if (branchCtl == 2'b11)
			pc <= rfRdData0;
		else if (halt)
			pc <= pc;
		else
			pc <= pc + 9'h4;	// each instruction adrx is 4 bytes
	end
endmodule
