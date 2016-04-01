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
// CREATED		"Thu Mar 31 22:16:25 2016"

module syncSchematic(
	clk,
	reset,
	q
);


input wire	clk;
input wire	reset;
output wire	[3:0] q;

wire	SYNTHESIZED_WIRE_11;
wire	SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;
wire	SYNTHESIZED_WIRE_3;
reg	SYNTHESIZED_WIRE_12;
reg	SYNTHESIZED_WIRE_13;
reg	DFF_inst3;
wire	SYNTHESIZED_WIRE_4;
reg	SYNTHESIZED_WIRE_14;
wire	SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_6;
wire	SYNTHESIZED_WIRE_7;
wire	SYNTHESIZED_WIRE_8;
wire	SYNTHESIZED_WIRE_10;

assign	SYNTHESIZED_WIRE_1 = 1;
assign	SYNTHESIZED_WIRE_3 = 1;
assign	SYNTHESIZED_WIRE_6 = 1;
assign	SYNTHESIZED_WIRE_8 = 1;

// These lines were manually added by the designer to ensure that the outputs were actually being connected.
assign q[3] = DFF_inst3;
assign q[2] = SYNTHESIZED_WIRE_14;
assign q[1] = SYNTHESIZED_WIRE_13;
assign q[0] = SYNTHESIZED_WIRE_12;

always@(posedge clk or negedge reset or negedge SYNTHESIZED_WIRE_1)
begin
if (!reset)
	begin
	SYNTHESIZED_WIRE_12 <= 0;
	end
else
if (!SYNTHESIZED_WIRE_1)
	begin
	SYNTHESIZED_WIRE_12 <= 1;
	end
else
	begin
	SYNTHESIZED_WIRE_12 <= SYNTHESIZED_WIRE_11;
	end
end


always@(posedge clk or negedge reset or negedge SYNTHESIZED_WIRE_3)
begin
if (!reset)
	begin
	SYNTHESIZED_WIRE_13 <= 0;
	end
else
if (!SYNTHESIZED_WIRE_3)
	begin
	SYNTHESIZED_WIRE_13 <= 1;
	end
else
	begin
	SYNTHESIZED_WIRE_13 <= SYNTHESIZED_WIRE_2;
	end
end

assign	SYNTHESIZED_WIRE_10 = ~(SYNTHESIZED_WIRE_12 | SYNTHESIZED_WIRE_13);

assign	SYNTHESIZED_WIRE_7 = DFF_inst3 ^ SYNTHESIZED_WIRE_4;

assign	SYNTHESIZED_WIRE_4 = ~(SYNTHESIZED_WIRE_14 | SYNTHESIZED_WIRE_13 | SYNTHESIZED_WIRE_12);

assign	SYNTHESIZED_WIRE_11 =  ~SYNTHESIZED_WIRE_12;


always@(posedge clk or negedge reset or negedge SYNTHESIZED_WIRE_6)
begin
if (!reset)
	begin
	SYNTHESIZED_WIRE_14 <= 0;
	end
else
if (!SYNTHESIZED_WIRE_6)
	begin
	SYNTHESIZED_WIRE_14 <= 1;
	end
else
	begin
	SYNTHESIZED_WIRE_14 <= SYNTHESIZED_WIRE_5;
	end
end


always@(posedge clk or negedge reset or negedge SYNTHESIZED_WIRE_8)
begin
if (!reset)
	begin
	DFF_inst3 <= 0;
	end
else
if (!SYNTHESIZED_WIRE_8)
	begin
	DFF_inst3 <= 1;
	end
else
	begin
	DFF_inst3 <= SYNTHESIZED_WIRE_7;
	end
end





assign	SYNTHESIZED_WIRE_2 = SYNTHESIZED_WIRE_13 ^ SYNTHESIZED_WIRE_11;

assign	SYNTHESIZED_WIRE_5 = SYNTHESIZED_WIRE_14 ^ SYNTHESIZED_WIRE_10;


endmodule
