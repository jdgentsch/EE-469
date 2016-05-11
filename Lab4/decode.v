//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 4: Decode module for the control unit in our CPU
//EE 469 with James Peckol 5/7/16
module decode (rfRdAdrx0, rfRdAdrx1, rfWrAdrx, aluCtl, rfWriteEn, aluBusBSel, dmemResultSel,
					branch, jump, immediate, pcDest, instruction, aluResult);
	output [4:0] rfRdAdrx0, rfRdAdrx1, rfWrAdrx;
	output [2:0] aluCtl;
	output rfWriteEn, aluBusBSel, dmemResultSel;
	output branch; //For branching
	output jump; // For jumping
	output [15:0] immediate;
	output [8:0] pcDest;
	
	input [31:0] instruction;
	input [31:0] aluResult;
	
	wire [4:0] opcode;
	wire isImm; //True means our instruction has an immediate value
	/*
	assign opcode[4:0] = instruction[31:27];
	assign isImm = instruction[26];
	assign rfWrAdrx = instruction[25:21];
	assign rfRdAdrx1 = instruction[20:16];
	assign rfRdAdrx0 = instruction[15:11];
	assign immediate = instruction[15:0];
	assign aluBusBSel = ~func;
	*/
	//Add, sub, and, or, xor, slt, sll, jr are all register type
	parameter [5:0] add = 6'b000000, sub = 6'b000000, op_and = 6'b000000,
						 op_or = 6'b000000, op_xor = 6'b000000, slt = 6'b000000, sll = 6'b000000,
						 lw = 6'b100011, sw = 6'b101011, j = 6'b000010, jr = 6'b000000, bgt = 6'b000111; //made our own bgt opcode

	//5 bits for opcode
	//1 bit for function (imm or reg) for certain instructions
	//5 bit dest reg
	//5 bit source reg
	//16 bit imm or 5 bit reg
	
	//Signals dependent on opcode:
	//dmemResultSel, rfWriteEn, aluCtl
	always @(*) begin
		case (opcode)
			nop: begin
				rfWriteEn <= 1'b0;
				aluCtl <= 3'b000;
				dmemResultSel <= 1'b0;
			end
			add: begin
				rfWriteEn <= 1'b1;
				aluCtl <= 3'b001;
				dmemResultSel <= 1'b0;
			end
			sub: begin
				rfWriteEn <= 1'b1;
				aluCtl <= 3'b010;
				dmemResultSel <= 1'b0;
			end
			op_and: begin
				rfWriteEn <= 1'b1;
				aluCtl <= 3'b011;
				dmemResultSel <= 1'b0;
			end
			op_or: begin
				rfWriteEn <= 1'b1;
				aluCtl <= 3'b100;
				dmemResultSel <= 1'b0;
			end
			op_xor: begin
				rfWriteEn <= 1'b1;
				aluCtl <= 3'b101;
				dmemResultSel <= 1'b0;
			end
			slt: begin
				rfWriteEn <= 1'b1;
				aluCtl <= 3'b110;
				dmemResultSel <= 1'b0;
			end
			sll: begin
				rfWriteEn <= 1'b1;
				aluCtl <= 3'b111;
				dmemResultSel <= 1'b0;
			end
			lw: begin
				rfWriteEn <= 1'b1;
				aluCtl <= 3'b001;
				dmemResultSel <= 1'b1;
			end
			sw: begin
				rfWriteEn <= 1'b0;
				aluCtl <= 3'b001;
				dmemResultSel <= 1'b0;
			end
			j: begin
				rfWriteEn <= 1'b0;
				aluCtl <= 3'b000;
				dmemResultSel <= 1'b0;
				pcDest <= {instruction[6:0], 2'b00};
				jump <= 1'b1;
			end
			jr: begin
				rfWriteEn <= 1'b0;
				aluCtl <= 3'b001;
				dmemResultSel <= 1'b0;
				pcDest <= {aluResult[6:0], 2'b00};
				jump <= 1'b1;
			end
			bgt: begin
				rfWriteEn <= 1'b0;
				aluCtl <= 3'b010;
				dmemResultSel <= 1'b0;
				if (nFlag) begin
					branch <= 1'b1;
					pcDest <= {aluResult[6:0], 2'b00};
				end else begin
					branch <= 1'b0;
				end
			end
		endcase
	end
endmodule