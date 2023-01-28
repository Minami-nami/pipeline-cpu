module IFIDReg (
    input clk,
    input rst,
    input bubble,
    input stall,
    input [31:0] IR_IF,
    input [31:0] PC_IF,
    output reg [31:0] IR_ID,
    output reg [31:0] PC_ID,
    output reg [4:0] rs,
    output reg [4:0] rt,
    output reg [4:0] rd,
    output reg [4:0] shamt,
    output reg [15:0] immediate
);
    reg Stall;

    always @(posedge clk) begin
        if ((stall === 1'b1) & (Stall !== 1'b1)) begin
            Stall = 1'b1;
        end
        else if ((stall === 1'b1) & (Stall === 1'b1) | (stall !== 1'b1)) begin
            Stall = 1'b0;
        end
        if (bubble !== 1 & stall !== 1 & ~rst) begin
            IR_ID <= IR_IF;
            PC_ID <= PC_IF;
            rs = IR_IF[25:21];
            rt = IR_IF[20:16];
            rd = IR_IF[15:11];
            shamt = IR_IF[10:6];
            immediate = IR_IF[15:0];
        end
        else if (bubble === 1) begin
            IR_ID <= 0;
            PC_ID <= 0;
            rs = 0;
            rt = 0;
            rd = 0;
            shamt = 0;
            immediate = 0;
        end
    end

endmodule