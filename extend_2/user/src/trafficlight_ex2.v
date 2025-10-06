module trafficlight(
    input CLK,          // 时钟
    input RSTn,         // 复位
    input AS,           // 主道传感器
    input BS,           // 支道传感器
    output [2:0] state, // 状态
    output [6:0] led,   // LED输出
    output [5:0] A_time,// 主道时间
    output [5:0] B_time // 支道时间
);

parameter TIME_LED_Y = 6'd3;   // 黄灯时间
parameter TIME_LED_AG = 6'd27; // 主道直行绿灯时间
parameter TIME_LED_AL = 6'd12; // 主道左转绿灯时间
parameter TIME_LED_BG = 6'd17; // 支道直行绿灯时间
parameter TIME_LED_BL = 6'd7;  // 支道左转绿灯时间

wire T3, T12, T7, T27, T17;
wire C3, C12, C7, C27, C17;
wire [5:0] SD3, SD12, SD7, SD27, SD17;
wire LD3n, LD12n, LD7n, LD27n, LD17n;

// 控制模块
control UC (
    .CLK(CLK),
    .RSTn(RSTn),
    .AS(AS),
    .BS(BS),
    .T3(T3),
    .T12(T12),
    .T7(T7),
    .T27(T27),
    .T17(T17),
    .SD3(SD3),
    .SD12(SD12),
    .SD7(SD7),
    .SD27(SD27),
    .SD17(SD17),
    .C3(C3),
    .C12(C12),
    .C7(C7),
    .C27(C27),
    .C17(C17),
    .LD3n(LD3n),
    .LD12n(LD12n),
    .LD7n(LD7n),
    .LD27n(LD27n),
    .LD17n(LD17n),
    .state(state),
    .A_time(A_time),
    .B_time(B_time),
    .led(led)
);

count_sub UD3(
    .CLK(CLK),
    .LDn(LD3n),
    .E(C3),
    .PD(TIME_LED_Y - 1), // 预置值为时间-1
    .QT(SD3),
    .RCO(T3)
);

count_sub UD12(
    .CLK(CLK),
    .LDn(LD12n),
    .E(C12),
    .PD(TIME_LED_AL - 1), // 预置值为时间-1
    .QT(SD12),
    .RCO(T12)
);

count_sub UD7(
    .CLK(CLK),
    .LDn(LD7n),
    .E(C7),
    .PD(TIME_LED_BL - 1), // 预置值为时间-1
    .QT(SD7),
    .RCO(T7)
);

count_sub UD17(
    .CLK(CLK),
    .LDn(LD17n),
    .E(C17),
    .PD(TIME_LED_BG - 1), // 预置值为时间-1
    .QT(SD17),
    .RCO(T17)
);

count_sub UD27(
    .CLK(CLK),
    .LDn(LD27n),
    .E(C27),
    .PD(TIME_LED_AG - 1), // 预置值为时间-1
    .QT(SD27),
    .RCO(T27)
);

endmodule