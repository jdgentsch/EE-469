//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 4: Program counter for the cpu
//EE 469 with James Peckol 5/7/16

module pc (pc, nextAdrx, branch, jump, rst, clk);
	output reg [8:0] pc;	// current program count
	input [8:0] nextAdrx;		// branch taget adrx
	input branch, jump, rst, clk;			// branch: signal pc to replace with branch target adrx

	always @(posedge clk) begin
		if (rst)
			pc <= 9'h0;
		else if (branch | jump)
			pc <= nextAdrx;
		else
			pc <= pc + 9'h4;	// each instruction adrx is 4 bytes
	end
endmodule
