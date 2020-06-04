// Author: 0716003 鄒年城  0716079	藍世堯
module ALU_Ctrl(
        funct_i,
        ALUOp_i,
				MemIn_ctrl_o,
				shamt_ctrl_o,
				jr_ctrl_o,
        ALUCtrl_o
        );

//I/O ports
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;	 
output		 MemIn_ctrl_o;
output		 shamt_ctrl_o;
output		 jr_ctrl_o;
//Internal Signals
reg        [4-1:0] ALUCtrl_o;
reg								 MemIn_ctrl_o;
reg								 shamt_ctrl_o;
reg								 jr_ctrl_o;
//Select exact operation

always @(*) begin

	MemIn_ctrl_o <= 0;
	shamt_ctrl_o <= 0;
	jr_ctrl_o <= 0;

	case(ALUOp_i)
		3'b000:		//R-type, j, jal
		begin
			case(funct_i)
				6'b100001:ALUCtrl_o[3:0]<=4'b0010; //addu	/add
				6'b100011:ALUCtrl_o[3:0]<=4'b0110; //subu	/sub
				6'b100100:ALUCtrl_o[3:0]<=4'b0000; //and	/and
				6'b100101:ALUCtrl_o[3:0]<=4'b0001; //or		/or
				6'b101010:ALUCtrl_o[3:0]<=4'b0111; //slt	/slt
				6'b000011:begin
					ALUCtrl_o[3:0]<=4'b1110;				 //sra	/sra
					MemIn_ctrl_o <= 1'b1;
					shamt_ctrl_o <= 1'b0;
				end
				6'b000111:begin
					ALUCtrl_o[3:0]<=4'b1111;				 //srav	/srav
					MemIn_ctrl_o <= 1'b1;
					shamt_ctrl_o <= 1'b1;
				end

				6'b000000:begin
					ALUCtrl_o[3:0]<=4'b1011;					 //sll	/sll
					MemIn_ctrl_o <= 1'b1;
					shamt_ctrl_o <= 1'b0;
				end
				6'b011000:ALUCtrl_o[3:0]<=4'b0011;	 //mul
				6'b001000:begin
					ALUCtrl_o[3:0]<=4'b1100;	 //jr
					jr_ctrl_o <= 1'b1;
				end
			endcase
		end

		3'b001:ALUCtrl_o[3:0]<=4'b0010; //addi,lw,sw	/add
		3'b010:ALUCtrl_o[3:0]<=4'b0101; //sltiu				/slt

		3'b100:begin
			ALUCtrl_o[3:0]<=4'b1010; //lui	/lui
			MemIn_ctrl_o <= 1'b1;
		end
		3'b101:ALUCtrl_o[3:0]<=4'b0001; //ori					/or

		3'b011:ALUCtrl_o[3:0]<=4'b0110; //beq,bne,blez,bgtz	/sub

		
	endcase
end

endmodule     
