//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 5: Datapath for the cpu
//EE 469 with Peckol 5/25/16
//Datapath connecting data memory, alu, and register file
module pipeDatapath (execCFlag, execNFlag, execVFlag, execZFlag, dmemDataIn, aluResultShort, execRfRdData0Short,
							clk, decodeImmediate, decodeRfRdAdrx0, decodeRfRdAdrx1, decodeRfWrAdrx, decodeAluCtl,
							decodeRfWriteEn, decodeAluBusBSel, decodeDmemResultSel, dmemOutput, decodeRegDest, doBranch3Held);
	//Outputs to interface with the cpu
	output reg execCFlag, execNFlag, execVFlag, execZFlag;
	//output cFlag, nFlag, vFlag, zFlag;
	output [15:0] dmemDataIn; //Pass to dmem immediately
	output [10:0] aluResultShort; //Pass to dmem immediately
	output reg [8:0] execRfRdData0Short;
	
	//Input control signals from the cpu
	input clk;
	input [15:0] decodeImmediate;
	input [4:0] decodeRfRdAdrx0, decodeRfRdAdrx1, decodeRfWrAdrx;
	input [2:0] decodeAluCtl;
	input decodeRfWriteEn, decodeAluBusBSel, decodeDmemResultSel;
	input [15:0] dmemOutput;
	input decodeRegDest;
	input doBranch3Held;
	
	reg [15:0] execDmemOutput;
	reg [31:0] execAluResult;
	reg [4:0] execRfWrAdrx, wbRfWrAdrx;
	reg [4:0] execRfRdAdrx1, wbRfRdAdrx1;
	reg execDmemResultSel, execRfWriteEn, execRegDest;
	
	wire [31:0] execDmemResult;
	wire [31:0] paddedImmediate;
	wire aluCFlag, aluNFlag, aluVFlag, aluZFlag;
	wire [31:0] aluBusA, aluBusB;
	wire [31:0] rdData0, rdData1, rfWriteData, dmemResult;
	wire [15:0] dmemOutput;
	wire [4:0] regDestAdrx;
	wire [31:0] aluResult;
	
	wire forwardA, forwardB;
	wire [31:0] forwardedBusBIn;
	wire branchCtlExecRfWriteEn;

	//Register bank at the output of the execution stage
	always @(posedge clk) begin
		execRfRdData0Short <= rdData0[8:0];
		execCFlag <= aluCFlag;
		execNFlag <= aluNFlag;
		execVFlag <= aluVFlag;
		execZFlag <= aluZFlag;
		execDmemOutput <= dmemOutput;
		execAluResult <= aluResult;
		execRfRdAdrx1 <= decodeRfRdAdrx1;
		execRfWrAdrx <= decodeRfWrAdrx;
		execDmemResultSel <= decodeDmemResultSel;
		execRfWriteEn <= decodeRfWriteEn;
		execRegDest <= decodeRegDest;
	end
	
	//Reduce the alu result to pass as an address input to data memory
	assign aluResultShort = aluResult[10:0];
	//Bit extension of the immediate value for ALU input
	assign paddedImmediate = {{16{decodeImmediate[15]}}, decodeImmediate[15:0]};
	
	//Instantiation of the ALU
	alu cpuAlu (.busOut(aluResult), .zero(aluZFlag), .overflow(aluVFlag), .carry(aluCFlag), .neg(aluNFlag),
				  .busA(aluBusA), .busB(aluBusB), .control(decodeAluCtl));
	
	//Register file instantiation, 32x32
	registerFile cpuRF (.rdData0(rdData0), .rdData1(rdData1), .rdAdrx0(decodeRfRdAdrx0),
							  .rdAdrx1(decodeRfRdAdrx1), .writeAdrx(regDestAdrx), .writeData(rfWriteData),
							  .clk(clk), .writeEn(branchCtlExecRfWriteEn));
	
	//Sign extension of the data memory output
	assign execDmemResult = {{16{execDmemOutput[15]}}, execDmemOutput[15:0]};
	assign dmemDataIn = rdData1[15:0];
	
	assign branchCtlExecRfWriteEn = execRfWriteEn && ~doBranch3Held;
	
	//Forwarding logic for the alu bus inputs
	assign forwardA = branchCtlExecRfWriteEn && (regDestAdrx != 5'b0) && (regDestAdrx == decodeRfRdAdrx0);
	assign forwardB = branchCtlExecRfWriteEn && (regDestAdrx != 5'b0) && (regDestAdrx == decodeRfRdAdrx1);	
	
	//Muxing of the alu bus input and data input to the register file
	genvar i;
	generate for (i = 0; i < 32; i = i + 1) begin : aluBusBMux_gen
		mux2 aluBusAForwardMux (.result(aluBusA[i]), .sel(forwardA), .in({rfWriteData[i], rdData0[i]}));
		mux2 aluBusBForwardMux (.result(forwardedBusBIn[i]), .sel(forwardB), .in({rfWriteData[i], rdData1[i]}));
		mux2 aluBusBImmediateMux (.result(aluBusB[i]), .sel(decodeAluBusBSel), .in({paddedImmediate[i], forwardedBusBIn[i]}));
		mux2 resultSel (.result(rfWriteData[i]), .sel(execDmemResultSel), .in({execDmemResult[i], execAluResult[i]}));
	end endgenerate

	//Select if data should be written back into a selected register, effectively 2 reg or 3 reg instructions
	genvar j;
	generate for (j = 0; j < 5; j = j + 1) begin : rfWriteDestMux_gen
		mux2 rfWriteDest (.result(regDestAdrx[j]), .sel(execRegDest), .in({execRfWrAdrx[j], execRfRdAdrx1[j]}));
	end endgenerate
endmodule