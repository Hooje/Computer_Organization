module Zero_filled(data_i,data_o);
	input [16-1:0] data_i;
	output [32-1:0] data_o;

	assign data_o[15:0] = data_i[15:0];
	assign data_o[31:0] = 16'b0000000000000000;

endmodule
