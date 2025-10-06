`timescale 1ns / 1ps

module trafficlight_tb();
    reg AS;
    reg BS;
    reg CLK;
    reg RSTn;
    wire [5:0] A_time;
    wire [5:0] B_time;
    wire [5:0] led;
    wire [1:0] state;

    trafficlight DUT(
        .CLK(CLK),
        .RSTn(RSTn),
        .AS(AS),
        .BS(BS),
        .state(state),
        .A_time(A_time),
        .B_time(B_time),
        .led(led)
    );
    initial begin
        $dumpfile("trafficlight_waveform.vcd");
        $dumpvars(0, trafficlight_tb);
    end
    initial begin 
        RSTn = 1'b0;
        #20 RSTn = 1'b1; // 延时复位
    end

    initial begin
        AS = 1'b1;
        #140 AS = 1'b0;
        #90 AS = 1'b1;
        #220 AS = 1'b0;
        #320 AS = 1'b1;
    end 

    initial begin
        BS = 1'b1;
        #230 BS = 1'b0;
        #110 BS = 1'b1;
        #110 BS = 1'b0;
        #170 BS = 1'b1;
    end

    always begin
        CLK = 1'b0;
        #5 CLK = 1'b1;
        #5;
    end 

    // 添加监控输出
    initial begin
        $monitor("Time=%t, State=%b, A_time=%d, B_time=%d, LED=%b", 
                 $time, state, A_time, B_time, led);
    end

    // ==========================================================
    // ==           在这里添加仿真结束的时间限制               ==
    // ==========================================================
    // 你的最后一个激励在 #320 发生，我们让仿真再多运行 50ns，然后结束。
    // 总仿真时间为 20 + 140 + 90 + 220 + 320 + 50 = 840ns
    initial begin
        #840; // 等待所有激励和响应完成
        $finish; // 明确地结束仿真
    end
    // ==========================================================

endmodule