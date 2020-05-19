// Author: 0716003 鄒年城  0716079	藍世堯
module Shift_Left_Two_32(
    data_i,
    data_o
    );

//I/O ports
input [32-1:0] data_i;
output [32-1:0] data_o;

assign data_o = data_i << 2;

endmodule
