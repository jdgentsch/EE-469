//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 4: Decode module for the control unit in our CPU
//EE 469 with James Peckol 5/7/16
module decode (rfRdAdrx0, rfRdAdrx1, rfWrAdrx, aluCtl, rfWriteEn, aluBusBSel, dmemResultSel,
					branch, jump, regDest, immediate, pcDest, instruction, aluResult);
	output [4:0] rfRdAdrx0, rfRdAdrx1, rfWrAdrx;
	output reg [2:0] aluCtl;
	output reg rfWriteEn, aluBusBSel, dmemResultSel;
	output reg branch; //For branching
	output reg jump; // For jumping
	output reg regDest;
	output [15:0] immediate;
	output reg [8:0] pcDest;
	
	input [31:0] instruction;
	input [31:0] aluResult;
	
	wire [5:0] opcode;
	wire [5:0] funct;
	
	assign opcode[5:0] = instruction[31:26];
	assign funct[5:0] = instruction[5:0];
	
	assign rfRdAdrx0 = instruction[25:21];
	assign rfRdAdrx1 = instruction[20:16];
	assign rfWrAdrx = instruction[15:11];
	assign immediate = instruction[15:0];
	
	//Opcodes for our instructions
	//Add, sub, and, or, xor, slt, sll, jr are all register type
	parameter [5:0] op_reg = 6'b000000, lw = 6'b100011, sw = 6'b101011, 
						 j = 6'b000010, bgt = 6'b000111, addi = 6'b001000; //made our own bgt opcode

	//Function parameters for the register instructions
	parameter [5:0] add = 6'b100000, sub = 6'b100010, op_and = 6'b100100, op_or = 6'b100101,
						 op_xor = 6'b100110, slt = 6'b101010, sll = 6'b000000, jr = 6'b001000;

	// ALU bus B source
	parameter REG1 = 1'b0, IMMEDIATE = 1'b1;

	// Determine what drives the write register (regDest)
	parameter RT = 1'b0, RD = 1'b1; // either a destination reg (RD) or reuse reg 1 (RT)

	// ALU control operations
	parameter [2:0] NOP = 3'b000, ADD = 3'b001, SUB = 3'b010, AND = 3'b011, OR = 3'b100,
					XOR	= 3'b101, SLT = 3'b110, SLL = 3'b111;
	

	always @(*) begin
		case (opcode)
			op_reg: begin
				case (funct)
					add: begin
						rfWriteEn <= 1'b1;
						aluCtl <= ADD;
						aluBusBSel <= REG1;
						dmemResultSel <= 1'b0;
						regDest <= RD;
						branch <= 1'b0;
					end
					sub: begin
						rfWriteEn <= 1'b1;
						aluCtl <= SUB;
						aluBusBSel <= REG1;
						dmemResultSel <= 1'b0;
						regDest <= RD;
						branch <= 1'b0;
					end
					op_and: begin
						rfWriteEn <= 1'b1;
						aluCtl <= AND;
						aluBusBSel <= REG1;
						dmemResultSel <= 1'b0;
						regDest <= RD;
						branch <= 1'b0;
					end
					op_or: begin
						rfWriteEn <= 1'b1;
						aluCtl <= OR;
						aluBusBSel <= REG1;
						dmemResultSel <= 1'b0;
						regDest <= RD;
						branch <= 1'b0;
					end
					op_xor: begin
						rfWriteEn <= 1'b1;
						aluCtl <= XOR;
						aluBusBSel <= REG1;
						dmemResultSel <= 1'b0;
						regDest <= RD;
						branch <= 1'b0;
					end
					slt: begin
						rfWriteEn <= 1'b1;
						aluCtl <= SLT;
						aluBusBSel <= REG1;
						dmemResultSel <= 1'b0;
						regDest <= RD;
						branch <= 1'b0;
					end
					sll: begin
						rfWriteEn <= 1'b1;
						aluCtl <= SLL;
						aluBusBSel <= REG1;
						dmemResultSel <= 1'b0;
						regDest <= RD;
						branch <= 1'b0;
					end
					jr: begin
						rfWriteEn <= 1'b0;
						aluCtl <= NOP;
						aluBusBSel <= REG1;
						dmemResultSel <= 1'b0;
						regDest <= RD;
						branch <= 1'b1;
						//jump <= 1'b1;
						//pcDest <= rdData1???
					end
					default: begin
						rfWriteEn <= 1'b0;
						aluCtl <= NOP;
						aluBusBSel <= REG1;
						dmemResultSel <= 1'b0;
						regDest <= RD;
						branch <= 1'b0;
					end
				endcase
			end
			lw: begin
				rfWriteEn <= 1'b1;
				aluCtl <= ADD;
				aluBusBSel <= IMMEDIATE;
				dmemResultSel <= 1'b1;
				regDest <= RT;
				branch <= 1'b0;
			end
			sw: begin
				rfWriteEn <= 1'b0;
				aluCtl <= ADD;
				aluBusBSel <= IMMEDIATE;
				dmemResultSel <= 1'b0;
				regDest <= RT;
				branch <= 1'b0;
			end
			j: begin
				rfWriteEn <= 1'b0;
				aluCtl <= NOP;
				aluBusBSel <= IMMEDIATE;
				dmemResultSel <= 1'b0;
				regDest <= RT;
				pcDest <= instruction[25:0];
				branch <= 1'b1; 
			end
			bgt: begin
				rfWriteEn <= 1'b0;
				aluCtl <= SUB;
				aluBusBSel <= IMMEDIATE;
				dmemResultSel <= 1'b0;
				regDest <= RT;
				if (~nFlag & ~zFlag) begin
					branch <= 1'b1;
					pcDest <= immediate;
				end else begin
					branch <= 1'b0;
				end
			end
			addi: begin
				rfWriteEn <= 1'b0;
				aluCtl <= ADD;
				aluBusBSel <= IMMEDIATE;
				dmemResultSel <= 1'b0;
				regDest <= RT;
				branch <= 1'b0;
			end
			default: begin
				rfWriteEn <= 1'b0;
				aluCtl <= NOP;
				aluBusBSel <= IMMEDIATE;
				dmemResultSel <= 1'b0;
				regDest <= RT;
				branch <= 1'b0;
			end
		endcase
	end
endmodule