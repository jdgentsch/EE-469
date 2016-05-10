//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 4: Decode module for the control unit in our CPU
//EE 469 with James Peckol 5/7/16
module decode ();
	output [4:0] rfRdAdrx0, rfRdAdrx1, rfWrAdrx;
	output [2:0] aluCtl;
	output rfWriteEn, aluBusBSel, dmemResultSel;
	output branch; //For jumping or branching
	output [15:0] immediate;
	
	input [31:0] instruction;
	input [31:0] aluResult;
	
	wire [4:0] opcode;
	wire isImm; //True means our instruction has an immediate value
	
	assign opcode[4:0] = instruction[31:27];
	assign isImm = instruction[26];
	assign rfWrAdrx = instruction[25:21];
	assign rfRdAdrx1 = instruction[20:16];
	assign rfRdAdrx0 = instruction[15:11];
	assign immediate = instruction[15:0];
	assign aluBusBSel = ~func;
	
	parameter [4:0] nop = 5'b00000, add = 5'b00001, sub = 5'b00010, op_and = 5'b00011,
						 op_or = 5'b00100, op_xor = 5'b00101, slt = 5'b00110, sll = 5'b00111,
						 lw = 5'b01000, sw = 5'b01001, j = 5'b01010, jr = 5'b01011, bgt = 5'b01100;

	//5 bits for opcode
	//1 bit for function (imm or reg) for certain instructions
	//5 bit dest reg
	//5 bit source reg
	//16 bit imm or 5 bit reg
	
	
	//Signals dependent on opcode:
	//dmemResultSel, rfWriteEn, aluCtl
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
			pc <= {instruction[6:0], 2'b00}
		end
		jr: begin
			rfWriteEn <= 1'b0;
			aluCtl <= 3'b000;
			dmemResultSel <= 1'b0;
			pc <= {rfRdData[6:0], 2'b00};
		end
		bgt: begin
			rfWriteEn <= 1'b0;
			aluCtl <= 3'b010;
			dmemResultSel <= 1'b0;
			if (nFlag == 1'b0) begin
				branch <= 1'b1;
				pcDest <= {aluResult }
			end
		end
	endcase
	
	
	
endmodule