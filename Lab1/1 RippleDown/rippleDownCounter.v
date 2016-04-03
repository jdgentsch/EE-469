// A four-stage ripple up counter with active low reset - Counter 1 of EE 469 Lab 1
// Note that this lower level module is the gate level model of the counter.

// Written by Jack Gentsch, Jacky Wang, and Chinh Bui
// 4/3/2016 instructed by Professor Peckol

module rippleDownCounter(out[3:0], clk, rst);

	//Attaches outputs, clock, and reset to upper level module
	output wire [3:0] out;
	wire [3:0] flip;
	input wire clk, rst;

	//Construction of flip-flops. Connected to create an asynchronous up counter.
	DFlipFlop ff0 (.q(out[0]), .qBar(flip[0]), .D(flip[0]), .clk(clk), .rst(rst));
	DFlipFlop ff1 (.q(out[1]), .qBar(flip[1]), .D(flip[1]), .clk(out[0]), .rst(rst));
	DFlipFlop ff2 (.q(out[2]), .qBar(flip[2]), .D(flip[2]), .clk(out[1]), .rst(rst));
	DFlipFlop ff3 (.q(out[3]), .qBar(flip[3]), .D(flip[3]), .clk(out[2]), .rst(rst));

endmodule

//DFlipFlop module given in lab documentation
module DFlipFlop(q, qBar, D, clk, rst);
	input D, clk, rst;
	output q, qBar;
	reg q;
	not n1 (qBar, q);
		//Note that DFF is implicitly active low reset
		always@ (negedge rst or posedge clk)
			begin
				if(!rst)
					q = 0;
				else
					q = D;
			end
endmodule
