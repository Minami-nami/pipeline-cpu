module Load_Use (
    input MemRd_EX,
    input [4:0] rt_EX,
    input [4:0] rs_ID,
    input [4:0] rt_ID,
    output stall// 
);

    assign stall = MemRd_EX & ((rt_EX == rs_ID) | (rt_EX == rt_ID));

endmodule