module PC(
    input clk,                  //时钟
    input reset,                //是否重置地址。0-初始化PC，否则接受新地址
    input stall,               //阻塞信号
    input fail,
    input JumpReg,
    input [31:0] nextPC,        //新指令地址
    input [31:0] newPC,
    output reg [31:0] curPC      //当前指令的地址
);
    reg [1:0] cnt;
    reg Stall;

    initial begin
        curPC <= 32'h0000_3000;
        cnt <= 2'b00;
        Stall <= 1'b0;
    end

    always@(posedge clk or posedge reset) begin//取下一个地址或清零
        if (fail) begin
            curPC <= {newPC[31:2] + 1, 2'b00};
        end
        else begin
            if ((stall === 1'b1) & (Stall !== 1'b1)) begin
                Stall = 1'b1;
            end
            else if ((stall === 1'b1) & (Stall === 1'b1) | (stall !== 1'b1)) begin
                Stall = 1'b0;
            end
            if (JumpReg) begin
                cnt <= cnt + 1;
            end  
            if (reset) begin// reset == 0, PC = 0
                curPC <= 32'h0000_3000;
            end
            else if (stall !== 1 & ~JumpReg | (JumpReg & (cnt == 2'b10))) begin
                curPC <= nextPC;
            end

            if (cnt == 2'b10) begin
                cnt <= 2'b00;
            end
        end
    end

endmodule