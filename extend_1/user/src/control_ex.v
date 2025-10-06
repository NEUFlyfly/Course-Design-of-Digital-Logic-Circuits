module control_ex(
    input wire CLK,
    input wire RSTn,
    input wire AS,
    input wire BS,
    input wire T3,
    input wire T17,
    input wire T27,
    input wire [5:0] SD3,
    input wire [5:0] SD17,
    input wire [5:0] SD27,
    output wire C3,
    output wire C17,
    output wire C27,
    output wire LD3n,
    output wire LD17n,
    output wire LD27n,
    output wire [1:0] state,
    output wire [5:0] led
);
parameter Y_time = 6'd3;
parameter [1:0]S0=2'b00,S1=2'b01,S2=2'b10,S3=2'b11;
reg [1:0]cur_state,next_state;
reg [5:0]control_led,control_A_time,control_B_time;
reg control_C3,control_C17,control_C27;
reg control_LD3n,control_LD17n,control_LD27n;
wire AK,BK;
assign AK = BS & T27 | BS & ~AS;
assign BK = ~BS | AS & T17;
assign state = cur_state;
assign led = control_led;
assign A_time = control_A_time;
assign B_time = control_B_time;
assign C3 = control_C3;
assign C17 = control_C17;
assign C27 = control_C27;
assign LD3n = control_LD3n;
assign LD17n = control_LD17n;
assign LD27n = control_LD27n;

always @(*) begin
    case(cur_state)
    S0:if(AK) next_state <= S1;
        else next_state <=S0;
    S1:if(T3) next_state <=S2;
        else next_state <=S1;
    S2:if(BK) next_state <= S3;
        else next_state <= S2;
    S3:if(T3) next_state <=S0;
        else next_state <=S3;
    endcase
end

always @(posedge CLK or negedge RSTn) begin
    if(!RSTn) cur_state <= S0;
    else cur_state <= next_state;
end

always @(*) begin
    if(!RSTn) begin
        control_led <= 6'b100001;
        control_LD27n <= 1'b0;
        control_C27 <= 1'b1;
        control_C17 <= 1'b0;
        control_C3 <= 1'b0;
    end
    else begin
    case(cur_state)
    S0:begin
        control_C27 <= 1'b1;
        control_LD27n <= 1'b1;
        control_C17 <= 1'b0;
        control_C3 <= 1'b0;
        control_LD3n <= 1'b0;
        // 正常显示A绿灯时间
        control_A_time <= SD27;
        control_B_time <= SD27 + Y_time;
        control_led <= 6'b001100;
    end
    S1:begin
        control_C27 <= 1'b0;
        control_LD27n <= 1'b0;
        control_C17 <= 1'b0;
        control_LD17n <= 1'b0;
        control_C3 <= 1'b1;
        control_LD3n <= 1'b1;
        // 正常显示A黄灯时间
        control_A_time <= SD3;
        control_B_time <= SD3;
        control_led <= 6'b010100;
    end
    S2:begin
        control_C27 <= 1'b0;
        control_LD27n <= 1'b0;
        control_C17 <= 1'b1;
        control_LD17n <= 1'b1;
        control_C3 <= 1'b0;
        control_LD3n <= 1'b0;
        // 正常显示B绿灯时间
        control_A_time <= SD17 + Y_time;
        control_B_time <= SD17;
        control_led <= 6'b100001;
    end
    S3:begin
        control_C27 <= 1'b0;
        control_LD27n <= 1'b0;
        control_C17 <= 1'b0;
        control_C3 <= 1'b1;
        control_LD3n <= 1'b1;
        // 正常显示B黄灯时间
        control_A_time <= SD3;
        control_B_time <= SD3;
        control_led <= 6'b100010;
    end
    default:begin
        control_C27 <= 1'b0;
        control_LD27n <= 1'b0;
        control_C17 <= 1'b0;
        control_C3 <= 1'b0;
        control_led <= 6'b100001;
    end
    endcase
end
end       
endmodule