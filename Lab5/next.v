//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 5: Next stage calculation for the cpu
//EE 469 with James Peckol 6/1/16
//Next stage logic for the pipelined CPU
module next (doBranch, nextAdrx, wbBranchCtl, wbRfRdData0, wbImmediate, wbZFlag, clk);
	output reg doBranch;
	output reg [8:0] nextAdrx;
	input [8:0] wbRfRdData0;
	input [1:0] wbBranchCtl;
	input [15:0] wbImmediate;
	input wbZFlag;
	input clk;

	// Jump or Branch, controls the PC
	parameter [1:0] NO_BR = 2'b00, BRANCH = 2'b01, JUMP = 2'b10, JUMP_REG = 2'b11;
	
	always @(posedge clk) begin
		if (wbBranchCtl == JUMP) begin //If a jump
			doBranch <= 1'b1;
			nextAdrx <= wbImmediate[8:0];
		end else if (wbBranchCtl == BRANCH && !wbZFlag) begin //BNE has occurred
			doBranch <= 1'b1;
			nextAdrx <= wbImmediate[8:0];
		end else if (wbBranchCtl == JUMP_REG) begin
			doBranch <= 1'b1;
			nextAdrx <= wbRfRdData0;
		end else begin
			doBranch <= 1'b0;
			nextAdrx <= 9'b0;
		end
	end
endmodule