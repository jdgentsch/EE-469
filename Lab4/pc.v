//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 4: Program counter for the cpu
//EE 469 with James Peckol 5/7/16

module pc (currentAdrx, branchAdrx, branch, rst, clk);
	output reg [31:0] currentAdrx;	// current pc adrx
	input [31:0] branchAdrx;		// branch taget adrx
	input branch, rst, clk;			// branch: signal pc to replace with branch target adrx

	always @(posedge clk) 
	begin
		if (rst)
			currentAdrx <= 32'b0;
		else if (branch)
			currentAdrx <= branchAdrx;
		else
			currentAdrx <= currentAdrx + 32'h00000004;
	end
endmodule
