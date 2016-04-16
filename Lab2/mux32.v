//Jack Gentsch, Jacky Wang, Chinh Bui
//EE 469, Dr. Peckol 4/15/16
// A single 32-input mux, which can be decomposed into 2-input muxes.
module mux32 (out, sel, in);
	output out;
	input [4:0] sel;
	input [31:0] in;
	wire [3:0] connect;
	
	mux8 myMux8_3 (.result(connect[3]), .sel(sel[2:0]), .in(in[31:24]));
	mux8 myMux8_2 (.result(connect[2]), .sel(sel[2:0]), .in(in[23:16]));
	mux8 myMux8_1 (.result(connect[1]), .sel(sel[2:0]), .in(in[15:8]));
	mux8 myMux8_0 (.result(connect[0]), .sel(sel[2:0]), .in(in[7:0]));
	mux4 myMux4_connect (.result(out), .sel(sel[4:3]), .in(connect[3:0]));

endmodule

// 8-input mux, composed of 4 and 2 input muxes
module mux8 (result, sel, in);
	output result;
	input [2:0] sel;
	input [7:0] in;
	wire [1:0] connect;
	
	mux4 myMux4_1 (.result(connect[1]), .sel(sel[1:0]), .in(in[7:4]));
	mux4 myMux4_0 (.result(connect[0]), .sel(sel[1:0]), .in(in[3:0]));
	mux2 myMux2_connect (.result(result), .sel(sel[2]), .in(connect[1:0]));
	
endmodule

// 4-input mux, composed of 2-input muxes
module mux4 (result, sel, in);
	output result;
	input [1:0] sel;
	input [3:0] in;
	wire [1:0] connect;
	
	mux2 myMux2_1 (.result(connect[1]), .sel(sel[0]), .in(in[3:2]));
	mux2 myMux2_0 (.result(connect[0]), .sel(sel[0]), .in(in[1:0]));
	mux2 myMux2_connect (.result(result), .sel(sel[1]), .in(connect[1:0]));
	
endmodule

// 2-input mux
module mux2 (result, sel, in);
	output result;
	input sel;
	input [1:0] in;

	bufif1(result, in[1], sel);
	bufif0(result, in[0], sel);

endmodule