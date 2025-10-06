module count( // 异步复位，并行加载，定制进制减法计数
input wire CLK,
input wire RSTn, // 异步复位
input wire LDn,
input wire E,
input [5:0]PD,
output wire [5:0]QT,
output wire RCO
);
reg [5:0] SQ;
assign RCO = ~SQ[5] & ~SQ[4] & ~SQ[3] & ~SQ[2] & ~SQ[1] & ~SQ[0];
assign QT = SQ;
always @(posedge CLK or negedge RSTn) begin // 异步复位
    if(!RSTn) 
        SQ <= 0; // 复位时清零
    else if(!LDn) 
        SQ <= PD;
    else if(E) begin
        if(SQ == 0) 
            SQ <= PD;
        else 
            SQ <= SQ - 1;
    end
end
endmodule