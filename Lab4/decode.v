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
						 j = 6'b000010, bgt = 6'b000111; //made our own bgt opcode

	//Function parameters for the register instructions
	parameter [5:0] add = 6'b100000, sub = 6'b100010, op_and = 6'b100100, op_or = 6'b100101,
						 op_xor = 6'b100110, slt = 6'b101010, sll = 6'b000000, jr = 6'b001000;
	
	always @(*) begin
		case (opcode)
			op_reg: begin
				case (funct)
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
					jr: begin
						rfWriteEn <= 1'b0;
						aluCtl <= 3'b001;
						dmemResultSel <= 1'b0;
						//jump <= 1'b1;
						//pcDest <= rdData1???
					end
					default: begin
						rfWriteEn <= 1'b0;
						aluCtl <= 3'b000;
						dmemResultSel <= 1'b0;
					end
				endcase
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
				//pcDest <= {instruction[25:0], 2'b00};
				//jump <= 1'b1;
			end
			bgt: begin
				rfWriteEn <= 1'b0;
				aluCtl <= 3'b010;
				dmemResultSel <= 1'b0;
				/*if (~nFlag & ~zFlag) begin
					branch <= 1'b1;
					pcDest <= {aluResult[6:0], 2'b00};
				end else begin
					branch <= 1'b0;
				end*/
			end
			default: begin
				rfWriteEn <= 1'b0;
				aluCtl <= 3'b000;
				dmemResultSel <= 1'b0;
			end
		endcase
	end
endmodule