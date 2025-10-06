module clock_1HZ(
input wire CLK,
input wire CLRn,
output reg clk_1HZ
    );
reg [27:0]cnt;
always @(posedge CLK or negedge CLRn) begin
    if(!CLRn) cnt <= 28'd0;
    else if(cnt != 28'd24999999)
        cnt <= cnt + 1'b1;
    else
        cnt <= 28'd0;
    end
always @ (posedge CLK or negedge CLRn) begin
    if(!CLRn) clk_1HZ <= 0;
    else if(cnt == 28'd0)
        clk_1HZ <= ~clk_1HZ;
    end
endmodule
