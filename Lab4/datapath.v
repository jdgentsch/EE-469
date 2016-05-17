//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 4: Datapath for the cpu
//EE 469 with Peckol 5/7/16
//Datapath connecting data memory, alu, and register file
module datapath (cFlag, nFlag, vFlag, zFlag, dmemDataIn, aluResultShort, rfRdData0Short, clk, immediate, rfRdAdrx0, rfRdAdrx1,
					  rfWrAdrx, aluCtl, rfWriteEn, aluBusBSel, dmemResultSel, dmemOutput, regDest);
	//Outputs to interface with the cpu
	output cFlag, nFlag, vFlag, zFlag;
	output [15:0] dmemDataIn;
	output [10:0] aluResultShort;
	output [8:0] rfRdData0Short;
	
	//Input control signals from the cpu
	input clk;
	input [15:0] immediate;
	input [4:0] rfRdAdrx0, rfRdAdrx1, rfWrAdrx;
	input [2:0] aluCtl;
	input rfWriteEn, aluBusBSel, dmemResultSel;
	input [15:0] dmemOutput;
	input regDest;
	
	wire [31:0] paddedImmediate;
	wire aluCFlag, aluNFlag, aluVFlag, aluZFlag;
	wire [31:0] aluBusB;
	wire [31:0] rdData0, rdData1, rfWriteData, dmemResult;
	wire [15:0] dmemOutput;
	wire [4:0] regDestAdrx;
	wire [31:0] aluResult;
	
	assign aluResultShort = aluResult[10:0];
	assign rfRdData0Short = rdData0[8:0];
	assign paddedImmediate = {{16{1'b0}}, immediate[15:0]};
	
	//Flags are instantly assigned, will become registers in the pipelined datapath
	assign cFlag = aluCFlag;
	assign nFlag = aluNFlag;
	assign vFlag = aluVFlag;
	assign zFlag = aluZFlag;
	
	//Instantiation of the ALU
	alu cpuAlu (.busOut(aluResult), .zero(aluZFlag), .overflow(aluVFlag), .carry(aluCFlag), .neg(aluNFlag),
				  .busA(rdData0), .busB(aluBusB), .control(aluCtl));
		
	//Register file instantiation, 32x32
	registerFile cpuRF (.rdData0(rdData0), .rdData1(rdData1), .rdAdrx0(rfRdAdrx0),
							  .rdAdrx1(rfRdAdrx1), .writeAdrx(regDestAdrx), .writeData(rfWriteData), .clk(clk), .writeEn(rfWriteEn));
	
	//Sign extension of the data memory output
	assign dmemResult = {{16{dmemOutput[15]}}, dmemOutput[15:0]};
	assign dmemDataIn = rdData1[15:0];
	
	//Muxing of the alu bus input and data input to the register file
	genvar i;
	generate for (i = 0; i < 32; i = i + 1) begin : aluBusBMux_gen
		mux2 aluBusBMux (.result(aluBusB[i]), .sel(aluBusBSel), .in({paddedImmediate[i], rdData1[i]}));
		mux2 resultSel (.result(rfWriteData[i]), .sel(dmemResultSel), .in({dmemResult[i], aluResult[i]}));
	end endgenerate

	//Select if data should be written back into a selected register, effectively 2 reg or 3 reg instructions
	genvar j;
	generate for (j = 0; j < 5; j = j + 1) begin : rfWriteDestMux_gen
		mux2 rfWriteDest (.result(regDestAdrx[j]), .sel(regDest), .in({rfWrAdrx[j], rfRdAdrx1[j]}));
	end endgenerate
endmodule