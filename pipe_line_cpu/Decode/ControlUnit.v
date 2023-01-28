module ControlUnit (
    input [31:0] ins,
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
    output Extop,//符号拓展
    output link,//是否需链接
    output JumpReg,//是否寄存器跳转
    output ALUSrc,
    output [4:0] ALUctr,//alu控制
    output SigCtr,//读字节是否符号拓展
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] rd,
    output [4:0] shamt,
    output [15:0] immediate
);

    wire j, jr, jal, jalr, lb, lbu, sb, sw, lw, R, J;
    wire add, addiu, addi, addu, subu, sub, And, andi, Or, ori, Xori, Xor, Nor, slt, slti, sltiu, sltu, sll, sllv, srl, srlv, sra, srav, lui;
    assign useshamt = (~|ins[31:21]) & (~|ins[5:2]) & ~(~ins[1] & ins[0]);
    assign R = ~|ins[31:26];
    assign J = (~|ins[31:28]) & ins[27];
    assign RegDst = R | J;
    
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
    assign lb = ins[31] & (~|ins[30:26]);
    assign lbu = ins[31] & (~|ins[30:29]) & ins[28] & (~|ins[27:26]);
    assign sb = ins[31] & ~ins[30] & ins[29] & (~|ins[28:26]);
    assign sw = ins[31] & ~ins[30] & ins[29] & ~ins[28] & (&ins[27:26]);
    assign lw = ins[31] & (~|ins[30:28]) & (&ins[27:26]);
    assign add = (~|ins[31:26]) & (~|ins[10:6]) & ins[5] & (~|ins[4:0]);
    assign addiu = (~|ins[31:30]) & ins[29] & (~|ins[28:27]) & ins[26];
    assign addi = (~|ins[31:30]) & ins[29] & (~|ins[28:26]);    
    assign addu = (~|ins[31:26]) & (~|ins[10:6]) & ins[5] & (~|ins[4:1]) & ins[0];
    assign subu = (~|ins[31:26]) & (~|ins[10:6]) & ins[5] & (~|ins[4:2]) & (&ins[1:0]);
    assign sub = (~|ins[31:26]) & (~|ins[10:6]) & ins[5] & (~|ins[4:2]) & ins[1] & ~ins[0];
    assign And = (~|ins[31:26]) & (~|ins[10:6]) & ins[5] & (~|ins[4:3]) & ins[2] & (~|ins[1:0]);
    assign andi = (~|ins[31:30]) & (&ins[29:28]) & (~|ins[27:26]);
    assign Or = (~|ins[31:26]) & (~|ins[10:6]) & ins[5] & (~|ins[4:3]) & ins[2] & ~ins[1] & ins[0];
    assign ori = (~|ins[31:30]) & (&ins[29:28]) & ~ins[27] & ins[26];
    assign Xori = (~|ins[31:30]) & (&ins[29:27]) & ~ins[26];
    assign Xor = (~|ins[31:26]) & (~|ins[10:6]) & ins[5] & (~|ins[4:3]) & (&ins[2:1]) & ~ins[0];
    assign Nor = (~|ins[31:26]) & (~|ins[10:6]) & ins[5] & (~|ins[4:3]) & (&ins[2:0]);
    assign slt = (~|ins[31:26]) & (~|ins[10:6]) & ins[5] & ~ins[4] & ins[3] & ~ins[2] & ins[1] & ~ins[0];
    assign slti = (~|ins[31:30]) & ins[29] & ~ins[28] & ins[27] & ~ins[26];
    assign sltiu = (~|ins[31:30]) & ins[29] & ~ins[28] & (&ins[27:26]);
    assign sltu = (~|ins[31:26]) & (~|ins[10:6]) & ins[5] & ~ins[4] & ins[3] & ~ins[2] & (&ins[1:0]);
    assign sll = (~|ins[31:21]) & (~|ins[5:0]);
    assign sllv = (~|ins[31:26]) & (~|ins[10:6]) & (~|ins[5:3]) & ins[2] & (~|ins[1:0]);
    assign srl = (~|ins[31:21]) & (~|ins[5:2]) & ins[1] & ~ins[0];
    assign srlv = (~|ins[31:26]) & (~|ins[10:6]) & (~|ins[5:3]) & (&ins[2:1]) & ~ins[0];
    assign sra = (~|ins[31:21]) & (~|ins[5:2]) & (&ins[1:0]);
    assign srav = (~|ins[31:26]) & (~|ins[10:6]) & (~|ins[5:3]) & (&ins[2:0]);
    assign lui = (~|ins[31:30]) & (&ins[29:26]) & (~|ins[25:21]);

    assign ALUSrc = ~(R | J) & ~beq & ~bne;

    assign ALUctr[0] = subu | sub | beq | bne | Or | ori | Nor | sltu | sltiu | srl | srlv | bgtz | bgez | bltz | blez;

    assign ALUctr[1] = add | addi | lw | sw | lb | lbu | sb | sub | beq | bne | Xor | Xori | Nor | sll | sllv | srl | srlv | lui | bgtz | bgez | bltz | blez;

    assign ALUctr[2] = And | andi | Or | ori | Xor | Xori | Nor | sra | srav | lui | bgtz | bgez | bltz | blez;

    assign ALUctr[3] = slt | slti | sltu | sltiu | sll | sllv | srl | srlv | sra | srav | lui | bgtz | bgez | bltz | blez;

    assign ALUctr[4] = 0;

    assign Jump = j;

    assign link = jal | jalr;

    assign Branch = bne | beq | bgez | bgtz | blez | bltz;

    assign byte = lb | lbu | sb;

    assign RegWr = ~(beq | bne | sw | j | jr | bgez | bgtz | blez | bltz | sb);

    assign MemWr = sb | sw;

    assign MemRd = lw | lb | lbu;

    assign Extop = ~(ori | Xori | andi);

    assign JumpReg = jr | jalr;

    assign SigCtr = lb;

    assign rs = ins[25:21];
    assign rt = ins[20:16];
    assign rd = ins[15:11];
    assign shamt = ins[10:6];
    assign immediate = ins[15:0];

endmodule