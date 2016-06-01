//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 5: Data Forwarding Unit
//EE 469 with Peckol 6/1/16
//performs data forwarding to prevent data hazards
module forwarding(ForwardA, ForwardB, EX_MEM_RegRd, MEM_WB_RegRd, EX_MEM_RegWrite, MEM_WB_RegWrite, ID_EX_Rs, ID_EX_Rt);
	output reg [1:0] ForwardA, ForwardB;
	input [4:0] EX_MEM_RegRd, MEM_WB_RegRd, ID_EX_Rs, ID_EX_Rt;
	input EX_MEM_RegWrite, MEM_WB_RegWrite;

	parameter [1:0] REG_TO_ALU_A = 2'b00, ALU_RESULT_TO_ALU_A = 2'b10, DMEM_TO_ALU_A = 2'b01;
	parameter [1:0] REG_TO_ALU_B = 2'b00, ALU_RESULT_TO_ALU_B = 2'b10, DMEM_TO_ALU_B = 2'b01;

	// Forwarding to ALU Bus A
	always @(EX_MEM_RegRd or MEM_WB_RegRd or ID_EX_Rs or EX_MEM_RegWrite or MEM_WB_RegWrite) begin
		// EX Hazard
		if (EX_MEM_RegWrite && (EX_MEM_RegRd != 0) && (EX_MEM_RegRd == ID_EX_Rs))
			ForwardA = ALU_RESULT_TO_ALU_A;
		// Mem Hazard
		else if (MEM_WB_RegWrite && (MEM_WB_RegRd != 0) && (MEM_WB_RegRd == ID_EX_Rs))
			ForwardA = DMEM_TO_ALU_A;
		// No Hazard
		else
			ForwardA = REG_TO_ALU_A;
	end

	// Forwarding to ALU Bus B
	always @(EX_MEM_RegRd or MEM_WB_RegRd or ID_EX_Rt or EX_MEM_RegWrite or MEM_WB_RegWrite) begin
		// EX Hazard
		if (EX_MEM_RegWrite && (EX_MEM_RegRd != 0) && (EX_MEM_RegRd == ID_EX_Rt))
			ForwardB = ALU_RESULT_TO_ALU_B;
		// Mem Hazard
		else if (MEM_WB_RegWrite && (MEM_WB_RegRd != 0) && (MEM_WB_RegRd == ID_EX_Rt))
			ForwardB = DMEM_TO_ALU_B;
		// No Hazard
		else
			ForwardB = REG_TO_ALU_B;
	end
endmodule