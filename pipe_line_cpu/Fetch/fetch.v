module fetch (
    input clk,
    input rst,
    input stall,
    input fail,
    input [1:0] JumpRegSrc,
    input [31:0] ID_OUT,
    input [31:0] MEM_OUT,
    input [31:0] EX_OUT,
    input [31:0] newPC,
    output [31:0] curPC,
    output [31:0] ins
);

    wire [31:0] nextPC, RegJump;
    wire [15:0] immediate;
    wire [25:0] addr;
    wire Branch, Jump, JumpReg;

    assign immediate = ins[15:0];
    assign addr = ins[25:0];

    assign j = (~|ins[31:28]) & ins[27] & ~ins[26];
    assign jr = (~|ins[31:26]) & (~|ins[20:4]) & ins[3] & (~|ins[2:0]);
    assign jal = (~|ins[31:28]) & (&ins[27:26]);
    assign jalr = (~|ins[31:26]) & (~|ins[20:16]) & (&ins[15:11]) & (~|ins[10:6]) & (~|ins[5:4]) & ins[3] & (~|ins[2:1]) & ins[0];
    assign bne = (~|ins[31:29]) & ins[28] & ~ins[27] & ins[26];
    assign beq = (~|ins[31:29]) & ins[28] & (~|ins[27:26]);
    assign bgez = ((~|ins[31:27]) & ins[26]) & ((~|ins[20:17]) & ins[16]);
    assign bgtz = ((~|ins[31:29]) & (&ins[28:26])) & (~|ins[20:16]);
    assign blez = ((~|ins[31:29]) & (&ins[28:27]) & ~ins[26]) & (~|ins[20:16]);
    assign bltz = ((~|ins[31:27]) & ins[26]) & (~|ins[20:16]);


    assign Branch = bne | beq | bgez | bgtz | blez | bltz;
    assign Jump = j | jal;
    assign JumpReg = jr | jalr;

    assign RegJump = ((JumpRegSrc === 2'b01)? EX_OUT: (JumpRegSrc === 2'b10)? MEM_OUT: ID_OUT);

    im_4k InsMem (
        .IAddr(curPC[11:2]),
        .IDataOut(ins)
    );

    NPC nextpc (
        .Branch(Branch),
        .Jump(Jump),
        .JumpReg(JumpReg),
        .reset(rst),
        .RegJump(RegJump),
        .immediate(immediate),
        .addr(addr),
        .nextPC(nextPC),
        .curPC(curPC)
    );

    PC pc (
        .clk(clk),
        .reset(rst),
        .nextPC(nextPC),
        .curPC(curPC),
        .stall(stall),
        .JumpReg(JumpReg),
        .fail(fail),
        .newPC(newPC)
    );
    
endmodule