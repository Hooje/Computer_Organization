// Author: 0716003 鄒年城  0716079	藍世堯
module Sign_Extend(
    data_i,
    data_o
    );

//I/O ports
input   [16-1:0] data_i;
output  [32-1:0] data_o;

//Internal Signals
reg     [32-1:0] data_o;

//Sign extended

always @(data_i)
begin
	data_o[15:0] = data_i[15:0];
	data_o[31:16] = data_i[15];
end

endmodule
