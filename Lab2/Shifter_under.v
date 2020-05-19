// Author: 0716003 鄒年城  0716079	藍世堯
module Shifter_under(
    src1_i,
    src2_i,
    ALUCtrl_i,
    data_o
    );

//I/O ports
input [32-1:0] src1_i;
input [32-1:0] src2_i;
input [4-1:0] ALUCtrl_i;

output [32-1:0] data_o;



reg   [32-1:0] data_o;



always @(*) begin
	case(ALUCtrl_i)

		4'b1110:data_o =$signed(src1_i)>>>src2_i;
		4'b1111:data_o =$signed(src1_i)>>>src2_i;
		4'b1010:data_o = src1_i<<16;

		default data_o=0;
		
	endcase


end

endmodule
