// Author: 0716003 鄒年城  0716079	藍世堯
module ALU(
           src1_i,          // 32 bits source 1          (input)
           src2_i,          // 32 bits source 2          (input)
           ctrl_i,					// 4 bits ALU control input  (input)
           ALUOp_i,
           result_o,        // 32 bits result_o            (output)
           zero_o          // 1 bit when the output is 0, zero_o must be set (output)
           );

	input  [3-1:0] ALUOp_i;
	input  [32-1:0] src1_i;
	input  [32-1:0] src2_i;
	input   [4-1:0] ctrl_i;
	//input   [3-1:0] bonus_control; 

	output [32-1:0]	result_o;
	output          zero_o;

	reg    [32-1:0] result_o;   //may be use another wire to connect
	reg             zero_o;	

always@(*)
	begin
			case(ctrl_i)
				4'b0000:begin //bitwise AND
					result_o = src1_i & src2_i;
				end
				4'b0001:begin //bitwise OR
					result_o = src1_i | src2_i;	
				end
				4'b0010:begin //Addition
					result_o = src1_i + src2_i;
				end
				4'b0110:begin //Subtraction
					result_o = src1_i - src2_i;
					zero_o = result_o == 0 ? 1 : 0;
				end
				4'b0111:begin //set less than
					if (ALUOp_i==3'b000) begin
						result_o = $signed(src1_i) < $signed(src2_i) ? 1 : 0;
					end
					else begin
						result_o = src1_i < src2_i ? 1 : 0;
					end
				
				end
				default:begin
				end
			endcase
	end

endmodule