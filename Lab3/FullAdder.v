// Author: 0716003 鄒年城  0716079	藍世堯
module FullAdder(x,y,cin,cout,sum);
	input x, y, cin;
	output cout, sum;

	assign sum = x ^ y ^ cin;
	assign cout = (x && y) || (x && cin) || (y && cin);

endmodule
