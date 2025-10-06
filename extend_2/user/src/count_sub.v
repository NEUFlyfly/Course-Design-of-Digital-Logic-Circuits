module count_sub(
    input CLK,       // 时钟信号
    input LDn,       // 加载信号，低有效
    input E,         // 计数器使能
    input [5:0] PD,  // 预置数
    output [5:0] QT, // 当前计数值
    output RCO       // 进位输出信号
);
reg [5:0] SQ;
assign RCO = (SQ == 0); // 修改：当计数器为0时产生进位信号
assign QT = SQ;
always @(posedge CLK) begin
    if(!LDn) SQ <= PD;
    else begin
        if(E) begin
            if(SQ == 0) SQ <= PD;
            else SQ <= SQ - 1;
        end
    end
end

endmodule