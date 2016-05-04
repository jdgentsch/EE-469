//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 2: SRAM module for our memory subsystem
//EE 469 with James Peckol 4/8/16
module sram (data, clk, adrx, nOE, read);
	inout [31:0] data;
	input clk;
	input [10:0] adrx;
	input nOE; //Active-low output enable
	input read;
	
	wire [31:0] mdrInput;

	reg [15:0] mem [0:2047];
	reg [10:0] mar, marIndex;
	reg [31:0] mdr;
	
	//Tristate data lines dependent on output enable signal
	assign data = ~nOE ? mdr : 32'bz;
	
	//Bidirectional data feeding into MDR
	assign mdrInput = read ? mem[mar] : data;
	
	//Updates MDR on the clock edge using the recent MAR
	//Thus we must clock data in on the negative edge
	always @(negedge clk) begin
		mdr <= mdrInput;
		marIndex <= mar;
	end
	
	//Update MAR as a typical register
	always @(posedge clk) begin
		mar <= adrx;
	end

	//Perform the write operation when read signal is strobed high
	always @(posedge read) begin
		mem[marIndex] <= mdr[15:0];
	end
endmodule
