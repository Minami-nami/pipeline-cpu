module mips (
    input clk,
    input rst//
);
    
    wire stall, fail, carry, zero, negative, overflow;
    wire [1:0] ALUsrcA, ALUsrcB, JumpRegSrc, MemWrSrc;
    wire [15:0] imm16;
    wire [4:0] shamt;
    wire [31:0] ALU_IN_A, ALU_IN_B, MEM_WRITE_EX, MEM_WRITE_MEM, MEM_WRITE_WB;

    wire bgez_IF, bgtz_IF, blez_IF, bltz_IF, bne_IF, beq_IF, useshamt_IF, RegDst_IF, Branch_IF, Jump_IF, RegWr_IF, byte_IF, MemWr_IF, MemRd_IF, link_IF, JumpReg_IF, ALUSrc_IF, SigCtr_IF;
    wire [31:0] busA_IF, busB_IF, immediate_IF, extended_shamt_IF, IF_PC, ALU_OUT_IF, DATAMEM_READ_IF, REG_WRITE_IF, ins_IF;
    wire [4:0] ALUctr_IF, rd_IF, rt_IF, rs_IF, REG_WRITE_ADDR_IF;

    wire bgez_ID, bgtz_ID, blez_ID, bltz_ID, bne_ID, beq_ID, useshamt_ID, RegDst_ID, Branch_ID, Jump_ID, RegWr_ID, byte_ID, MemWr_ID, MemRd_ID, link_ID, JumpReg_ID, ALUSrc_ID, SigCtr_ID;
    wire [31:0] busA_ID, busB_ID, immediate_ID, extended_shamt_ID, ID_PC, ALU_OUT_ID, DATAMEM_READ_ID, REG_WRITE_ID, ins_ID;
    wire [4:0] ALUctr_ID, rd_ID, rt_ID, rs_ID, REG_WRITE_ADDR_ID;

    wire bgez_EX, bgtz_EX, blez_EX, bltz_EX, bne_EX, beq_EX, useshamt_EX, RegDst_EX, Branch_EX, Jump_EX, RegWr_EX, byte_EX, MemWr_EX, MemRd_EX, link_EX, JumpReg_EX, ALUSrc_EX, SigCtr_EX;
    wire [31:0] busA_EX, busB_EX, immediate_EX, extended_shamt_EX, EX_PC, ALU_OUT_EX, DATAMEM_READ_EX, REG_WRITE_EX, ins_EX;
    wire [4:0] ALUctr_EX, rd_EX, rt_EX, rs_EX, REG_WRITE_ADDR_EX;

    wire bgez_MEM, bgtz_MEM, blez_MEM, bltz_MEM, bne_MEM, beq_MEM, useshamt_MEM, RegDst_MEM, Branch_MEM, Jump_MEM, RegWr_MEM, byte_MEM, MemWr_MEM, MemRd_MEM, link_MEM, JumpReg_MEM, ALUSrc_MEM, SigCtr_MEM;
    wire [31:0] busA_MEM, busB_MEM, immediate_MEM, extended_shamt_MEM, MEM_PC, ALU_OUT_MEM, DATAMEM_READ_MEM, REG_WRITE_MEM, ins_MEM;
    wire [4:0] ALUctr_MEM, rd_MEM, rt_MEM, rs_MEM, REG_WRITE_ADDR_MEM;

    wire bgez_WB, bgtz_WB, blez_WB, bltz_WB, bne_WB, beq_WB, useshamt_WB, RegDst_WB, Branch_WB, Jump_WB, RegWr_WB, byte_WB, MemWr_WB, MemRd_WB, link_WB, JumpReg_WB, ALUSrc_WB, SigCtr_WB;
    wire [31:0] busA_WB, busB_WB, immediate_WB, extended_shamt_WB, WB_PC, ALU_OUT_WB, DATAMEM_READ_WB, REG_WRITE_WB, ins_WB;
    wire [4:0] ALUctr_WB, rd_WB, rt_WB, rs_WB, REG_WRITE_ADDR_WB;

    fetch fetch_dut (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .fail(fail),
        .EX_OUT(ALU_OUT_EX),
        .MEM_OUT(ALU_OUT_MEM),
        .ID_OUT(busA_ID),
        .JumpRegSrc(JumpRegSrc),
        .newPC(EX_PC),
        .curPC(IF_PC),
        .ins(ins_IF)
    );

    IFIDReg IFIDReg_dut (
        .clk(clk),
        .rst(rst),
        .bubble(fail),
        .stall(stall),
        .IR_IF(ins_IF),
        .PC_IF(IF_PC),
        .IR_ID(ins_ID),
        .PC_ID(ID_PC),
        .rs(rs_ID),
        .rt(rt_ID),
        .rd(rd_ID),
        .shamt(shamt),
        .immediate(imm16)
    );

    Decode Decode_dut (
        .clk(clk),              //激励信号
        .reset(rst),
        .IR_IN(ins_ID),
        .wEn(RegWr_WB),              //使能-是否写入
        .REG_WRITE_ADDR(REG_WRITE_ADDR_WB),         //写入寄存器位置
        .REG_WRITE(REG_WRITE_WB),      //输入
        .bgez(bgez_ID),
        .bgtz(bgtz_ID),
        .blez(blez_ID),
        .bltz(bltz_ID),
        .bne(bne_ID),
        .beq(beq_ID),
        .useshamt(useshamt_ID),//是否移位
        .RegDst(RegDst_ID),//I型
        .Branch(Branch_ID),//分支语句
        .Jump(Jump_ID),//无条件跳转语句
        .RegWr(RegWr_ID),//寄存器写
        .byte(byte_ID),//存储器是否读/写字节
        .MemWr(MemWr_ID),//存储器是否写
        .MemRd(MemRd_ID),//存储器是否读
        .link(link_ID),//是否需链接
        .JumpReg(JumpReg_ID),//是否寄存器跳转
        .ALUSrc(ALUSrc_ID),
        .ALUctr(ALUctr_ID),//alu控制
        .SigCtr(SigCtr_ID),//读字节是否符号拓展
        .busA(busA_ID),     //输出A
        .busB(busB_ID),      //输出B
        .immediate(immediate_ID),
        .extended_shamt(extended_shamt_ID),
        .rd(rd_ID),
        .rt(rt_ID),
        .rs(rs_ID)
    );

    IDEXReg IDEXReg_dut (
        .clk(clk),
        .rst(rst),
        .bubble(fail),
        .stall(stall),
        .bgez_ID(bgez_ID),
        .bgtz_ID(bgtz_ID),
        .blez_ID(blez_ID),
        .bltz_ID(bltz_ID),
        .bne_ID(bne_ID),
        .beq_ID(beq_ID),
        .useshamt_ID(useshamt_ID),//是否移位
        .RegDst_ID(RegDst_ID),//I型
        .RegWr_ID(RegWr_ID),//寄存器写
        .byte_ID(byte_ID),//存储器是否读/写字节
        .MemWr_ID(MemWr_ID),//存储器是否写
        .MemRd_ID(MemRd_ID),//存储器是否读
        .link_ID(link_ID),//是否需链接
        .JumpReg_ID(JumpReg_ID),//是否寄存器跳转
        .ALUSrc_ID(ALUSrc_ID),
        .Branch_ID(Branch_ID),
        .ALUctr_ID(ALUctr_ID),//alu控制
        .SigCtr_ID,//读字节是否符号拓展
        .rt_ID(rt_ID),
        .rd_ID(rd_ID),
        .rs_ID(rs_ID),
        .extended_shamt(extended_shamt_ID),
        .immediate(immediate_ID),
        .PC_ID(ID_PC),
        .busA_ID(busA_ID),
        .busB_ID(busB_ID),
        .busB_EX(busB_EX),
        .PC_EX(EX_PC),
        .ALU_IN_A(ALU_IN_A),
        .ALU_IN_B(ALU_IN_B),
        .bgez_EX(bgez_EX),
        .bgtz_EX(bgtz_EX),
        .blez_EX(blez_EX),
        .bltz_EX(bltz_EX),
        .bne_EX(bne_EX),
        .beq_EX(beq_EX),
        .useshamt_EX(useshamt_EX),//是否移位
        .RegDst_EX(RegDst_EX),//I型
        .RegWr_EX(RegWr_EX),//寄存器写
        .byte_EX(byte_EX),//存储器是否读/写字节
        .MemWr_EX(MemWr_EX),//存储器是否写
        .MemRd_EX(MemRd_EX),//存储器是否读
        .link_EX(link_EX),//是否需链接
        .JumpReg_EX(JumpReg_EX),//是否寄存器跳转
        .ALUSrc_EX(ALUSrc_EX),
        .ALUctr_EX(ALUctr_EX),//alu控制
        .SigCtr_EX(SigCtr_EX),//读字节是否符号拓展
        .Branch_EX(Branch_EX),
        .rt_EX(rt_EX),
        .rd_EX(rd_EX),
        .rs_EX(rs_EX)
    );

    Ex ex_dut (
        .ALUctr(ALUctr_EX),     //ALU操作控制端
        .ALU_IN_A(ALU_IN_A),
        .ALU_IN_B(ALU_IN_B),
        .ALUsrcA(ALUsrcA),
        .ALUsrcB(ALUsrcB),
        .MemWrSrc(MemWrSrc),
        .Ex_OUT(REG_WRITE_MEM),
        .Mem_OUT(REG_WRITE_WB),
        .REG_READ_B(busB_EX),
        .bgez(bgez_EX),
        .bgtz(bgtz_EX),
        .blez(blez_EX),
        .bltz(bltz_EX),
        .beq(beq_EX),
        .bne(bne_EX),
        .Branch(Branch_EX),
        .Result(ALU_OUT_EX),   //运算结果
        .DATAMEM_WRITE(MEM_WRITE_EX),
        .carry(carry),           //进位
        .zero(zero),            //是否为零
        .negative(negative),        //是否为负数
        .overflow(overflow),         //是否溢出 
        .fail(fail)//
    );

    EXMEMReg EXMEMReg_dut (
        .clk(clk),
        .rst(rst),
        .bubble(fail),
        .PC_EX(EX_PC),
        .ALU_OUT_EX(ALU_OUT_EX),
        .ALU_OUT_MEM(ALU_OUT_MEM),
        .REG_WRITE(REG_WRITE_MEM),
        .RegWr_EX(RegWr_EX),
        .RegWr_MEM(RegWr_MEM),
        .MemRd_EX(MemRd_EX),
        .MemRd_MEM(MemRd_MEM),
        .MemWr_EX(MemWr_EX),
        .MemWr_MEM(MemWr_MEM),
        .MEM_WRITE_EX(MEM_WRITE_EX),
        .MEM_WRITE_MEM(MEM_WRITE_MEM),
        .rd_EX(rd_EX),
        .rt_EX(rt_EX),
        .link(link_EX),
        .RegDst(RegDst_EX),
        .REG_WRITE_ADDR(REG_WRITE_ADDR_MEM),
        .SigCtr_EX(SigCtr_EX),
        .SigCtr_MEM(SigCtr_MEM),
        .byte_EX(byte_EX),
        .byte_MEM(byte_MEM),
        .PC_MEM(MEM_PC)
    );

    Mem Mem_dut (
        .MemRd(MemRd_MEM),
        .MemWr(MemWr_MEM),
        .clk(clk),
        .byte(byte_MEM),
        .SigCtr(SigCtr_MEM),
        .ALU_OUT(ALU_OUT_MEM),
        .DATAMEM_WRITE(MEM_WRITE_MEM),
        .DATAMEM_READ(DATAMEM_READ_MEM),
        .MemWrSrc(MemWrSrc)
    );

    MEMWWBReg MEMWWBReg_dut (
        .clk(clk),
        .rst(rst),
        .ALU_OUT_MEM(ALU_OUT_MEM),
        .ALU_OUT_WB(ALU_OUT_WB),
        .DATAMEM_READ_MEM(DATAMEM_READ_MEM),
        .REG_WRITE_MEM(REG_WRITE_MEM),
        .REG_WRITE_WB(REG_WRITE_WB),
        .RegWr_MEM(RegWr_MEM),
        .RegWr_WB(RegWr_WB),
        .MemRd_MEM(MemRd_MEM),
        .REG_WRITE_ADDR_MEM(REG_WRITE_ADDR_MEM),
        .REG_WRITE_ADDR_WB(REG_WRITE_ADDR_WB)
    );

    Load_Use Load_Use_dut (
        .MemRd_EX(MemRd_EX),
        .rt_EX(rt_EX),
        .rs_ID(rs_ID),
        .rt_ID(rt_ID),
        .stall(stall)// 
    );

    ForWarding ForWarding_dut (
        .rs_EX(rs_EX),
        .rt_EX(rt_EX),
        .JumpReg(JumpReg_EX),
        .JumpRegSrc(JumpRegSrc),
        .REG_WRITE_ADDR_MEM(REG_WRITE_ADDR_MEM),
        .REG_WRITE_ADDR_WB(REG_WRITE_ADDR_WB),
        .ALUSrc_EX(ALUSrc_EX),
        .useshamt_EX(useshamt_EX),
        .RegWr_MEM(RegWr_MEM),
        .RegWr_WB(RegWr_WB),
        .ALUsrcA(ALUsrcA),
        .ALUsrcB(ALUsrcB),
        .MemWrSrc(MemWrSrc)//
    );

endmodule