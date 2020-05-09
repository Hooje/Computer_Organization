//藍世堯 0716079
module FullAdder(x,y,cin,cout,sum);
	input x, y, cin;
	output cout, sum;

	assign sum = x ^ y ^ cin;
	assign cout = (x && y) || (x && cin) || (y && cin);

endmodule
