// Author: 0716003 鄒年城  0716079 藍世堯
module Simple_Single_CPU(
        clk_i,
        rst_i
        );
        
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles

wire RegWrite, branch, ALUSrc, zero, extend_choose,branch_judge;

wire [32-1:0]	shifter_out;
wire [2:0]		ALUOp;
wire [3:0]		ALUCtrl;
wire [4:0]		RegDout;
wire [31:0]		SignExtend;
wire [31:0]		ZeroExtend;
wire [31:0]		now_address;
wire [31:0]		next_address;
wire [31:0]		instruction;
wire [31:0]		RS;
wire [31:0]		RT;
wire [31:0]		RtALU;
wire [31:0]		extend;
wire [31:0]		extend_shift_two;
wire [31:0]		result;
wire [31:0]		branch_address;
wire [31:0]		current_program;
reg	 [31:0]		Reg_current_program=32'd0;
wire [31:0]		RsALU;
wire [31:0]		ALUoutput;
wire [31:0]		shamt;

// new wire
wire					MemIn_ctrl;
wire					shamt_ctrl;
wire					jr_ctrl;

wire [1:0]		RegDst;
wire [1:0]		BranchType;
wire [1:0]		MemToReg;
wire [31:0]		Readdata;
wire [31:0]		WriteData;
wire [31:0]		branch_or_jump;
wire [31:0]		branch_select_pc_or_not;

always @(current_program)begin
        Reg_current_program<=current_program;
end

ProgramCounter PC(
        .clk_i(clk_i),      
        .rst_i (rst_i),     
        .pc_in_i(current_program) , 
        .pc_out_o(now_address) 
        );
    
Adder Adder1(
        .src1_i(now_address),     
        .src2_i(32'd4),     
        .sum_o(next_address)
        );

Adder Adder2(
	      .src1_i(next_address),     
        .src2_i(extend_shift_two),     
        .sum_o(branch_address)      
        );
   
Instr_Memory IM(
        .pc_addr_i(now_address),  
        .instr_o(instruction)    
        );

        
Reg_File RF(
        .clk_i(clk_i),      
        .rst_i(rst_i) ,     
        .RSaddr_i(instruction[25:21]) ,  
        .RTaddr_i(instruction[20:16]) ,  
        .RDaddr_i(RegDout),  
        .RDdata_i(WriteData), 
        .RegWrite_i (RegWrite&(!jr_ctrl)),
        .RSdata_o(RS),
        .RTdata_o(RT)   
        );
    
Decoder decode(
        .instr_op_i(instruction[31:26]), 
        .RegWrite_o(RegWrite), 
        .ALU_op_o(ALUOp),   
        .ALUSrc_o(ALUSrc),   
        .RegDst_o(RegDst),
        .Branch_o(branch),
        .Extend_mux(extend_choose),  //sign or zero extension
        .MemToReg_o(MemToReg),
        .BranchType_o(BranchType),
        .Jump_o(Jump),
        .MemRead_o(MemRead),
        .MemWrite_o(MemWrite)
        );

ALU_Ctrl AC(  //notice sra
        .funct_i(instruction[5:0]),   
        .ALUOp_i(ALUOp),
				.MemIn_ctrl_o(MemIn_ctrl),
				.shamt_ctrl_o(shamt_ctrl),
				.jr_ctrl_o(jr_ctrl),
        .ALUCtrl_o(ALUCtrl)
        );
    
Sign_Extend SE(
        .data_i(instruction[15:0]),
        .data_o(SignExtend)
        );

Zero_filled Zf(
        .data_i(instruction[15:0]),
        .data_o(ZeroExtend)
        );


ALU ALU_unit(
        .src1_i(RS),
        .src2_i(RtALU),
        .ctrl_i(ALUCtrl), 
        .result_o(ALUoutput),
        .zero_o(zero)
        );
        
Shift_Left_Two_32 Shifter01(
       .data_i(extend),
       .data_o(extend_shift_two)
       );        

Shifter_under Shifter02(
			 .src1_i(RtALU),
			 .src2_i(shamt),
			 .ALUCtrl_i(ALUCtrl),
			 .data_o(shifter_out)
			 );

// new element
Data_Memory Data_Memory(
        .clk_i(clk_i),
        .addr_i(result),
        .data_i(RT),
        .MemRead_i(MemRead),
        .MemWrite_i(MemWrite),
        .data_o(Readdata)
        );






// new Mux
MUX_2to1 #(.size(32)) Mux_jr(
        .data0_i(branch_or_jump),
        .data1_i(RS),
        .select_i(jr_ctrl),
        .data_o(current_program)
        );

MUX_2to1 #(.size(32)) Jump_or_not(
        .data0_i(branch_select_pc_or_not),
        .data1_i({next_address[31:28],instruction[25:0],2'b00}),
        .select_i(Jump),
        .data_o(branch_or_jump)
        );


MUX_4to1 #(.size(1)) Branch_mux(
        .data0_i(zero),  //beq 
        .data1_i(result[31]|zero), //blez   小於等於0
        .data2_i(!result[31]&(!zero)), //bgtz  大於0
        .data3_i(!zero),       // bne
        .select_i(BranchType),  
        .data_o(branch_judge)
        );

MUX_4to1 #(.size(32)) Write_data_mux(
        .data0_i(result),
        .data1_i(Readdata),
        .data2_i(SignExtend),
        .data3_i(next_address),
        .select_i(MemToReg),
        .data_o(WriteData)
        );

MUX_3to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instruction[20:16]),
        .data1_i(instruction[15:11]),
				.data2_i(5'b11111),
        .select_i(RegDst),
        .data_o(RegDout)
        );


MUX_2to1 #(.size(32)) Mux_branch_type(			//mux for current program
        .data0_i(next_address),
        .data1_i(branch_address),
        .select_i(branch&branch_judge),
        .data_o(branch_select_pc_or_not)  // branch selct pc or not
        );

MUX_2to1 #(.size(32)) MUX_MemIn(
				.data0_i(ALUoutput),
				.data1_i(shifter_out),
				.select_i(MemIn_ctrl),
				.data_o(result)
				);

//shamt input
MUX_2to1 #(.size(32)) Mux_shamt_src(
        .data0_i({27'b0,instruction[10:6]}),
        .data1_i(RS),
        .select_i(shamt_ctrl),  //temporary
        .data_o(shamt)
        );


///
/*
Equal_To_Zero ETZ(
        .src_i(instruction[31:0]),
        .output_o(equalToZero));
*/

MUX_2to1 #(.size(32)) Mux_Extend(
        .data0_i(SignExtend),
        .data1_i(ZeroExtend),
        .select_i(extend_choose),
        .data_o(extend)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(RT),
        .data1_i(extend),
        .select_i(ALUSrc),
        .data_o(RtALU)
        );
        

endmodule
