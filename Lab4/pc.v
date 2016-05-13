//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 4: Program counter for the cpu
//EE 469 with James Peckol 5/7/16

module pc (pc, nextAdrx, rfRdData0, branchCtl, rst, clk);
	output reg [8:0] pc;	// current program count
	input [8:0] nextAdrx;		// branch taget adrx
	input [8:0] rfRdData0;			// jump reg input value from regfile
	input [1:0] branchCtl;
	input rst, clk;			// branch: signal pc to replace with branch target adrx
	
	always @(posedge clk) begin
		if (rst)
			pc <= 9'h0;
		else if (branchCtl == 2'b10 || branchCtl == 2'b01)
			pc <= nextAdrx;
		else if (branchCtl == 2'b11)
			pc <= rfRdData0;
		else
			pc <= pc + 9'h4;	// each instruction adrx is 4 bytes
	end
endmodule
