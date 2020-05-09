`timescale 1ns/1ps

module ALUtop(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               cout       //1 bit carry out(output)
               );

input         src1;
input         src2;
input         less;
input         A_invert;
input         B_invert;
input         cin;
input			[1:0]operation;

output        result;
output        cout;

reg           result;

reg A_bar,B_bar;
reg A, B;
wire sum;

FullAdder M1 (A, B, cin, cout, sum);

always@( * )
begin
	A_bar <= ~src1;
	B_bar <= ~src2;
	A <= (A_invert) ? A_bar : src1;
	B <= (B_invert) ? B_bar : src2;
	case(operation)
		0:begin
			result <= A & B;
		end
		1:begin
			result <= A | B;
		end
		2:begin
			result <= sum;
		end
		3:begin
			result <= less;
		end
		default:begin
		end
	endcase;
end

endmodule
