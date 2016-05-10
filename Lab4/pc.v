//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 4: Program counter for the cpu
//EE 469 with James Peckol 5/7/16

module pc (pc, branchAdrx, branch, rst, clk);
	output reg [31:0] pc;	// current program count
	input [31:0] branchAdrx;		// branch taget adrx
	input branch, rst, clk;			// branch: signal pc to replace with branch target adrx

	always @(posedge clk) 
	begin
		if (rst)
			pc <= 32'h0;
		else if (branch)
			pc <= branchAdrx;
		else
			pc <= currentAdrx + 32'h1;	// each instruction adrx is 4 bytes
	end
endmodule
