`timescale 1 ns / 100 ps
module traffic_tb();
    reg AS;
    reg BS;
    reg CLK;
    reg RSTn;
    wire [5:0] A_time;
    wire [5:0] B_time;
    wire [6:0] led;
    wire [2:0] state;

    trafficlight DUT (
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
        RSTn = 1'b0;
        #5 RSTn = 1'b1;
    
        {AS, BS} = 2'b10;
        #250; 
        {AS, BS} = 2'b11;
        #250;
        {AS, BS} = 2'b01;
        #449; 
        {AS, BS} = 2'b10;
        #51;
    end

    always begin
        CLK = 1'b0;
        #5 CLK = 1'b1;
        #5;
    end

    initial begin
        #2000 $stop;
    end
endmodule