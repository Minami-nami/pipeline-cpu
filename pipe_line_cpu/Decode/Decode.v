module Decode (
    input clk,              //激励信号
    input reset,
    input [31:0] IR_IN,
    input wEn,              //使能-是否写入
    input [4:0] REG_WRITE_ADDR,         //写入寄存器位置
    input [31:0] REG_WRITE,      //输入
    output bgez,
    output bgtz,
    output blez,
    output bltz,
    output bne,
    output beq,
    output useshamt,//是否移位
    output RegDst,//I型
    output Branch,//分支语句
    output Jump,//无条件跳转语句
    output RegWr,//寄存器写
    output byte,//存储器是否读/写字节
    output MemWr,//存储器是否写
    output MemRd,//存储器是否读
    output link,//是否需链接
    output JumpReg,//是否寄存器跳转
    output ALUSrc,
    output [4:0] ALUctr,//alu控制
    output SigCtr,//读字节是否符号拓展
    output [31:0] busA,     //输出A
    output [31:0] busB,      //输出B
    output [31:0] immediate,
    output [31:0] extended_shamt,
    output [4:0] rd,
    output [4:0] rt,//
    output [4:0] rs
);
    
    wire Extop;
    wire [5:0] func, op;
    wire [4:0] shamt;
    wire [15:0] imm16;
    wire [25:0] addr;

    Extend # (.in_size(5)) shamt_ext (
        .ExtOp(1'b1),
        .imm_in(shamt),
        .imm_32(extended_shamt)
    );

    Extend imm16_ext (
        .ExtOp(Extop),
        .imm_in(imm16),
        .imm_32(immediate)
    );

    ControlUnit ctrl (
        .ins(IR_IN),
        .bgez(bgez),
        .bgtz(bgtz),
        .blez(blez),
        .bltz(bltz),
        .bne(bne),
        .beq(beq),
        .useshamt(useshamt),//是否移位
        .RegDst(RegDst),//I型
        .Branch(Branch),//分支语句
        .Jump(Jump),//无条件跳转语句
        .RegWr(RegWr),//寄存器写
        .byte(byte),//存储器是否读/写字节
        .MemWr(MemWr),//存储器是否写
        .MemRd(MemRd),//存储器是否读
        .Extop(Extop),//符号拓展
        .link(link),//是否需链接
        .JumpReg(JumpReg),//是否寄存器跳转
        .ALUSrc(ALUSrc),
        .ALUctr(ALUctr),//alu控制
        .SigCtr(SigCtr),//读字节是否符号拓展
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .shamt(shamt),
        .immediate(imm16)
    );

    RegFile regfile (
        .clk(clk),              //激励信号
        .reset(reset),
        .RA(rs),         //读取寄存器位置1
        .RB(rt),         //读取寄存器位置2
        .RW(REG_WRITE_ADDR),         //写入寄存器位置
        .wEn(wEn),              //使能-是否写入
        .busW(REG_WRITE),      //输入
        .busA(busA),     //输出A
        .busB(busB)      //输出B
    );

endmodule