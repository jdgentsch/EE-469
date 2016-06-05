//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 5: Data Forwarding Unit
//EE 469 with Peckol 6/1/16
//performs data forwarding to prevent data hazards
module forwarding(ForwardA, ForwardB, EX_WB_RegRd, EX_WB_RegWrite, ID_EX_Rs, ID_EX_Rt);
	output ForwardA, ForwardB;
	input [4:0] EX_WB_RegRd, ID_EX_Rs, ID_EX_Rt;
	input EX_WB_RegWrite;

	//Forwarding to the alu bus (from the reg file) will occur if:
	//The register to be read from is non-zero, we are writing to in the WB stage,
	//and the register being written (WB) and read from (EX) are identical.
	assign ForwardA = (EX_WB_RegWrite && (EX_WB_RegRd != 0) && (EX_WB_RegRd == ID_EX_Rs);
	assign ForwardB = (EX_WB_RegWrite && (EX_WB_RegRd != 0) && (EX_WB_RegRd == ID_EX_Rt);

	//parameter [1:0] REG_TO_ALU_A = 2'b00, ALU_RESULT_TO_ALU_A = 2'b10, DMEM_TO_ALU_A = 2'b01;
	//parameter [1:0] REG_TO_ALU_B = 2'b00, ALU_RESULT_TO_ALU_B = 2'b10, DMEM_TO_ALU_B = 2'b01;

	// Forwarding to ALU Bus A
	//always @(EX_WB_RegRd or WB_NX_RegRd or ID_EX_Rs or EX_WB_RegWrite or WB_NX_RegWrite) begin
		// EX Hazard || WB Hazard
	//	if ((EX_WB_RegWrite && (EX_WB_RegRd != 0) && (EX_WB_RegRd == ID_EX_Rs)) || (WB_NX_RegWrite && (WB_NX_RegRd != 0) && (WB_NX_RegRd == ID_EX_Rs)))
		//	ForwardA = ALU_RESULT_TO_ALU_A;
	//		ForwardA = 1;
		// WB Hazard
		//else if (WB_NX_RegWrite && (WB_NX_RegRd != 0) && (WB_NX_RegRd == ID_EX_Rs))
		//	ForwardA = DMEM_TO_ALU_A;
		//	ForwardA = 1;
		// No Hazard
	//	else
			//ForwardA = REG_TO_ALU_A;
	//		ForwardA = 0;
	//end

	// Forwarding to ALU Bus B
	//always @(EX_WB_RegRd or WB_NX_RegRd or ID_EX_Rt or EX_WB_RegWrite or WB_NX_RegWrite) begin
		// EX Hazard
	//	if ((EX_WB_RegWrite && (EX_WB_RegRd != 0) && (EX_WB_RegRd == ID_EX_Rt)) || (WB_NX_RegWrite && (WB_NX_RegRd != 0) && (WB_NX_RegRd == ID_EX_Rt)))
		//	ForwardB = ALU_RESULT_TO_ALU_B;
	//		ForwardB = 1;
		// Mem Hazard
		//else if (WB_NX_RegWrite && (WB_NX_RegRd != 0) && (WB_NX_RegRd == ID_EX_Rt))
		//	ForwardB = DMEM_TO_ALU_B;
		// No Hazard
	//	else
		//	ForwardB = REG_TO_ALU_B;
	//		ForwardB = 0;
	//end
endmodule