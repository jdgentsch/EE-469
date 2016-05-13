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
		mem[0] = 32'b100011_00000_01001_0000000000000000;
		mem[1] = 32'b100011_00000_01010_0000000000000001;
		mem[2] = 32'b000000_10010_01001_01001_00000_100010;
		mem[3] = 32'b001000_00000_01011_0000000000000011;
		mem[4] = 32'b000000_01011_01001_01010_00000_101010;
		mem[5] = 32'b000101_01010_00000_0000000000110000;
		mem[6] = 32'b100011_00000_01001_0000000000000010;
		mem[7] = 32'b000000_00000_01001_01001_00101_000000;
		mem[8] = 32'b101011_00000_01001_0000000000000010;
		mem[9] = 32'b001000_00000_01100_0000000000000111;
		mem[10] = 32'b101011_00000_01100_0000000000000011;
		mem[11] = 32'b000010_00000000000000000001000100;
		mem[12] = 32'b001000_00000_01100_0000000000000110;
		mem[13] = 32'b101011_00000_01100_0000000000000010;
		mem[14] = 32'b100011_00000_01001_0000000000000011;
		mem[15] = 32'b000000_00000_01001_01001_00010_000000;
		mem[16] = 32'b101011_00000_01001_0000000000000011;
	end

	assign dataOut = mem[adrx];

endmodule
