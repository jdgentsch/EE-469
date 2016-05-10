//Jack Gentsch, Jacky Wang, Chinh Bui
//EE 469 with Peckol 5/7/16
//Datapath connecting data memory, alu, and register file
module datapath (cFlag, nFlag, vFlag, zFlag, dmemDataIn, aluResult, rfRdData, clk, immData, rfRdAdrx0, rfRdAdrx1,
					  rfWrAdrx, aluCtl, rfWriteEn, aluBusBSel, dmemResultSel, dmemOutput);
	//Outputs to interface with the cpu
	output reg cFlag, nFlag, vFlag, zFlag;
	output [15:0] dmemDataIn;
	output [31:0] aluResult;
	
	//Input control signals from the cpu
	input clk;
	input [31:0] immData;
	input [4:0] rfRdAdrx0, rfRdAdrx1, rfWrAdrx;
	input [2:0] aluCtl;
	input rfWriteEn, aluBusBSel, dmemResultSel;
	input [15:0] dmemOutput;
	
	wire aluCFlag, aluNFlag, aluVFlag, aluZFlag;
	wire [31:0] aluBusB;
	wire [31:0] rdData0, rdData1, rfWriteData, dmemResult;
	wire [15:0] dmemOutput;
	
	assign rfRdData = rdData1;
	
	//Instantiation of the ALU
	alu cpuAlu (.busOut(aluResult), .zero(aluZFlag), .overflow(aluVFlag), .carry(aluCFlag), .neg(aluNFlag),
				  .busA(rdData0), .busB(aluBusB), .control(aluCtl));
		
	//Register file instantiation, 32x32
	registerFile cpuRF (.rdData0(rdData0), .rdData1(rdData1), .rdAdrx0(rfRdAdrx0),
							  .rdAdrx1(rfRdAdrx1), .writeAdrx(rfWrAdrx), .writeData(rfWriteData), .clk(clk), .writeEn(rfWriteEn));
	
	//Sign extension of the data memory output
	assign dmemResult = {{16{dmemOutput[15]}}, dmemOutput[15:0]};
	assign dmemDataIn = rdData1[15:0];
	
	//Muxing of the alu bus input and data input to the register file
	genvar i;
	generate for (i = 0; i < 32; i = i + 1) begin : aluBusBMux_gen
		mux2 aluBusBMux (.result(aluBusB[i]), .sel(aluBusBSel), .in({rdData1[i], immData[i]}));
		mux2 resultSel (.result(rfWriteData[i]), .sel(dmemResultSel), .in({aluResult[i], dmemResult[i]}));
	end endgenerate
	
	//Flag registers for output to CPU
	always @(posedge clk) begin
		cFlag <= aluCFlag;
		nFlag <= aluNFlag;
		vFlag <= aluVFlag;
		zFlag <= aluZFlag;
	end
endmodule