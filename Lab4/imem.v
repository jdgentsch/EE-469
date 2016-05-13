//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 4: Instruction memory module for the cpu
//EE 469 with James Peckol 5/7/16
module imem (dataOut, adrx);
	output [31:0] dataOut;
	input [6:0] adrx;
	
	reg [31:0] mem [0:127];
	
	initial
	begin
		$readmemb("mips2mach.txt", mem);
	end

	assign dataOut = mem[adrx];

endmodule
