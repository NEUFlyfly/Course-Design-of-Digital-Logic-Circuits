module control(
input wire CLK,
input wire RSTn,
input wire AS,//北方向为1
input wire BS,
input wire T3,//定时器完成
input wire T27,
input wire [5:0]SD3,//定时器数值
input wire [5:0]SD27,
output wire C3,//计数器使能信号
output wire C27,
output wire LD3n,//加载数据使能信号
output wire LD27n,
output wire [1:0]state,//状态
output wire [5:0]A_time,//A方向数值
output wire [5:0]B_time,//B方向数值
output wire [5:0]led//输出灯
);
parameter Y_time = 6'd3;//黄灯时间
parameter [1:0]S0=2'b00,S1=2'b01,S2=2'b10,S3=2'b11;

// LED位定义
parameter RED_A = 5, YELLOW_A = 4, GREEN_A = 3;
parameter RED_B = 2, YELLOW_B = 1, GREEN_B = 0;

reg [1:0]cur_state,next_state;
reg [5:0]control_led,control_A_time,control_B_time;
reg control_C3,control_C27;
reg control_LD3n,control_LD27n;
wire AK,BK;
assign AK = BS & (T27 | ~AS);
assign BK = ~BS | AS & T27;
assign state = cur_state;
assign led = control_led;
assign A_time = control_A_time;
assign B_time = control_B_time;
assign C3 = control_C3;
assign C27 = control_C27;
assign LD3n = control_LD3n;
assign LD27n = control_LD27n;

// S0: A 方向绿灯，B 方向红灯。
// S1: A 方向黄灯，B 方向红灯。
// S2: A 方向红灯，B 方向绿灯。
// S3: A 方向红灯，B 方向黄灯。
always @(*) begin
    case(cur_state)
    S0:if(AK) next_state = S1;
        else next_state = S0;
    S1:if(T3) next_state = S2;
        else next_state = S1;
    S2:if(BK) next_state = S3;
        else next_state = S2;
    S3:if(T3) next_state = S0;
        else next_state = S3;
    default: next_state = S0;
    endcase
end

always @(posedge CLK or negedge RSTn) begin //状态寄存器
    if(!RSTn) cur_state <= S0;
    else cur_state <= next_state;
end

always @(*) begin
    if(!RSTn) begin
        control_led = (1 << GREEN_A) | (1 << RED_B); // A绿 B红
        control_LD27n = 1'b0;
        control_C27 = 1'b1;
        control_C3 = 1'b0;
        control_A_time = 6'd0;
        control_B_time = 6'd0;
    end
    else begin
    case(cur_state)
    S0:begin  // A绿 B红
        control_C27 = 1'b1; // 计数器控制，启动27秒计数器，关闭三秒计数器
        control_LD27n = 1'b1;
        control_C3 = 1'b0;
        control_LD3n = 1'b0;
        control_A_time = SD27;
        control_B_time = SD27 + Y_time;
        control_led = (1 << GREEN_A) | (1 << RED_B);
    end
    S1:begin  // A黄 B红
        control_C27 = 1'b0;
        control_LD27n = 1'b0;
        control_C3 = 1'b1;
        control_LD3n = 1'b1;
        control_A_time = SD3;
        control_B_time = SD3;
        control_led = (1 << YELLOW_A) | (1 << RED_B);
    end
    S2:begin  // A红 B绿
        control_C27 = 1'b1;
        control_LD27n = 1'b1;
        control_C3 = 1'b0;
        control_LD3n = 1'b0;
        control_A_time = SD27 + Y_time;
        control_B_time = SD27;
        control_led = (1 << RED_A) | (1 << GREEN_B);
    end
    S3:begin  // A红 B黄
        control_C27 = 1'b0;
        control_LD27n = 1'b0;
        control_C3 = 1'b1;
        control_LD3n = 1'b1;
        control_A_time = SD3;
        control_B_time = SD3;
        control_led = (1 << RED_A) | (1 << YELLOW_B);
    end
    default:begin
        control_C27 = 1'b0;
        control_LD27n = 1'b0;
        control_C3 = 1'b0;
        control_LD3n = 1'b0;
        control_A_time = 6'd0;
        control_B_time = 6'd0;
        control_led = (1 << GREEN_A) | (1 << RED_B);
    end
    endcase
end
end       
endmodule