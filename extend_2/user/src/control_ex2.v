module control(
    input wire CLK,          // 时钟信号
    input wire RSTn,         // 复位信号，低有效
    input wire AS,           // 主道传感器，有车为1
    input wire BS,           // 支道传感器，有车为1
    input wire T3,           // 3秒计时结束信号
    input wire T12,          // 12秒计时结束信号
    input wire T7,           // 7秒计时结束信号
    input wire T27,          // 27秒计时结束信号
    input wire T17,          // 17秒计时结束信号
    input wire [5:0] SD3,    // 3秒计时器当前值
    input wire [5:0] SD12,   // 12秒计时器当前值
    input wire [5:0] SD7,    // 7秒计时器当前值
    input wire [5:0] SD27,   // 27秒计时器当前值
    input wire [5:0] SD17,   // 17秒计时器当前值
    output wire C3,          // 3秒计数器使能
    output wire C12,         // 12秒计数器使能
    output wire C7,          // 7秒计数器使能
    output wire C27,         // 27计数器使能
    output wire C17,         // 17秒计数器使能
    output wire LD3n,        // 3秒计数器加载信号，低有效
    output wire LD12n,       // 12秒计数器加载信号，低有效
    output wire LD7n,        // 7秒计数器加载信号，低有效
    output wire LD27n,       // 27秒计数器加载信号，低有效
    output wire LD17n,       // 17秒计数器加载信号，低有效
    output wire [2:0] state, // 当前状态
    output wire [5:0] A_time,// 主道剩余时间
    output wire [5:0] B_time,// 支道剩余时间
    output wire [6:0] led    // LED输出信号
);

parameter Y_time = 6'd3;
parameter G_time7 = 6'd7;
parameter G_time12 = 6'd12;
parameter G_time17 = 6'd17;
parameter G_time27 = 6'd27;

// 状态定义
parameter [2:0] 
    S0 = 3'b000, // 主道直行绿灯(27秒)，支道红灯
    S1 = 3'b001, // 主道直行黄灯(3秒)，支道红灯
    S2 = 3'b010, // 主道左转绿灯(12秒)，支道红灯
    S3 = 3'b011, // 主道左转黄灯(3秒)，支道红灯
    S4 = 3'b100, // 支道直行绿灯(17秒)，主道红灯
    S5 = 3'b101, // 支道直行黄灯(3秒)，主道红灯
    S6 = 3'b110, // 支道左转绿灯(7秒)，主道红灯
    S7 = 3'b111; // 支道左转黄灯(3秒)，主道红灯

reg [2:0] cur_state, next_state;
reg [6:0] control_led;
reg [5:0] control_A_time, control_B_time;
reg control_C3, control_C12, control_C7, control_C27, control_C17;
reg control_LD3n, control_LD12n, control_LD7n, control_LD27n, control_LD17n;

wire AK, BK;

// 根据PPT要求修改AK和BK的条件
assign AK = (cur_state == S0) && BS && T27; // 主道直行绿灯期间，支道有车且27秒时间到
assign BK = (cur_state == S4) && AS && T17; // 支道直行绿灯期间，主道有车且17秒时间到

assign state = cur_state;
assign led = control_led;
assign A_time = control_A_time;
assign B_time = control_B_time;
assign C3 = control_C3;
assign C12 = control_C12;
assign C7 = control_C7;
assign C27 = control_C27;
assign C17 = control_C17;
assign LD3n = control_LD3n;
assign LD12n = control_LD12n;
assign LD7n = control_LD7n;
assign LD27n = control_LD27n;
assign LD17n = control_LD17n;

// 状态转换逻辑 - 根据PPT要求修改
always @(*) begin
    case (cur_state)
        S0: if (AK) next_state <= S1;    // 主道直行绿灯结束，切换到黄灯
            else if (T27) next_state <= S1; // 时间到，切换到黄灯
            else next_state <= S0;
        S1: if (T3) next_state <= S2;     // 主道直行黄灯结束
            else next_state <= S1;
        S2: if (T12) next_state <= S3;    // 主道左转绿灯结束
            else next_state <= S2;
        S3: if (T3) next_state <= S4;     // 主道左转黄灯结束，切换到支道
            else next_state <= S3;
        S4: if (BK) next_state <= S5;     // 支道直行绿灯结束，切换到黄灯
            else if (T17) next_state <= S5; // 时间到，切换到黄灯
            else next_state <= S4;
        S5: if (T3) next_state <= S6;     // 支道直行黄灯结束
            else next_state <= S5;
        S6: if (T7) next_state <= S7;     // 支道左转绿灯结束
            else next_state <= S6;
        S7: if (T3) next_state <= S0;     // 支道左转黄灯结束，切换回主道
            else next_state <= S7;
        default: next_state <= S0;
    endcase
end

// 状态寄存器
always @(posedge CLK or negedge RSTn) begin
    if (!RSTn) cur_state <= S0;
    else cur_state <= next_state;
end

// 输出逻辑 - 根据PPT要求修改LED输出
always @(*) begin
    if (!RSTn) begin
        control_led <= 7'b0011000; // 复位状态：主道绿灯，支道红灯
        control_LD27n <= 1'b0;
        control_C27 <= 1'b1;
        control_C17 <= 1'b0;
        control_LD17n <= 1'b0;
        control_C7 <= 1'b0;
        control_C12 <= 1'b0;
        control_C3 <= 1'b0;
        control_LD3n <= 1'b0;
        control_LD7n <= 1'b0;
        control_LD12n <= 1'b0;
    end else begin
        case (cur_state)
            S0: begin // 主道直行绿灯，支道红灯
                control_C27 <= 1'b1;
                control_LD27n <= 1'b1;
                control_C17 <= 1'b0;
                control_LD17n <= 1'b0;
                control_C7 <= 1'b0;
                control_C12 <= 1'b0;
                control_C3 <= 1'b0;
                control_LD3n <= 1'b0;
                control_LD12n <= 1'b0;
                control_LD7n <= 1'b0;
                control_A_time <= SD27 + 1; // 修改：加1
                control_B_time <= (SD27 + 1) + 2 * Y_time + G_time12; // 修改：加1
                control_led <= 7'b0011000; // 主道绿灯，支道红灯
            end
            S1: begin // 主道直行黄灯，支道红灯
                control_C27 <= 1'b0;
                control_C7 <= 1'b0;
                control_C12 <= 1'b0;
                control_C3 <= 1'b1;
                control_C17 <= 1'b0;
                control_LD17n <= 1'b0;
                control_LD3n <= 1'b1;
                control_LD12n <= 1'b0;
                control_LD7n <= 1'b0;
                control_LD27n <= 1'b0;
                control_A_time <= SD3 + 1; // 修改：加1
                control_B_time <= (SD3 + 1) + Y_time + G_time12; // 修改：加1
                control_led <= 7'b0101000; // 主道黄灯，支道红灯
            end
            S2: begin // 主道左转绿灯，支道红灯
                control_C27 <= 1'b0;
                control_C7 <= 1'b0;
                control_C12 <= 1'b1;
                control_C3 <= 1'b0;
                control_C17 <= 1'b0;
                control_LD17n <= 1'b0;
                control_LD3n <= 1'b0;
                control_LD12n <= 1'b1;
                control_LD7n <= 1'b0;
                control_LD27n <= 1'b0;
                control_A_time <= SD12 + 1; // 修改：加1
                control_B_time <= (SD12 + 1) + Y_time; // 修改：加1
                control_led <= 7'b0001001; // 主道左转绿灯，支道红灯
            end
            S3: begin // 主道左转黄灯，支道红灯
                control_C27 <= 1'b0;
                control_C7 <= 1'b0;
                control_C12 <= 1'b0;
                control_C3 <= 1'b1;
                control_C17 <= 1'b0;
                control_LD17n <= 1'b0;
                control_LD3n <= 1'b1;
                control_LD12n <= 1'b0;
                control_LD7n <= 1'b0;
                control_LD27n <= 1'b0;
                control_A_time <= SD3 + 1; // 修改：加1
                control_B_time <= SD3 + 1; // 修改：加1
                control_led <= 7'b0100010; // 主道左转黄灯，支道红灯
            end
            S4: begin // 支道直行绿灯，主道红灯
                control_C27 <= 1'b0;
                control_C7 <= 1'b0;
                control_C12 <= 1'b0;
                control_C3 <= 1'b0;
                control_C17 <= 1'b1;
                control_LD17n <= 1'b1;
                control_LD3n <= 1'b0;
                control_LD12n <= 1'b0;
                control_LD7n <= 1'b0;
                control_LD27n <= 1'b0;
                control_A_time <= (SD17 + 1) + 2 * Y_time + G_time7; // 修改：加1
                control_B_time <= SD17 + 1; // 修改：加1
                control_led <= 7'b1000010; // 主道红灯，支道绿灯
            end
            S5: begin // 支道直行黄灯，主道红灯
                control_C27 <= 1'b0;
                control_C7 <= 1'b0;
                control_C12 <= 1'b0;
                control_C3 <= 1'b1;
                control_C17 <= 1'b0;
                control_LD17n <= 1'b0;
                control_LD3n <= 1'b1;
                control_LD12n <= 1'b0;
                control_LD7n <= 1'b0;
                control_LD27n <= 1'b0;
                control_A_time <= (SD3 + 1) + Y_time + G_time7; // 修改：加1
                control_B_time <= SD3 + 1; // 修改：加1
                control_led <= 7'b1000100; // 主道红灯，支道黄灯
            end
            S6: begin // 支道左转绿灯，主道红灯
                control_C27 <= 1'b0;
                control_C7 <= 1'b1;
                control_C12 <= 1'b0;
                control_C3 <= 1'b0;
                control_C17 <= 1'b0;
                control_LD17n <= 1'b0;
                control_LD3n <= 1'b0;
                control_LD12n <= 1'b0;
                control_LD7n <= 1'b1;
                control_LD27n <= 1'b0;
                control_A_time <= (SD7 + 1) + Y_time; // 修改：加1并加上黄灯时间
                control_B_time <= SD7 + 1; // 修改：加1
                control_led <= 7'b1000001; // 主道红灯，支道左转绿灯
            end
            S7: begin // 支道左转黄灯，主道红灯
                control_C27 <= 1'b0;
                control_C7 <= 1'b0;
                control_C12 <= 1'b0;
                control_C3 <= 1'b1;
                control_C17 <= 1'b0;
                control_LD17n <= 1'b0;
                control_LD3n <= 1'b1;
                control_LD12n <= 1'b0;
                control_LD7n <= 1'b0;
                control_LD27n <= 1'b0;
                control_A_time <= SD3 + 1; // 修改：加1
                control_B_time <= SD3 + 1; // 修改：加1
                control_led <= 7'b1000100; // 主道红灯，支道左转黄灯
            end
            default: begin
                control_LD27n <= 1'b0;
                control_C17 <= 1'b0;
                control_C27 <= 1'b0;
                control_C7 <= 1'b0;
                control_C12 <= 1'b0;
                control_C3 <= 1'b0;
                control_led <= 7'b0100001; // 默认状态：主道绿灯，支道红灯
            end
        endcase
    end
end

endmodule