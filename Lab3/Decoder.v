// Author: 0716003 鄒年城  0716079	藍世堯

module Decoder(
  instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	Extend_mux,
	MemToReg_o,
	BranchType_o,
	Jump_o,
	MemRead_o,
	MemWrite_o
	);

//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output [2-1:0] RegDst_o;
output         Branch_o;
output				 Extend_mux;
output [1:0]   BranchType_o;
output				 Jump_o;

output				 MemRead_o;
output				 MemWrite_o;
output [2-1:0] MemToReg_o;

//Internal Signals
reg	[3-1:0] ALU_op_o;
reg         ALUSrc_o;
reg         RegWrite_o;
reg	[2-1:0]	RegDst_o;
reg					Branch_o;
reg					Extend_mux;
reg	[1:0]   BranchType_o;
reg					Jump_o;

reg [2-1:0] MemToReg_o;
reg			    MemRead_o;
reg					MemWrite_o;


always @(*) 
begin

	case(instr_op_i)
		6'b000000:	// R-type
			begin
				ALU_op_o[2:0]<=3'b000;
				ALUSrc_o=0;
				RegWrite_o=1;
				RegDst_o=2'b01;
				Branch_o=0;
				Extend_mux=0;
				MemRead_o=0;
				MemWrite_o=0;
				BranchType_o=2'b00;
				Jump_o=0;
				MemToReg_o = 2'b00;

			end 
		6'b001000:	//	addi
			begin
				ALU_op_o[2:0]<=3'b001;
				ALUSrc_o=1;
				RegWrite_o=1;
				RegDst_o=2'b00;
				Branch_o=0;

				Extend_mux=0;
				MemRead_o=0;
				MemWrite_o=0;
				BranchType_o=2'b00;
				Jump_o=0;
				MemToReg_o = 2'b00;
			end 
		6'b001011:	//sltiu
			begin
				ALU_op_o[2:0]<=3'b010;
				ALUSrc_o=1;
				RegWrite_o=1;
				RegDst_o=2'b00;
				Branch_o=0;
				Extend_mux=0;
				MemRead_o=0;
				MemWrite_o=0;
				BranchType_o=2'b00;
				Jump_o=0;
				MemToReg_o = 2'b00;
			end 
		6'b000100:	//	beq
			begin
				ALU_op_o[2:0]<=3'b011;
				ALUSrc_o=0;
				RegWrite_o=0;
				RegDst_o=2'b00;
				Branch_o=1;
				Extend_mux=0;
				MemRead_o=0;
				MemWrite_o=0;
				BranchType_o=2'b00;
				Jump_o=0;
				
			end 
		6'b001111:	//	lui
			begin
				ALU_op_o[2:0]<=3'b100;
				ALUSrc_o=1;
				RegWrite_o=1;
				RegDst_o=2'b00;
				Branch_o=0;
				Extend_mux=0;
				MemRead_o=0;
				MemWrite_o=0;
				BranchType_o=2'b00;
				Jump_o=0;
				MemToReg_o = 2'b00;
			end 
		6'b001101:	//	ori
			begin
				ALU_op_o[2:0]<=3'b101;
				ALUSrc_o=1;
				RegWrite_o=1;
				RegDst_o=2'b00;
				Branch_o=0;
				Extend_mux=1;
				MemRead_o=0;
				MemWrite_o=0;
				BranchType_o=2'b00;
				Jump_o=0;
				MemToReg_o = 2'b00;
			end 
		6'b000101:	//	bne
			begin
				ALU_op_o[2:0]<=3'b011;
				ALUSrc_o=0;
				RegWrite_o=0;
				RegDst_o=2'b00;
				Branch_o=1;
				Extend_mux=0;
				MemRead_o=0;
				MemWrite_o=0;
				BranchType_o=2'b11;
				Jump_o=0;
			end


		6'b100011:	// lw	
			begin
				ALU_op_o[2:0]<=3'b001;
				ALUSrc_o=1;
				RegWrite_o=1;
				RegDst_o=2'b00;
				Branch_o=0;
				MemRead_o=1;
				MemWrite_o=0;
				BranchType_o=2'b00;
				Jump_o=0;
				Extend_mux=0;
				MemToReg_o = 2'b01;
			end
		6'b101011:	//	sw
			begin
				ALU_op_o[2:0]<=3'b001;
				ALUSrc_o=1;
				RegWrite_o=0;
				RegDst_o=2'b00;
				Branch_o=0;
				MemRead_o=0;
				MemWrite_o=1;
				Extend_mux=0;
				BranchType_o=2'b00;
				Jump_o=0;
				
			end
		6'b000110:	//	blez
			begin
				ALU_op_o[2:0]<=3'b011;
				ALUSrc_o=0;
				RegWrite_o=0;
				RegDst_o=2'b00;
				Branch_o=1;
				Extend_mux=0;
				MemRead_o=0;
				MemWrite_o=0;
				BranchType_o=2'b01;
				Jump_o=0;
			end
		6'b000111:	// bgtz
			begin
				ALU_op_o[2:0]<=3'b011;
				ALUSrc_o=0;
				RegWrite_o=0;
				RegDst_o=2'b00;
				Branch_o=1;
				Extend_mux=0;
				MemRead_o=0;
				MemWrite_o=0;
				BranchType_o=2'b10;
				Jump_o=0;
			end
		6'b000010:	//	j
			begin
				ALU_op_o[2:0]<=3'b000;
				ALUSrc_o=0;
				RegWrite_o=0;
				RegDst_o=2'b00;
				Branch_o=0;
				Extend_mux=0;
				MemRead_o=0;
				MemWrite_o=0;
				BranchType_o=2'b10;
				Jump_o=1;
			end
		6'b000011:	//	jal
			begin
				ALU_op_o[2:0]<=3'b000;
				ALUSrc_o=0;
				RegWrite_o=1;
				RegDst_o=2'b10;
				Branch_o=0;
				Extend_mux=0;
				MemRead_o=0;
				MemWrite_o=0;
				BranchType_o=2'b10;
				Jump_o=1;
				MemToReg_o = 2'b11;
			end
	endcase
end
endmodule
