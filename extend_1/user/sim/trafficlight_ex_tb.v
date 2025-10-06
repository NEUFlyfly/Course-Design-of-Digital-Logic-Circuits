`timescale 1ns / 1ps
module trafficlight_ex_tb();
reg AS;
reg BS;
reg CLK;
reg RSTn;
wire [5:0] A_time;
wire [5:0] B_time;
wire [5:0] led;
wire [1:0] state;

trafficlight_ex DUT(
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
    #1000 $stop;
end

initial begin 
    RSTn = 1'b0;
    #5 RSTn = 1'b1;
end

initial begin
    AS = 1'b1;
end 

initial begin
    BS = 1'b1;

end

always begin
    CLK = 1'b0;
    #5 CLK = 1'b1;
    #5;
end 
endmodule