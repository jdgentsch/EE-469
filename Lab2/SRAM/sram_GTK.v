//Jack Gentsch & Jacky Wang
//EE 371 Professor Peckol 10/29/15
//Lab 2 - Developing an SRAM & Calculator

//The upper level module that connects the DE1-SoC to the calculator
//Interfaces with switches, button, and outputs through LED and HEX
`include "calculator.v"
module sram_GTK;
	wire [6:0] hex5, hex4, hex3, hex2, hex1, hex0;
	wire [9:0] led, switch;
	wire press, regReset, autoPress, clk;
	
	//Creates an instance of our calculator
	calculator myCalc(hex5, hex4, hex3, hex2, hex1, hex0, led,
							switch, press, regReset, autoPress, clk);

	//Declaration of the testbench module
	Tester myTest(switch, press, regReset, autoPress, clk,
						hex5, hex4, hex3, hex2, hex1, hex0, led);
	
	//Generate VCD file for gtkwave
	initial
	begin
		$dumpfile("sram_calc.vcd");
		$dumpvars(0,myCalc);
	end
endmodule

//Testbench module that sends input signals to our DUT and receives its output
module Tester (switch, press, regReset, autoPress, clk,
						hex5, hex4, hex3, hex2, hex1, hex0, led);
	output reg [9:0] switch;
	output reg press, regReset, autoPress, clk;
	input [6:0] hex5, hex4, hex3, hex2, hex1, hex0;
	input [9:0] led;
	
	parameter delay = 100;
	
	//Create a test clock dependent on the delay parameter
	always begin
		#(delay/10) clk=~clk;
	end
	
	initial begin
		//Initialize the clock, and reset the system with the "reset button"
		press = 0; regReset = 1;
		clk = 0;
		#delay
		#delay regReset = 0; #delay
		switch = 10'b0000000000; #delay //Idle state is tested first
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000001; #delay //Setup the start functionality
		autoPress = 1; //Attempt the autostart...
		#(delay * 35);
		autoPress = 0;
		
		//Before zero is manually entered into address zeros
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000101; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001001; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001101; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000010001; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000010101; #delay//5				//adrx 5
		press = 1; #delay press = 0; #delay
		switch = 10'b0000011001; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000011101; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000100001; #delay//8				//adrx 8
		press = 1; #delay press = 0; #delay
		switch = 10'b0000100101; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000101001; #delay				//adrx 10
		press = 1; #delay press = 0; #delay
		switch = 10'b0000101101; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000110001; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000110101; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000111001; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000111101; #delay				//adrx 15
		press = 1; #delay press = 0; #delay
		switch = 10'b0001000001; #delay				//adrx 16
		press = 1; #delay press = 0; #delay
		switch = 10'b0001000101; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0001001001; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0001001101; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0001010001; #delay				//adrx 20
		press = 1; #delay press = 0; #delay
		switch = 10'b0001010101; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0001011001; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0001011101; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0001100001; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0001100101; #delay				//adrx 25
		press = 1; #delay press = 0; #delay
		switch = 10'b0001101001; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0001101101; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0001110001; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0001110101; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0001111001; #delay				//adrx 30
		press = 1; #delay press = 0; #delay
		switch = 10'b0001111101; #delay				//adrx 31
		press = 1; #delay press = 0; #delay
		
		//Finished writing first 32 addresses with their index in binary
		//Manually compute the sum of these values
		switch = 10'b0000000010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000010; #delay
		press = 1; #delay press = 0; #delay
		#(delay*10);
		
		//Autocompute addition on the same values
		autoPress = 1; #delay autoPress = 0;
		#(delay * 100);
		
		//Autoenter again for additional computations
		switch = 10'b0000000001; #delay
		autoPress = 1;
		#(delay * 35);
		autoPress = 0;

		//Begin multiplication calculations on auto-entered data
		switch = 10'b0000001010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001010; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001010; #delay
		press = 1; #delay press = 0; #delay
		#(delay*10);

		//Autocompute multiplication on the same values
		autoPress = 1; #delay autoPress = 0;
		#(delay * 100);

		//Autoenter again for additional computations
		switch = 10'b0000000001; #delay
		autoPress = 1;
		#(delay * 35);
		autoPress = 0;
		
		//Begin division calculations on auto-entered data
		switch = 10'b0000001110; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001110; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001110; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001110; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001110; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001110; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001110; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001110; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001110; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001110; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001110; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001110; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001110; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001110; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001110; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000001110; #delay
		press = 1; #delay press = 0; #delay
		#(delay*10);

		//Autocompute division on the same values
		autoPress = 1; #delay autoPress = 0;
		#(delay * 100);
		
		//Begin binary encoded output on the display LEDs manually
		switch = 10'b0000000011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000000011; #delay
		press = 1; #delay press = 0; #delay
		
			
		//Begin reading output on the display 7-seg display manually
		switch = 10'b0000110011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000110011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000110011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000110011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000110011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000110011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000110011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000110011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000110011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000110011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000110011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000110011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000110011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000110011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000110011; #delay
		press = 1; #delay press = 0; #delay
		switch = 10'b0000110011; #delay
		press = 1; #delay press = 0; #delay
		
		//Finally, display hex output automatically
		//May take a long time if the clock divider is not adjusted,
		//so this will end the simulation.
		autoPress = 1; #delay autoPress = 0;
		#(delay * 100);
		$finish;
	end
endmodule
