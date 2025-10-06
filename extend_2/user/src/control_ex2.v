module control(
    input wire CLK,          // ʱ���ź�
    input wire RSTn,         // ��λ�źţ�����Ч
    input wire AS,           // �������������г�Ϊ1
    input wire BS,           // ֧�����������г�Ϊ1
    input wire T3,           // 3���ʱ�����ź�
    input wire T12,          // 12���ʱ�����ź�
    input wire T7,           // 7���ʱ�����ź�
    input wire T27,          // 27���ʱ�����ź�
    input wire T17,          // 17���ʱ�����ź�
    input wire [5:0] SD3,    // 3���ʱ����ǰֵ
    input wire [5:0] SD12,   // 12���ʱ����ǰֵ
    input wire [5:0] SD7,    // 7���ʱ����ǰֵ
    input wire [5:0] SD27,   // 27���ʱ����ǰֵ
    input wire [5:0] SD17,   // 17���ʱ����ǰֵ
    output wire C3,          // 3�������ʹ��
    output wire C12,         // 12�������ʹ��
    output wire C7,          // 7�������ʹ��
    output wire C27,         // 27������ʹ��
    output wire C17,         // 17�������ʹ��
    output wire LD3n,        // 3������������źţ�����Ч
    output wire LD12n,       // 12������������źţ�����Ч
    output wire LD7n,        // 7������������źţ�����Ч
    output wire LD27n,       // 27������������źţ�����Ч
    output wire LD17n,       // 17������������źţ�����Ч
    output wire [2:0] state, // ��ǰ״̬
    output wire [5:0] A_time,// ����ʣ��ʱ��
    output wire [5:0] B_time,// ֧��ʣ��ʱ��
    output wire [6:0] led    // LED����ź�
);

parameter Y_time = 6'd3;
parameter G_time7 = 6'd7;
parameter G_time12 = 6'd12;
parameter G_time17 = 6'd17;
parameter G_time27 = 6'd27;

// ״̬����
parameter [2:0] 
    S0 = 3'b000, // ����ֱ���̵�(27��)��֧�����
    S1 = 3'b001, // ����ֱ�лƵ�(3��)��֧�����
    S2 = 3'b010, // ������ת�̵�(12��)��֧�����
    S3 = 3'b011, // ������ת�Ƶ�(3��)��֧�����
    S4 = 3'b100, // ֧��ֱ���̵�(17��)���������
    S5 = 3'b101, // ֧��ֱ�лƵ�(3��)���������
    S6 = 3'b110, // ֧����ת�̵�(7��)���������
    S7 = 3'b111; // ֧����ת�Ƶ�(3��)���������

reg [2:0] cur_state, next_state;
reg [6:0] control_led;
reg [5:0] control_A_time, control_B_time;
reg control_C3, control_C12, control_C7, control_C27, control_C17;
reg control_LD3n, control_LD12n, control_LD7n, control_LD27n, control_LD17n;

wire AK, BK;

// ����PPTҪ���޸�AK��BK������
assign AK = (cur_state == S0) && BS && T27; // ����ֱ���̵��ڼ䣬֧���г���27��ʱ�䵽
assign BK = (cur_state == S4) && AS && T17; // ֧��ֱ���̵��ڼ䣬�����г���17��ʱ�䵽

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

// ״̬ת���߼� - ����PPTҪ���޸�
always @(*) begin
    case (cur_state)
        S0: if (AK) next_state <= S1;    // ����ֱ���̵ƽ������л����Ƶ�
            else if (T27) next_state <= S1; // ʱ�䵽���л����Ƶ�
            else next_state <= S0;
        S1: if (T3) next_state <= S2;     // ����ֱ�лƵƽ���
            else next_state <= S1;
        S2: if (T12) next_state <= S3;    // ������ת�̵ƽ���
            else next_state <= S2;
        S3: if (T3) next_state <= S4;     // ������ת�Ƶƽ������л���֧��
            else next_state <= S3;
        S4: if (BK) next_state <= S5;     // ֧��ֱ���̵ƽ������л����Ƶ�
            else if (T17) next_state <= S5; // ʱ�䵽���л����Ƶ�
            else next_state <= S4;
        S5: if (T3) next_state <= S6;     // ֧��ֱ�лƵƽ���
            else next_state <= S5;
        S6: if (T7) next_state <= S7;     // ֧����ת�̵ƽ���
            else next_state <= S6;
        S7: if (T3) next_state <= S0;     // ֧����ת�Ƶƽ������л�������
            else next_state <= S7;
        default: next_state <= S0;
    endcase
end

// ״̬�Ĵ���
always @(posedge CLK or negedge RSTn) begin
    if (!RSTn) cur_state <= S0;
    else cur_state <= next_state;
end

// ����߼� - ����PPTҪ���޸�LED���
always @(*) begin
    if (!RSTn) begin
        control_led <= 7'b0011000; // ��λ״̬�������̵ƣ�֧�����
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
            S0: begin // ����ֱ���̵ƣ�֧�����
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
                control_A_time <= SD27 + 1; // �޸ģ���1
                control_B_time <= (SD27 + 1) + 2 * Y_time + G_time12; // �޸ģ���1
                control_led <= 7'b0011000; // �����̵ƣ�֧�����
            end
            S1: begin // ����ֱ�лƵƣ�֧�����
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
                control_A_time <= SD3 + 1; // �޸ģ���1
                control_B_time <= (SD3 + 1) + Y_time + G_time12; // �޸ģ���1
                control_led <= 7'b0101000; // �����Ƶƣ�֧�����
            end
            S2: begin // ������ת�̵ƣ�֧�����
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
                control_A_time <= SD12 + 1; // �޸ģ���1
                control_B_time <= (SD12 + 1) + Y_time; // �޸ģ���1
                control_led <= 7'b0001001; // ������ת�̵ƣ�֧�����
            end
            S3: begin // ������ת�Ƶƣ�֧�����
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
                control_A_time <= SD3 + 1; // �޸ģ���1
                control_B_time <= SD3 + 1; // �޸ģ���1
                control_led <= 7'b0100010; // ������ת�Ƶƣ�֧�����
            end
            S4: begin // ֧��ֱ���̵ƣ��������
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
                control_A_time <= (SD17 + 1) + 2 * Y_time + G_time7; // �޸ģ���1
                control_B_time <= SD17 + 1; // �޸ģ���1
                control_led <= 7'b1000010; // ������ƣ�֧���̵�
            end
            S5: begin // ֧��ֱ�лƵƣ��������
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
                control_A_time <= (SD3 + 1) + Y_time + G_time7; // �޸ģ���1
                control_B_time <= SD3 + 1; // �޸ģ���1
                control_led <= 7'b1000100; // ������ƣ�֧���Ƶ�
            end
            S6: begin // ֧����ת�̵ƣ��������
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
                control_A_time <= (SD7 + 1) + Y_time; // �޸ģ���1�����ϻƵ�ʱ��
                control_B_time <= SD7 + 1; // �޸ģ���1
                control_led <= 7'b1000001; // ������ƣ�֧����ת�̵�
            end
            S7: begin // ֧����ת�Ƶƣ��������
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
                control_A_time <= SD3 + 1; // �޸ģ���1
                control_B_time <= SD3 + 1; // �޸ģ���1
                control_led <= 7'b1000100; // ������ƣ�֧����ת�Ƶ�
            end
            default: begin
                control_LD27n <= 1'b0;
                control_C17 <= 1'b0;
                control_C27 <= 1'b0;
                control_C7 <= 1'b0;
                control_C12 <= 1'b0;
                control_C3 <= 1'b0;
                control_led <= 7'b0100001; // Ĭ��״̬�������̵ƣ�֧�����
            end
        endcase
    end
end

endmodule