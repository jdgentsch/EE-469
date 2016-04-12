//Jack Gentsch, Jacky Wang, Chinh Bui
//Lab 2: SRAM module for our memory subsystem
//EE 469 with James Peckol 4/8/16
module sram (data, clk, adrx, nOE, read);
	inout [15:0] data;
	input clk;
	input [10:0] adrx;
	input nOE; //Active-low output enable
	input read;
	
	wire [15:0] mdrInput;

	reg [15:0] mem [0:2047];
	reg [10:0] mar;
	reg [15:0] mdr;
	
	//Tristate data lines dependent on output enable signal
	assign data = ~nOE ? mdr : 16'bz;

	assign mdrInput = read ? mem[mar] : data;
	
	//Updates MAR and MDR every clock cycle
	always @(posedge clk)
	begin
		//Store value asserted by the SRAM
		mar <= adrx;
		mdr <= mdrInput;
	end

	//Perform the write operation when read signal is strobed high
	always @(posedge read)
		mem[mar] <= mdr;

endmodule
