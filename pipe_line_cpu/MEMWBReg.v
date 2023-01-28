module MEMWWBReg (
    input clk,
    input rst,
    input [31:0] DATAMEM_READ_MEM,
    input [31:0] REG_WRITE_MEM,
    output reg [31:0] REG_WRITE_WB,
    input RegWr_MEM,
    output reg RegWr_WB,
    input MemRd_MEM,
    input [4:0] REG_WRITE_ADDR_MEM,
    output reg [4:0] REG_WRITE_ADDR_WB,
    input [31:0] ALU_OUT_MEM,
    output reg [31:0] ALU_OUT_WB
);
    
    always @(posedge clk) begin
        if (~rst) begin
            RegWr_WB <= RegWr_MEM;
            REG_WRITE_ADDR_WB <= REG_WRITE_ADDR_MEM;
            REG_WRITE_WB <= MemRd_MEM? DATAMEM_READ_MEM: REG_WRITE_MEM;
            ALU_OUT_WB <= ALU_OUT_MEM;
        end
    end

endmodule