module Simple_Single_CPU(
        clk_i,
        rst_i
        );
        
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles

wire RegDst, RegWrite, branch, ALUSrc, zero, extend_choose;
wire branch_judge;

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
wire [31:0]		address_after_adder;
wire [31:0]		current_program;
reg	 [31:0]		Reg_current_program=32'd0;
wire [31:0]		RsALU;
wire [31:0]		ALUoutput;

wire [31:0]		shamt;


always @(current_program)begin
        Reg_current_program<=current_program;
end

ProgramCounter PC(
        .clk_i(clk_i),      
        .rst_i (rst_i),     
        .pc_in_i(Reg_current_program) , 
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
        .sum_o(address_after_adder)      
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
        .RDdata_i(result)  , 
        .RegWrite_i (RegWrite),
        .RSdata_o(RS),
        .RTdata_o(RT)   
        );
    
Decoder Decoder(
        .instr_op_i(instruction[31:26]), 
        .RegWrite_o(RegWrite), 
        .ALU_op_o(ALUOp),   
        .ALUSrc_o(ALUSrc),   
        .RegDst_o(RegDst),
        .Branch_o(branch),
        .Extend_mux(extend_choose)  //here
        );

ALU_Ctrl AC(  //notice sra
        .funct_i(instruction[5:0]),   
        .ALUOp_i(ALUOp),   
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





MUX_2to1 #(.size(1)) MUX_bne_beq(
				.data0_i(!zero),
				.data1_i(zero),
				.select_i(ALUOp[0]),
				.data_o(branch_judge)
				);

MUX_2to1 #(.size(32)) Mux_PC_Src(			//mux for current program
        .data0_i(next_address),
        .data1_i(address_after_adder),
        .select_i(branch&branch_judge),
        .data_o(current_program)
        );

MUX_2to1 #(.size(32)) MUX_result_Src(
				.data0_i(ALUoutput),
				.data1_i(shifter_out),
				.select_i(ALUCtrl[3]),
				.data_o(result)
				);

//shamt input
MUX_2to1 #(.size(32)) Mux_shamt_src(
        .data0_i({27'b0,instruction[10:6]}),
        .data1_i(RS),
        .select_i(ALUCtrl[0]),  //temporary
        .data_o(shamt)
        );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instruction[20:16]),
        .data1_i(instruction[15:11]),
        .select_i(RegDst),
        .data_o(RegDout)
        );

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
