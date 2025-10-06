module traffic_LCD(
input  wire clk_50M,
input wire reset_btn, 
input wire AS,
input wire BS,
output wire leds,
output wire [2:0] video_red,    
output wire [2:0] video_green,  
output wire [1:0] video_blue,   
output wire       video_hsync,  
output wire       video_vsync,  
output wire       video_clk,   
output wire       video_de,    
output wire [1:0] state,
output wire [5:0] led,
output wire [5:0] A_time,
output wire [5:0] B_time
);
wire W1,W2;
assign W2 = ~reset_btn; // 修改复位信号连接
clock_1HZ u0(
.CLK(clk_50M),
.CLRn(W2),
.clk_1HZ(W1)
);
trafficlight u1(
.CLK(W1),
.RSTn(W2),
.AS(AS),
.BS(BS),
.state(state),
.A_time(A_time),
.B_time(B_time),
.led(led)
);
wire [3:0]A_1;
wire [3:0]A_0;
wire [3:0]B_1;
wire [3:0]B_0;
assign A_1 = (A_time+1) / 10;
assign A_0 = (A_time+1) % 10;
assign B_1 = (B_time+1) / 10;
assign B_0 = (B_time+1) % 10;

// 添加LED解码逻辑
wire [3:0] ledA_shi, ledA_ge, ledB_shi, ledB_ge, ledC_shi, ledC_ge;
assign ledA_shi = led[5] ? 4'b0001 : 4'b0000;
assign ledA_ge = led[4] ? 4'b0001 : 4'b0000;
assign ledB_shi = led[3] ? 4'b0001 : 4'b0000;
assign ledB_ge = led[2] ? 4'b0001 : 4'b0000;
assign ledC_shi = led[1] ? 4'b0001 : 4'b0000;
assign ledC_ge = led[0] ? 4'b0001 : 4'b0000;

lcd_top u2(
    .clk_50M(clk_50M), 
    .reset_btn(reset_btn),
    .countA_shi(ledA_shi),
    .countA_ge(ledA_ge),
    .countB_shi(ledB_shi),
    .countB_ge(ledB_ge),
    .countC_shi(ledC_shi),
    .countC_ge(ledC_ge),
    .countE_shi(A_1),
    .countE_ge(A_0),
    .countF_shi(B_1),
    .countF_ge(B_0),
    .leds(leds),
    .video_red(video_red), 
    .video_green(video_green),
    .video_blue(video_blue),   
    .video_hsync(video_hsync),  
    .video_vsync(video_vsync), 
    .video_clk(video_clk),   
    .video_de(video_de)    
);
endmodule