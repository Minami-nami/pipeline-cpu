module NPC(
    input reset,                //是否重置地址。0-初始化PC，否则接受新地址
    input Branch,
    input Jump,
    input JumpReg,
    input [31:0] RegJump,
    input [15:0] immediate,
    input [25:0] addr,
    input [31:0] curPC,      //当前指令的地址
    output reg [31:0] nextPC        //新指令地址
);

    initial begin
        nextPC <= 32'h0000_3000;
    end

    always@(*) begin//取下一个地址或清零
        if(reset) begin// reset == 0, PC = 0
            nextPC <= 32'h0000_3000;
        end
        else begin
            if (Branch) begin
                nextPC <= {$signed(curPC[31:2]) + $signed(immediate), 2'b00};
            end                              
            else if (Jump) begin
                nextPC <= {curPC[31:28], addr, 2'b00};
            end
            else if (~JumpReg) begin
                nextPC <= {curPC[31:2] + 1, 2'b00};
            end
            else if (JumpReg) begin
               nextPC <= RegJump; 
            end
        end
    end

endmodule