// Author: 0716003 鄒年城  0716079 藍世堯
module jr_or_not(
	ist_i,
	output_o);

input [31:0]ist_i;
output output_o;
reg out;

assign output_o=out;

always @(ist_i) begin
	if(ist_i[31:26]==6'b000000 & ist_i[20:0]==21'd8)
	
		out=1'b1;
	else
		out=1'b0;
end

endmodule