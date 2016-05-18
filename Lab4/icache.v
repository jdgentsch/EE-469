//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 4: Instruction memory module for the cpu
//EE 469 with James Peckol 5/7/16
//A 32 bit wide, 128 words long instruction memory for the cpu
module icache (dataOut, adrx);
	output [31:0] dataOut;
	input [6:0] adrx;
	
	reg [31:0] mem [0:15];
	//Our main imem is 128 words, thus the tag need only be 5 bits
	//(two additional bits are redundant because they note the offset)
	reg [4:0] tag [0:1];
	reg valid [0:1];
	reg dirty [0:1];
	
	wire [3:0] memSelect;
	
	assign memSelect = adrx[3:0];
	assign dataOut = mem[memSelect];

	imem cpuInstructionMem (dataOut, adrx);
	
	initial begin
		mem[3:0] = imem[block[0]];
		valid[0] = 4'b1;
		dirty[0] = 4'b0;
	end
	
	always @(posedge clk) begin
		if (tag[3] != {adrx[6:4], 2'b11}) begin
			mem[15] = imem[{adrx[6:4], 2'b11, 2'b11}];
			mem[14] = imem[{adrx[6:4], 2'b11, 2'b10}];
			mem[13] = imem[{adrx[6:4], 2'b11, 2'b01}];
			mem[12] = imem[{adrx[6:4], 2'b11, 2'b00}];
		end if (tag[2] != {adrx[6:4], 2'b10}) begin
			//load block 3;
		end if (tag[1] != {adrx[6:4], 2'b01}) begin
			//load block 2;
		end if (tag[0] != {adrx[6:4], 2'b00}) begin
			//load block 1;
		end
	end
	
endmodule
