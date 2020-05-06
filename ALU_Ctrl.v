// Author: 0716003 鄒年城  0716079	藍世堯
module ALU_Ctrl(
        funct_i,
        ALUOp_i,
        ALUCtrl_o
        );

//I/O ports
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;

//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Select exact operation

always @(*) begin
	ALUSrc2_o=1'b0;
	case(ALUOp_i)
		3'b000:
			case(funct_i)
				6'b100001:ALUCtrl_o[3:0]<=4'b0010; //addu
				6'b100011:ALUCtrl_o[3:0]<=4'b0110; //subu
				6'b100100:ALUCtrl_o[3:0]<=4'b0000; //and
				6'b100101:ALUCtrl_o[3:0]<=4'b0001; //or
				6'b101010:ALUCtrl_o[3:0]<=4'b0111; //slt
				6'b000011:ALUCtrl_o[3:0]<=4'b1000; //sra
				6'b000111:ALUCtrl_o[3:0]<=4'b1000; //srav
			endcase
		3'b001:ALUCtrl_o[3:0]<=4'b0010; //addi
		3'b010:ALUCtrl_o[3:0]<=4'b0111; //sltiu
		3'b011:ALUCtrl_o[3:0]<=4'b0110; //beq
		3'b100:ALUCtrl_o[3:0]<=4'b1001; //lui
		3'b101:ALUCtrl_o[3:0]<=4'b0001; //0001
		3'b110:ALUCtrl_o[3:0]<=4'b1010; //bne
	endcase
end

endmodule     