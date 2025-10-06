module count_sub(
    input CLK,       // ʱ���ź�
    input LDn,       // �����źţ�����Ч
    input E,         // ������ʹ��
    input [5:0] PD,  // Ԥ����
    output [5:0] QT, // ��ǰ����ֵ
    output RCO       // ��λ����ź�
);
reg [5:0] SQ;
assign RCO = (SQ == 0); // �޸ģ���������Ϊ0ʱ������λ�ź�
assign QT = SQ;
always @(posedge CLK) begin
    if(!LDn) SQ <= PD;
    else begin
        if(E) begin
            if(SQ == 0) SQ <= PD;
            else SQ <= SQ - 1;
        end
    end
end

endmodule