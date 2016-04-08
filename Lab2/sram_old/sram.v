//Jack Gentsch & Jacky Wang
//EE 371 Professor Peckol 10/29/15
//Lab 2 - Developing an SRAM & Calculator

//A Static Random Access Memory module that is meant to interface with a processing unit

//In & out ports consist of 8 parallel wires, an input byte chooses the address to access in the RAM,
//and the system will either read from RAM or write to RAM based on the configuration of the
//active low input signals, "not output enable" and "read not write"

//This specific RAM consists of 128 addresses, each containing one byte of data.
module sram (data, adrx, notOuten, read);
	//Will use convention of [storedData] ram [adrx] format at the moment
	inout [7:0] data;
	input [7:0] adrx;
	input notOuten;
	input read;
	wire outen;
	reg [7:0] ram [0:127];
	
	assign data = ~notOuten ? ram[adrx][7:0] : 8'bz;
	//Perform the write operation when read signal is strobed high
	always @(posedge read)
		//Overwrites the memory at proper address using the input signal on the data bus
		ram[adrx][7:0] <= data;
endmodule