// Author: 0716003 鄒年城  0716079	藍世堯
module Adder(
    src1_i,
    src2_i,
    sum_o
    );

//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
output [32-1:0]	 sum_o;

//Internal Signals
wire	 [33-1:0]  carry;

assign carry[0] = 0;

genvar k;
generate
for(k=0;k<32;k=k+1)
	begin: gen_loop
		FullAdder fulladd (src1_i[k],src2_i[k],carry[k],carry[k+1],sum_o[k]);
	end
endgenerate

endmodule
