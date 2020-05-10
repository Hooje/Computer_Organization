// Author: 0716003 鄒年城  0716079	藍世堯
module Shifter(
				data_i,
				data_o,
				shamt,
				direction
			);

input [32-1:0] data_i;
input [4:0] shamt;
input direction;

output [32-1:0] data_o;
reg [32-1:0] data_o;

always @(*)
begin
	if(direction == 1)
		data_o = data_i >> shamt;
	else
		data_o = data_i << shamt;
end

endmodule
