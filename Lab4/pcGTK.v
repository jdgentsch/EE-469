`include "pc.v"

module pcGTK;
	wire [8:0] pc;
	wire [8:0] nextAdrx;
	wire branch, jump, rst, clk;

	pc mypc (pc, nextAdrx, branch, jump, rst, clk);
	Tester aTester (nextAdrx, branch, jump, rst, clk, pc);

	// file for gtkwave
	initial
		begin
			$dumpfile("pcGTK.vcd");
			$dumpvars(1, mypc);
		end
endmodule


module Tester (nextAdrx, branch, jump, rst, clk, pc);
	output reg [8:0] nextAdrx;
	output reg branch, jump, rst, clk;
	input [8:0] pc;

	parameter stimDelay = 20;

	initial // Stimulus
	begin
		clk = 0; rst = 0; branch = 0; jump = 0; nextAdrx = 9'h0;
		#stimDelay clk = ~clk;
		#stimDelay clk = ~clk; rst = 1;
		#stimDelay clk = ~clk;
		#stimDelay clk = ~clk;
		#stimDelay clk = ~clk; rst = 0;
		#stimDelay clk = ~clk;
		#stimDelay clk = ~clk;
		#stimDelay clk = ~clk; nextAdrx = 9'hFF; branch = 1; jump = 0;
		#stimDelay clk = ~clk;
		#stimDelay clk = ~clk;
		#stimDelay clk = ~clk; nextAdrx = 9'h16; branch = 0; jump = 0;
		#stimDelay clk = ~clk;
		#stimDelay clk = ~clk;
		#stimDelay clk = ~clk; nextAdrx = 9'hCA; branch = 0; jump = 1;
		#stimDelay clk = ~clk;
		#stimDelay clk = ~clk;
		$finish;
	end
endmodule