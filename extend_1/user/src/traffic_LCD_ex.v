module traffic_LCD_ex(
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
assign W2 = 1;
clock_1HZ u0(
.CLK(clk_50M),
.CLRn(W2),
.clk_1HZ(W1)
);
trafficlight_ex u1(
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
// 直接显示时间值，不进行+1操作
assign A_1 = A_time / 10;
assign A_0 = A_time % 10;
assign B_1 = B_time / 10;
assign B_0 = B_time % 10;
lcd_top u2(
    .clk_50M(clk_50M), 
    .reset_btn(reset_btn),
    .countA_shi(led[5]),
    .countA_ge(led[4]),
    .countB_shi(),
    .countB_ge(),
    .countC_shi(led[3]),
    .countC_ge(led[2]),
    .countD_shi(led[1]),
    .countD_ge(led[0]),
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