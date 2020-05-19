// Author: 0716003 鄒年城  0716079	藍世堯

module Decoder(
    instr_op_i,
    RegWrite_o,
    ALU_op_o,
    ALUSrc_o,
    RegDst_o,
    Branch_o,
    Extend_mux
    );


//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output				 Extend_mux;

//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
reg    		   Extend_mux;



always @(*) 
begin

	case(instr_op_i)
		6'b000000:
			begin
				ALU_op_o[2:0]<=3'b000;
				ALUSrc_o=0;
				RegWrite_o=1;
				RegDst_o=1;
				Branch_o=0;
				Extend_mux=0;
			end 
		6'b001000:
			begin
				ALU_op_o[2:0]<=3'b001;
				ALUSrc_o=1;
				RegWrite_o=1;
				RegDst_o=0;
				Branch_o=0;

				Extend_mux=0;
			end 
		6'b001011:
			begin
				ALU_op_o[2:0]<=3'b010;
				ALUSrc_o=1;
				RegWrite_o=1;
				RegDst_o=0;
				Branch_o=0;
				Extend_mux=0;
			end 
		6'b000100:
			begin
				ALU_op_o[2:0]<=3'b011;
				ALUSrc_o=0;
				RegWrite_o=0;
				RegDst_o=0;
				Branch_o=1;
				Extend_mux=0;
			end 
		6'b001111:
			begin
				ALU_op_o[2:0]<=3'b100;
				ALUSrc_o=1;
				RegWrite_o=1;
				RegDst_o=0;
				Branch_o=0;
				Extend_mux=0;
			end 
		6'b001101:
			begin
				ALU_op_o[2:0]<=3'b101;
				ALUSrc_o=1;
				RegWrite_o=1;
				RegDst_o=0;
				Branch_o=0;
				Extend_mux=1;
			end 
		6'b000101:
			begin
				ALU_op_o[2:0]<=3'b110;
				ALUSrc_o=0;
				RegWrite_o=0;
				RegDst_o=0;
				Branch_o=1;
				Extend_mux=0;
			end
	endcase
end
endmodule
