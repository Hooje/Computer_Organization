module ALU(
           src1_i,          // 32 bits source 1          (input)
           src2_i,          // 32 bits source 2          (input)
           ctrl_i,					// 4 bits ALU control input  (input)
           result_o,        // 32 bits result_o            (output)
           zero_o          // 1 bit when the output is 0, zero_o must be set (output)
           );


	input  [32-1:0] src1_i;
	input  [32-1:0] src2_i;
	input   [4-1:0] ctrl_i;
	//input   [3-1:0] bonus_control; 

	output [32-1:0]	result_o;
	output          zero_o;

	reg    [32-1:0] result_o;   //may be use another wire to connect
	reg             zero_o;

	reg							A_invert;
	reg							B_invert;
	reg							cin;
	reg				[1:0]	operation;

	reg							less;
	reg							A_sign;
	reg							B_sign;
	reg							diff;
	reg							bus;
	wire			[31:0]C;
	wire			[31:0]outcome;
	
	ALUtop AluTop (src1_i[0],src2_i[0],less,A_invert,B_invert,cin,operation,outcome[0],C[0]);
	
	genvar i;
	generate
	for(i=1; i<32; i=i+1)
		begin: gen_loop
			ALUsingle Alu_unit (src1_i[i],src2_i[i],A_invert,B_invert,C[i-1],operation,outcome[i],C[i]);
		end
	endgenerate

	always@(*)
	begin
			cin <= 0;
			less <= result_o[31];

			bus <= |result_o;
			zero_o <= ~bus;

			case(ctrl_i)
				4'b0000:begin //bitwise AND
					A_invert <= 0;
					B_invert <= 0;
					operation <= 2'b00;
				end
				4'b0001:begin //bitwise OR
					A_invert <= 0;
					B_invert <= 0;
					operation <= 2'b01;
				end
				4'b0010:begin //Addition
					A_invert <= 0;
					B_invert <= 0;
					operation <= 2'b10;
				end
				4'b0110:begin //Subtraction
					A_invert <= 0;
					B_invert <= 1;
					operation <= 2'b10;
					cin = 1;
				end
				4'b0111:begin //set less than
					A_invert <= 0;
					B_invert <= 1;
					operation <= 2'b11;
				end
				4'b1100:begin //bitwise NOR
					A_invert <= 1;
					B_invert <= 1;
					operation <= 2'b00;
				end
				4'b1101:begin //bitwise NAND
					A_invert <= 1;
					B_invert <= 1;
					operation <= 2'b01;
				end
				default:begin
				end
			endcase
			
			result_o <= outcome;

	end

endmodule
