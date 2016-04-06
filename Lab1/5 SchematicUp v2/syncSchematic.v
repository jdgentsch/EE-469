// Copyright (C) 1991-2014 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, the Altera Quartus II License Agreement,
// the Altera MegaCore Function License Agreement, or other 
// applicable license agreement, including, without limitation, 
// that your use is for the sole purpose of programming logic 
// devices manufactured by Altera and sold by Altera or its 
// authorized distributors.  Please refer to the applicable 
// agreement for further details.

// PROGRAM		"Quartus II 64-Bit"
// VERSION		"Version 14.0.0 Build 200 06/17/2014 SJ Web Edition"
// CREATED		"Sun Apr 03 17:23:40 2016"

module syncSchematic(
	clk,
	reset,
	q
);


input wire	clk;
input wire	reset;
output wire	[3:0] q;

reg	out0;
reg	out1;
reg	out2;
reg	out3;
wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;
wire	SYNTHESIZED_WIRE_3;
wire	SYNTHESIZED_WIRE_4;
wire	SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_6;
wire	SYNTHESIZED_WIRE_7;
wire	SYNTHESIZED_WIRE_8;
wire	SYNTHESIZED_WIRE_9;

assign	SYNTHESIZED_WIRE_1 = 1;
assign	SYNTHESIZED_WIRE_3 = 1;
assign	SYNTHESIZED_WIRE_6 = 1;
assign	SYNTHESIZED_WIRE_8 = 1;




always@(posedge clk or negedge reset or negedge SYNTHESIZED_WIRE_1)
begin
if (!reset)
	begin
	out0 <= 0;
	end
else
if (!SYNTHESIZED_WIRE_1)
	begin
	out0 <= 1;
	end
else
	begin
	out0 <= SYNTHESIZED_WIRE_0;
	end
end


always@(posedge clk or negedge reset or negedge SYNTHESIZED_WIRE_3)
begin
if (!reset)
	begin
	out1 <= 0;
	end
else
if (!SYNTHESIZED_WIRE_3)
	begin
	out1 <= 1;
	end
else
	begin
	out1 <= SYNTHESIZED_WIRE_2;
	end
end

assign	SYNTHESIZED_WIRE_9 = out1 & out0;

assign	SYNTHESIZED_WIRE_7 = out3 ^ SYNTHESIZED_WIRE_4;

assign	SYNTHESIZED_WIRE_4 = out2 & out1 & out0;

assign	SYNTHESIZED_WIRE_0 =  ~out0;


always@(posedge clk or negedge reset or negedge SYNTHESIZED_WIRE_6)
begin
if (!reset)
	begin
	out2 <= 0;
	end
else
if (!SYNTHESIZED_WIRE_6)
	begin
	out2 <= 1;
	end
else
	begin
	out2 <= SYNTHESIZED_WIRE_5;
	end
end


always@(posedge clk or negedge reset or negedge SYNTHESIZED_WIRE_8)
begin
if (!reset)
	begin
	out3 <= 0;
	end
else
if (!SYNTHESIZED_WIRE_8)
	begin
	out3 <= 1;
	end
else
	begin
	out3 <= SYNTHESIZED_WIRE_7;
	end
end

assign	SYNTHESIZED_WIRE_2 = out1 ^ out0;

assign	SYNTHESIZED_WIRE_5 = out2 ^ SYNTHESIZED_WIRE_9;

assign	q[2] = out2;
assign	q[1] = out1;
assign	q[0] = out0;
assign	q[3] = out3;

endmodule