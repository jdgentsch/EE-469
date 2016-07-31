//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 5: Instruction cache module for the cpu
//EE 469 with James Peckol 6/5/16
//A 32 bit wide, 16 word, 4 block instruction cache for the cpu
//Contains the instruction memory to interface with, utilizes a tag table
//with dirty and valid bits
module icache (instructionOut, stallPC, adrx, clk, reset, imemInstructions);
	output [31:0] instructionOut;
	output reg stallPC;
	input [6:0] adrx;
	input clk, reset;
	input [127:0] imemInstructions;
	
	reg [31:0] cache [0:15];

	//Adrx = {3'bTagNum, 2'bBlockNum, 2'bBlockVal};
	//8 possible tags, with 4 blocks, and 4 words per block
	reg [2:0] tag [0:3];
	reg [3:0] valid;
	reg [3:0] dirty;
	reg [31:0] instruction;
	
	assign instructionOut = instruction;
	wire [2:0] tagNum;
	wire [1:0] blockNum;
	wire [1:0] blockDigit;
	
	//Valid bit is the highest bit of the tag table, dirty is the 2nd highest bit
	assign tagNum = adrx[6:4];
	assign blockNum = adrx[3:2];
	assign blockDigit = adrx[1:0];
	
	//Break up passed outputs from instruction memory
	wire [31:0] imemInstruction3;
	wire [31:0] imemInstruction2;
	wire [31:0] imemInstruction1;
	wire [31:0] imemInstruction0;
	
	assign imemInstruction3 = imemInstructions[127:96];
	assign imemInstruction2 = imemInstructions[95:64];
	assign imemInstruction1 = imemInstructions[63:32];
	assign imemInstruction0 = imemInstructions[31:0];
	
	parameter [31:0] NOOP = 32'b0;
	
	always @(posedge clk) begin
		//Resetting the valid bits for our data
		if (reset) begin
			{valid[3], valid[2], valid[1], valid[0]} <= 4'b0;
		//Updating the cache with data if it is invalid or the tag is not found
		end else if (!valid[blockNum] | tag[blockNum] != tagNum) begin
			instruction <= NOOP;
			stallPC <= 1'b1;
			tag[blockNum] <= tagNum;
			{dirty[3], dirty[2], dirty[1], dirty[0]} <= 4'b0;
			valid[blockNum] <= 1'b1;
			
			cache[{blockNum, 2'b11}] <= imemInstruction3;
			cache[{blockNum, 2'b10}] <= imemInstruction2;
			cache[{blockNum, 2'b01}] <= imemInstruction1;
			cache[{blockNum, 2'b00}] <= imemInstruction0;
		end else begin
			//The instruction is in cache, return it
			instruction <= cache[{blockNum, blockDigit}];
			stallPC <= 1'b0;
		end
	end
endmodule