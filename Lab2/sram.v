module sram (data, adrx, nOE, read);
	//Will use convention of [storedData] ram [adrx] format at the moment
	inout [15:0] data;
	input [10:0] adrx;
	input nOE;
	input read;

	reg [15:0] mem [0:2047];
	
	assign data = ~nOE ? mem[adrx][15:0] : 16'bz;
	//Perform the write operation when read signal is strobed high
	always @(posedge read)
		//Overwrites the memory at proper address using the input signal on the data bus
		mem[adrx][15:0] <= data;
endmodule