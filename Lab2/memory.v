module memory (rdRF1, rdRF0, data, clk, sramAdrx, sramNotOutEn, sramRead,
					rfWriteAdrx, rfRdAdrx1, rfRdAdrx0, rfWriteEn, dataMuxSel);
	// Read data buses, to be redirected by control logic, potentially back into inputs
	output [31:0] rdRF1;
	output [31:0] rdRF0;
	inout [31:0] data;
	input clk;
	
	// Sram input control signals
	input [10:0] sramAdrx;
	input sramNotOutEn;
	input sramRead;
	
	//Register file input control signals
	input [4:0] rfWriteAdrx, rfRdAdrx1, rfRdAdrx0;
	input rfWriteEn;
	
	//Multiplexer control signals
	//Data is either rdRF1(2), rdRF0(3), or high Z(0 or 1)
	input [1:0] dataMuxSel;
	
	//Data bus multiplexing using control signals
		genvar i;
		generate for (i = 0; i < 32; i = i + 1) begin : data_bus_gen
			mux4 dataBusMux (.result(data[i]), .sel(dataMuxSel), .in({rdRF1[i], rdRF0[i], 1'bz, 1'bz}));
		end endgenerate
	
	//Instantiation of the register file and sram, with data buses that may be connected
	//utilizing control logic in the CPU.
	registerFile  myRegFile (.rdData0(rdRF0), .rdData1(rdRF1), .rdAdrx0(rfRdAdrx0), .rdAdrx1(rfRdAdrx1),
									 .writeAdrx(rfWriteAdrx), .writeData(data), .clk(clk), .writeEn(rfWriteEn));
	sram mySram (.data(data), .clk(clk), .adrx(sramAdrx), .nOE(sramNotOutEn), .read(sramRead));

endmodule