//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 4: Decode module for the control unit in our CPU
//EE 469 with James Peckol 5/7/16
//Instruction decoder for the cpu - utilizes behavioral case statements to determine
//outputs on the control bus. Inputs include the current instruction and flags.
module decode (rfRdAdrx0, rfRdAdrx1, rfWrAdrx, aluCtl, rfWriteEn, aluBusBSel, dmemResultSel,
			   dmemWrite, branchCtl, regDest, immediate, pcDest, instruction,
				cFlag, nFlag, vFlag, zFlag);
	output [4:0] rfRdAdrx0, rfRdAdrx1, rfWrAdrx;
	output reg [2:0] aluCtl;
	output reg rfWriteEn, aluBusBSel, dmemResultSel, dmemWrite;
	output reg [1:0] branchCtl; //For branching
	output reg regDest;
	output [15:0] immediate;
	output [8:0] pcDest;
	
	input [31:0] instruction;
	input cFlag, nFlag, vFlag, zFlag;
	
	wire [5:0] opcode;
	wire [5:0] funct;
	
	assign opcode[5:0] = instruction[31:26];
	assign funct[5:0] = instruction[5:0];
	
	assign rfRdAdrx0 = instruction[25:21];
	assign rfRdAdrx1 = instruction[20:16];
	assign rfWrAdrx = instruction[15:11];
	assign immediate = instruction[15:0];
	assign pcDest = immediate[8:0];
	
	//Opcodes for our instructions
	//Add, sub, and, or, xor, slt, sll, jr are all register type
	parameter [5:0] op_reg = 6'b000000, lw = 6'b100011, sw = 6'b101011, 
						 j = 6'b000010, bne = 6'b000101, addi = 6'b001000; //made our own bgt opcode

	//Function parameters for the register instructions
	parameter [5:0] op_add = 6'b100000, op_sub = 6'b100010, op_and = 6'b100100, op_or = 6'b100101,
						 op_xor = 6'b100110, op_slt = 6'b101010, op_sll = 6'b000000, op_jr = 6'b001000;

	// ALU bus B source
	parameter REG1 = 1'b0, IMMEDIATE = 1'b1;

	// Determine what drives the write register (regDest)
	parameter RT = 1'b0, RD = 1'b1; // either a destination reg (RD) or reuse reg 1 (RT)

	// ALU control operations
	parameter [2:0] NOP = 3'b000, ADD = 3'b001, SUB = 3'b010, AND = 3'b011,
						 OR = 3'b100,  XOR = 3'b101, SLT = 3'b110, SLL = 3'b111;

	// data memory result select
	parameter FROM_ALU = 1'b0, FROM_DMEM = 1'b1;
	
	// Jump or Branch, controls the PC
	parameter [1:0] NO_BR = 2'b00, BRANCH = 2'b01, JUMP = 2'b10, JUMP_REG = 2'b11;
	
	always @(*) begin
		case (opcode)
			op_reg: begin
				case (funct)
					op_add: begin
						rfWriteEn <= 1'b1;
						aluCtl <= ADD;
						aluBusBSel <= REG1;
						dmemResultSel <= FROM_ALU;
						regDest <= RD;
						branchCtl <= NO_BR;
						dmemWrite <= 1'b0;
					end
					op_sub: begin
						rfWriteEn <= 1'b1;
						aluCtl <= SUB;
						aluBusBSel <= REG1;
						dmemResultSel <= FROM_ALU;
						regDest <= RD;
						branchCtl <= NO_BR;
						dmemWrite <= 1'b0;
					end
					op_and: begin
						rfWriteEn <= 1'b1;
						aluCtl <= AND;
						aluBusBSel <= REG1;
						dmemResultSel <= FROM_ALU;
						regDest <= RD;
						branchCtl <= NO_BR;
						dmemWrite <= 1'b0;
					end
					op_or: begin
						rfWriteEn <= 1'b1;
						aluCtl <= OR;
						aluBusBSel <= REG1;
						dmemResultSel <= FROM_ALU;
						regDest <= RD;
						branchCtl <= NO_BR;
						dmemWrite <= 1'b0;
					end
					op_xor: begin
						rfWriteEn <= 1'b1;
						aluCtl <= XOR;
						aluBusBSel <= REG1;
						dmemResultSel <= FROM_ALU;
						regDest <= RD;
						branchCtl <= NO_BR;
						dmemWrite <= 1'b0;
					end
					op_slt: begin
						rfWriteEn <= 1'b1;
						aluCtl <= SLT;
						aluBusBSel <= REG1;
						dmemResultSel <= FROM_ALU;
						regDest <= RD;
						branchCtl <= NO_BR;
						dmemWrite <= 1'b0;
					end
					op_sll: begin
						rfWriteEn <= 1'b1;
						aluCtl <= SLL;
						aluBusBSel <= REG1;
						dmemResultSel <= FROM_ALU;
						regDest <= RD;
						branchCtl <= NO_BR;
						dmemWrite <= 1'b0;
					end
					op_jr: begin
						rfWriteEn <= 1'b0;
						aluCtl <= NOP;
						aluBusBSel <= REG1;
						dmemResultSel <= FROM_ALU;
						regDest <= RD;
						branchCtl <= JUMP_REG;
						dmemWrite <= 1'b0;
					end
					default: begin
						rfWriteEn <= 1'b0;
						aluCtl <= NOP;
						aluBusBSel <= REG1;
						dmemResultSel <= FROM_ALU;
						regDest <= RD;
						branchCtl <= NO_BR;
						dmemWrite <= 1'b0;
					end
				endcase
			end
			lw: begin
				rfWriteEn <= 1'b1;
				aluCtl <= ADD;
				aluBusBSel <= IMMEDIATE;
				dmemResultSel <= FROM_DMEM;
				regDest <= RT;
				branchCtl <= NO_BR;
				dmemWrite <= 1'b0;
			end
			sw: begin
				rfWriteEn <= 1'b0;
				aluCtl <= ADD;
				aluBusBSel <= IMMEDIATE;
				dmemResultSel <= FROM_ALU;
				regDest <= RT;
				branchCtl <= NO_BR;
				dmemWrite <= 1'b1;
			end
			j: begin
				rfWriteEn <= 1'b0;
				aluCtl <= NOP;
				aluBusBSel <= IMMEDIATE;
				dmemResultSel <= FROM_ALU;
				regDest <= RT;
				branchCtl <= JUMP;
				dmemWrite <= 1'b0; 
			end
			bne: begin
				rfWriteEn <= 1'b0;
				aluCtl <= SUB;
				aluBusBSel <= IMMEDIATE;
				dmemResultSel <= FROM_ALU;
				regDest <= RT;
				if (~zFlag) begin
					branchCtl <= BRANCH;
				end else begin
					branchCtl <= NO_BR;
				end
				dmemWrite <= 1'b0;
			end
			addi: begin
				rfWriteEn <= 1'b1;
				aluCtl <= ADD;
				aluBusBSel <= IMMEDIATE;
				dmemResultSel <= FROM_ALU;
				regDest <= RT;
				branchCtl <= NO_BR;
				dmemWrite <= 1'b0;
			end
			default: begin
				rfWriteEn <= 1'b0;
				aluCtl <= NOP;
				aluBusBSel <= IMMEDIATE;
				dmemResultSel <= FROM_ALU;
				regDest <= RT;
				branchCtl <= NO_BR;
				dmemWrite <= 1'b0;
			end
		endcase
	end
endmodule