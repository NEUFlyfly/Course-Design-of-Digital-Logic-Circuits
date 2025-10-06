module trafficlight_ex(
    input wire CLK,        
    input wire RSTn,       
    input wire AS,         
    input wire BS,         
    output wire [1:0] state, 
    output wire [5:0] led,  
    output wire [5:0] A_time, 
    output wire [5:0] B_time  
);
parameter Y_time = 6'd3;
parameter AG_time = 6'd27;
parameter BG_time = 6'd17;
wire T3,T17,T27;
wire C3,C17,C27;
wire [5:0]SD3,SD17,SD27;
wire LD3n,LD17n,LD27n;

control_ex UC(
    .CLK(CLK),
    .RSTn(RSTn),
    .AS(AS),
    .BS(BS),
    .T3(T3),
    .T17(T17),
    .T27(T27),
    .SD3(SD3),
    .SD17(SD17),
    .SD27(SD27),
    .C3(C3),
    .C17(C17),
    .C27(C27),
    .LD3n(LD3n),
    .LD17n(LD17n),
    .LD27n(LD27n),
    .state(state),
    .led(led)
);

count UD3(
    .CLK(CLK),
    .LDn(LD3n),
    .E(C3),
    .PD(Y_time),
    .QT(SD3),
    .RCO(T3)
);

count UD17(
    .CLK(CLK),
    .LDn(LD17n),
    .E(C17),
    .PD(BG_time),
    .QT(SD17),
    .RCO(T17)
);

count UD27(
    .CLK(CLK),
    .LDn(LD27n),
    .E(C27),
    .PD(AG_time),
    .QT(SD27),
    .RCO(T27)
);

assign A_time = (state == 2'b00) ? (SD27 == 6'd0 ? 6'd1 : SD27) : 
                (state == 2'b01) ? (SD3 == 6'd0 ? 6'd1 : SD3) : 
                (state == 2'b10) ? (SD17 == 6'd0 ? 6'd1 : (SD17 + Y_time)) : 
                (state == 2'b11) ? (SD3 == 6'd0 ? 6'd1 : SD3) : 
                6'd0;
                
assign B_time = (state == 2'b00) ? (SD27 == 6'd0 ? 6'd1 : (SD27 + Y_time)) : 
                (state == 2'b01) ? (SD3 == 6'd0 ? 6'd1 : SD3) : 
                (state == 2'b10) ? (SD17 == 6'd0 ? 6'd1 : SD17) : 
                (state == 2'b11) ? (SD3 == 6'd0 ? 6'd1 : SD3) : 
                6'd0;

endmodule