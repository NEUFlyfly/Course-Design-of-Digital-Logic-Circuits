module trafficlight(
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
wire T3,T27;
wire C3,C27;
wire [5:0]SD3,SD27;
wire LD3n,LD27n;
control UC(
.CLK(CLK),
.RSTn(RSTn),
.AS(AS),
.BS(BS),
.T3(T3),
.T27(T27),
.SD3(SD3),
.SD27(SD27),
.C3(C3),
.C27(C27),
.LD3n(LD3n),
.LD27n(LD27n),
.state(state),
.A_time(A_time),
.B_time(B_time),
.led(led)
);
count UD3(
.CLK(CLK),
.RSTn(RSTn), // �첽��λ
.LDn(LD3n),
.E(C3),
.PD(Y_time - 1'b1),
.QT(SD3),
.RCO(T3)
);
count UD27(
.CLK(CLK),
.RSTn(RSTn), // �첽��λ
.LDn(LD27n),
.E(C27),
.PD(AG_time - 1'b1),
.QT(SD27),
.RCO(T27)
);
endmodule