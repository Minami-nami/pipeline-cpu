module Mem (
    input MemRd,
    input MemWr,
    input clk,
    input byte,
    input SigCtr,
    input [1:0] MemWrSrc,
    input [31:0] ALU_OUT,
    input [31:0] DATAMEM_WRITE,
    output [31:0] DATAMEM_READ
);
    

    dm_4k datamem (
        .mRD(MemRd),
        .mWR(MemWr),
        .clk(clk),
        .Byte(byte),
        .SigCtr(SigCtr),
        .DAddr(ALU_OUT[11:0]), //alu计算结果作为地址
        .DataIn(DATAMEM_WRITE),
        .DataOut(DATAMEM_READ)
    );

endmodule