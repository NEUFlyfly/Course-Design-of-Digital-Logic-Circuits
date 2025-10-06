module traffic_LCD_ex2(
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
output wire [2:0] state,
output wire [6:0] led,
output wire [5:0] A_time,
output wire [5:0] B_time
);
wire W1,W2;
assign W2 = 1;
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
assign A_1 = A_time / 10;  // 直接使用A_time，因为已经在control模块中加1了
assign A_0 = A_time % 10;
assign B_1 = B_time / 10;
assign B_0 = B_time % 10;
lcd_top u2(
    .clk_50M(clk_50M), 
    .reset_btn(reset_btn),
    .countA_shi(led[6]),
    .countA_ge(led[5]),
    .countB_shi(led[4]),
    .countB_ge(led[3]),
    .countC_shi(led[2]),
    .countC_ge(led[1]),
    .countD_shi(led[0]),
    .countD_ge(),
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