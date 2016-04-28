//Jack Gentsch, Jacky Wang, Chinh Bui
//EE 469, Dr. Peckol 4/15/16
//A simple 32-bit zero detect module, implemented with 2-input NAND and NOR gates
module zeroDetect (zeroFlag, result);
	output zeroFlag;
	input [31:0] result;
	wire [15:0] connect0;
	wire [7:0] connect1;
	wire [3:0] connect2;
	wire [1:0] connect3;
	
	genvar i;
	generate for (i = 0; i < 16; i = i + 1) begin : first_row_ZD
		assign connect0[i] = result[2*i + 1] ~| result[2*i];
	end endgenerate
	
	genvar j;
	generate for (j = 0; j < 8; j = j + 1) begin : second_row_ZD
		assign connect1[j] = connect0[2*j + 1] ~& connect0[2*j];
	end endgenerate
	
	genvar k;
	generate for (k = 0; k < 4; k = k + 1) begin : third_row_ZD
		assign connect1[k] = connect1[2*k + 1] ~| connect1[2*k];
	end endgenerate

	genvar l;
	generate for (l = 0; l < 2; l = l + 1) begin : fourth_row_ZD
		assign connect2[l] = connect2[2*l + 1] ~& connect2[2*l];
	end endgenerate

	assign connect3[1] = connect2[3] ~& connect2[2];
	assign connect3[0] = connect2[1] ~& connect2[0];

	/*
	assign connect0[15:0] = result[31] ~| result[30];
	assign connect1[7:0] = connect0[15] ~& connect0[14];
	assign connect2[3:0] = connect1[7] ~| connect[6];
	assign connect3[1:0] = connect2[3] ~& connect2[2];
	*/
	assign zeroFlag = connect3[1] ~| connect3[0];

endmodule