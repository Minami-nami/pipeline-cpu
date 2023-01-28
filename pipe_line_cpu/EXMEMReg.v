module EXMEMReg (
    input clk,
    input rst,
    input bubble,
    input [31:0] PC_EX,
    input [31:0] ALU_OUT_EX,
    input [31:0] MEM_WRITE_EX,
    output reg [31:0] MEM_WRITE_MEM,
    output reg [31:0] REG_WRITE,
    output reg [31:0] PC_MEM,
    output reg [31:0] ALU_OUT_MEM,
    input RegWr_EX,
    output reg RegWr_MEM,
    input MemRd_EX,
    input link,
    input RegDst,
    output reg MemRd_MEM,
    input MemWr_EX,
    output reg MemWr_MEM,
    input [4:0] rd_EX,
    input [4:0] rt_EX,
    output reg [4:0] REG_WRITE_ADDR,
    input SigCtr_EX,
    output reg SigCtr_MEM,
    input byte_EX,
    output reg byte_MEM
);
    
     always @(posedge clk) begin
        if (bubble !== 1 & ~rst) begin
            PC_MEM <= PC_EX;
            RegWr_MEM <= RegWr_EX;
            MemRd_MEM <= MemRd_EX;
            MemWr_MEM <= MemWr_EX;
            ALU_OUT_MEM <= ALU_OUT_EX;
            SigCtr_MEM <= SigCtr_EX;
            byte_MEM <= byte_EX;
            REG_WRITE_ADDR <= (link == 1)? 5'b11111: ((RegDst == 1)? rd_EX: rt_EX);
            REG_WRITE <= (link == 1)? PC_EX + 4: ALU_OUT_EX;
            MEM_WRITE_MEM <= MEM_WRITE_EX;
        end
        else if (bubble === 1) begin
            PC_MEM <= 0;
            RegWr_MEM <= 0;
            MemRd_MEM <= 0;
            REG_WRITE_ADDR <= 0;
            REG_WRITE <= 0;
            ALU_OUT_MEM <= 0;
            MemWr_MEM <= 0;
            SigCtr_MEM <= 0;
            byte_MEM <= 0;
            MEM_WRITE_MEM <= 0;
        end
    end

endmodule