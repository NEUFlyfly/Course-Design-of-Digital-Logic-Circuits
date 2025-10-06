module count(
    input wire CLK,
    input wire LDn,
    input wire E,
    input wire [5:0] PD,
    output reg [5:0] QT,
    output reg RCO
);

always @(posedge CLK or negedge LDn) begin
    if (!LDn) begin
        QT <= PD;
    end else if (E) begin
        if (QT != 6'd0)
            QT <= QT - 1'b1;
        else
            QT <= 6'd0;
    end
end

always @(*) begin
    if (QT == 6'd1) begin  // 当计数器为1时产生RCO信号
        RCO = 1'b1;
    end else begin
        RCO = 1'b0;
    end
end

endmodule