module Ex (
    //input OVctr,            //是否需要溢出判断
    input [4:0] ALUctr,     //ALU操作控制端
    input [31:0] ALU_IN_A,
    input [31:0] ALU_IN_B,
    input [1:0] ALUsrcA,
    input [1:0] ALUsrcB,
    input [1:0] MemWrSrc,
    input [31:0] Ex_OUT,
    input [31:0] Mem_OUT,
    input [31:0] REG_READ_B,
    input bgez,
    input bgtz,
    input blez,
    input bltz,
    input beq,
    input bne,
    input Branch,
    output [31:0] Result,   //运算结果
    output [31:0] DATAMEM_WRITE,
    output carry,           //进位
    output zero,            //是否为零
    output negative,        //是否为负数
    output overflow,         //是否溢出 
    output fail//
);
    wire [31:0] lhs, rhs;
    assign lhs = (ALUsrcA === 2'b00)? ALU_IN_A: ((ALUsrcA === 2'b01)? Ex_OUT: ((ALUsrcA === 2'b10)? Mem_OUT: ALU_IN_A));
    assign rhs = (ALUsrcB === 2'b00)? ALU_IN_B: ((ALUsrcB === 2'b01)? Ex_OUT: ((ALUsrcB === 2'b10)? Mem_OUT: ALU_IN_B));
    assign DATAMEM_WRITE = (MemWrSrc === 2'b00)? REG_READ_B: ((MemWrSrc === 2'b10)? Mem_OUT: ((MemWrSrc === 2'b01)? Ex_OUT: REG_READ_B));

    ALU alu (
        .ALUctr(ALUctr),
        .lhs(lhs),
        .rhs(rhs),
        .Result(Result),
        .carry(carry),
        .zero(zero),
        .negative(negative),
        .overflow(overflow),
        .bne(bne),
        .beq(beq),
        .bltz(bltz),
        .blez(blez),
        .bgtz(bgtz),
        .bgez(bgez),
        .fail(fail),
        .Branch(Branch)
    );

endmodule