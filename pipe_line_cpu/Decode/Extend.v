module Extend # (
    parameter in_size = 16 
) (
    input ExtOp,
    input [in_size - 1:0] imm_in,
    output reg [31:0] imm_32
);

    always @(ExtOp or imm_in) begin
        if (ExtOp) imm_32 = $signed(imm_in);
        else imm_32 = imm_in;
    end

endmodule