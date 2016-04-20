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
	reg [10:0] mar;
	reg [31:0] mdr;
	
	//Tristate data lines dependent on output enable signal
	assign data = ~nOE ? mdr : 32'bz;

	assign mdrInput = read ? mem[mar] : data;
	
	//Updates MAR and MDR every clock cycle
	always @(negedge clk)
	begin
		//Store value asserted by the SRAM
		//mar <= adrx;
		mdr <= mdrInput;
	end
	
	always @(clk) begin
		mar <= adrx;
	end
	//always @(posedge clk)
	//	mar <= adrx;

	//Perform the write operation when read signal is strobed high
	always @(posedge read)
		mem[mar] <= mdr[15:0];

endmodule
