// Jack Gentsch
// EE 469 4/29
// A simple module to toggle an input switch high once every 16 clock cycles
// Resists the oscillating nature of the physical buttons
module pressDetectDelay (outToggle, inPress, clk);
	output reg outToggle;
	input inPress;
	input clk;
	
	reg [2:0] state;	
	
	parameter [2:0] idle = 3'b000, countdown = 3'b111;
	
	always @(posedge clk) begin
		if (state == idle) begin
			// When the input is immediately toggled high, output is toggled for one clock cycle
			if (inPress) begin
				state <= countdown;
				outToggle <= 1'b1;
			end
		end else if (inPress) begin
			// If the input flipped while counting down, reset the countdown
			state <= countdown;
			outToggle <= 1'b0;
		end else if (~inPress) begin
			// Countdown for 16 cycles, where input is low
			state <= state - 3'b1;
			outToggle <= 1'b0;
		end
	end
endmodule