module ForWarding (
    input [4:0] rs_EX,
    input [4:0] rt_EX,
    input [4:0] REG_WRITE_ADDR_MEM,
    input [4:0] REG_WRITE_ADDR_WB,
    input JumpReg,
    input ALUSrc_EX,
    input useshamt_EX,
    input RegWr_MEM,
    input RegWr_WB,
    output [1:0] ALUsrcA,
    output [1:0] ALUsrcB,//
    output [1:0] JumpRegSrc,//
    output [1:0] MemWrSrc
);
    wire c1a, c1b, c2a, c2b;
    assign c1a = (REG_WRITE_ADDR_MEM === rs_EX) & RegWr_MEM;
    assign c1b = (REG_WRITE_ADDR_MEM === rt_EX) & RegWr_MEM;
    assign c2a = (REG_WRITE_ADDR_WB === rs_EX) & RegWr_WB;
    assign c2b = (REG_WRITE_ADDR_WB === rt_EX) & RegWr_WB;

    assign ALUsrcA = ((~c1a & ~c2a) | useshamt_EX)? 2'b00: (((~c1a)? 2'b10: 2'b01));
    assign ALUsrcB = ((~c1b & ~c2b) | ALUSrc_EX)? 2'b00: (((~c1b)? 2'b10: 2'b01));
    assign JumpRegSrc = (~c1a & ~c2a | (JumpReg === 0))? 2'b00: (((~c1a)? 2'b01: 2'b10));
    assign MemWrSrc = (~c1b & ~c2b)? 2'b00: (((~c1b)? 2'b10: 2'b01));

endmodule