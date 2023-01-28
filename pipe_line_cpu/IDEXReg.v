module IDEXReg (
    input clk,
    input rst,
    input bubble,
    input stall,
    input bgez_ID,
    input bgtz_ID,
    input blez_ID,
    input bltz_ID,
    input bne_ID,
    input beq_ID,
    input useshamt_ID,//是否移位
    input RegDst_ID,//I型
    input RegWr_ID,//寄存器写
    input byte_ID,//存储器是否读/写字节
    input MemWr_ID,//存储器是否写
    input MemRd_ID,//存储器是否读
    input link_ID,//是否需链接
    input JumpReg_ID,//是否寄存器跳转
    input ALUSrc_ID,
    input Branch_ID,
    input [4:0] ALUctr_ID,//alu控制
    input SigCtr_ID,//读字节是否符号拓展
    input [4:0] rs_ID,
    input [4:0] rt_ID,
    input [4:0] rd_ID,
    input [31:0] extended_shamt,
    input [31:0] immediate,
    input [31:0] PC_ID,
    input [31:0] busA_ID,
    input [31:0] busB_ID,
    output reg [31:0] PC_EX,
    output reg [31:0] ALU_IN_A,
    output reg [31:0] ALU_IN_B,
    output reg [31:0] busB_EX,
    output reg bgez_EX,
    output reg bgtz_EX,
    output reg blez_EX,
    output reg bltz_EX,
    output reg bne_EX,
    output reg beq_EX,
    output reg useshamt_EX,//是否移位
    output reg RegDst_EX,//I型
    output reg RegWr_EX,//寄存器写
    output reg byte_EX,//存储器是否读/写字节
    output reg MemWr_EX,//存储器是否写
    output reg MemRd_EX,//存储器是否读
    output reg link_EX,//是否需链接
    output reg JumpReg_EX,//是否寄存器跳转
    output reg ALUSrc_EX,
    output reg [4:0] ALUctr_EX,//alu控制
    output reg SigCtr_EX,//读字节是否符号拓展
    output reg Branch_EX,
    output reg [4:0] rt_EX,
    output reg [4:0] rd_EX,
    output reg [4:0] rs_EX
);

    reg Stall;

    always @(posedge clk) begin
        if ((stall === 1'b1) & (Stall !== 1'b1)) begin
            Stall = 1'b1;
        end
        else if ((stall === 1'b1) & (Stall === 1'b1) | (stall !== 1'b1)) begin
            Stall = 1'b0;
        end
        if (bubble !== 1 & Stall !== 1 & ~rst) begin
            PC_EX <= PC_ID;
            bgez_EX <= bgez_ID;
            bgtz_EX <= bgtz_ID;
            blez_EX <= blez_ID;
            bltz_EX <= bltz_ID;
            bne_EX <= bne_ID;
            beq_EX <= beq_ID;
            useshamt_EX <= useshamt_ID;
            RegDst_EX <= RegDst_ID;
            RegWr_EX <= RegWr_ID;
            byte_EX <= byte_ID;
            MemWr_EX <= MemWr_ID;
            MemRd_EX <= MemRd_ID;
            link_EX <= link_ID;
            JumpReg_EX <= JumpReg_ID;
            ALUSrc_EX <= ALUSrc_ID;
            ALUctr_EX <= ALUctr_ID;
            SigCtr_EX <= SigCtr_ID;
            rt_EX <= rt_ID;
            rd_EX <= rd_ID;
            rs_EX <= rs_ID;
            busB_EX <= busB_ID;
            ALU_IN_A <= (useshamt_ID == 0)? busA_ID: extended_shamt;
            ALU_IN_B <= (ALUSrc_ID == 0)? busB_ID: immediate;
            Branch_EX <= Branch_ID;
        end
        else if (bubble === 1) begin
            PC_EX <= 0;
            bgez_EX <= 0;
            bgtz_EX <= 0;
            blez_EX <= 0;
            bltz_EX <= 0;
            bne_EX <= 0;
            beq_EX <= 0;
            useshamt_EX <= 0;
            RegDst_EX <= 0;
            RegWr_EX <= 0;
            byte_EX <= 0;
            MemWr_EX <= 0;
            MemRd_EX <= 0;
            link_EX <= 0;
            JumpReg_EX <= 0;
            ALUSrc_EX <= 0;
            ALUctr_EX <= 0;
            SigCtr_EX <= 0;
            rt_EX <= 0;
            rd_EX <= 0;
            rs_EX <= 0;
            busB_EX <= 0;
            ALU_IN_A <= 0;
            ALU_IN_B <= 0;
            Branch_EX <= 0;
        end
    end



endmodule