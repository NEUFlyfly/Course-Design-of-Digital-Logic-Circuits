`default_nettype none `timescale 1ns / 1ps

module lcd_top (
    input wire clk_50M,     //50MHz ʱ������

    input wire reset_btn,  //BTN6�ֶ���λ��ť����������·������ʱΪ1
    input wire [3:0] countA_shi,
    input wire [3:0] countA_ge,
    input wire [3:0] countB_shi,
    input wire [3:0] countB_ge,   
    input wire [3:0] countC_shi,
    input wire [3:0] countC_ge,
    input wire [3:0] countD_shi,//0,0,1,0,1,0����������
    input wire [3:0] countD_ge,
    input wire [3:0] countE_shi,
    input wire [3:0] countE_ge,
    input wire [3:0] countF_shi,
    input wire [3:0] countF_ge,
    output wire  leds,
    //ͼ������ź�
    output wire [2:0] video_red,    //��ɫ���أ�3λ
    output wire [2:0] video_green,  //��ɫ���أ�3λ
    output wire [1:0] video_blue,   //��ɫ���أ�2λ
    output wire       video_hsync,  //��ͬ����ˮƽͬ�����ź�
    output wire       video_vsync,  //��ͬ������ֱͬ�����ź�
    output wire       video_clk,    //����ʱ�����
    output wire       video_de      //��������Ч�źţ���������������
);
  // generate pixel clock
  logic clk_pix;
  logic clk_pix_locked;


  clock_divider clock_div_inst (
      .clk(clk_50M),
      .rst(reset_btn),
      .clk_div(clk_pix)
  );
    wire [15:0] line_2_ascii;
  dvi_module dvi_inst (
      .clk(clk_pix),
      .clk_locked(reset_btn),
      .video_red(video_red),
      .video_green(video_green),
      .video_blue(video_blue),
      .video_hsync(video_hsync),
      .video_vsync(video_vsync),
      .video_clk(video_clk),
      .video_de(video_de),
      .line_0_ascii(line_0),
      .line_1_ascii(line_1)

  );

  assign leds =1'b0 ;
 

  wire [79:0] line_0; // Ϊ�˷��㸳ֵ��һ��asciiռ��8bit
  wire [79:0] line_1; // 56-bit line buffer, 7 bit per ascii character

  assign line_0 = {8'h20,countA_shi+8'h30,countA_ge+8'h30,countB_shi+8'h30,countB_ge+8'h30,countC_shi+8'h30,countC_ge+8'h30,8'h20};
assign line_1 = {countE_shi+8'h30,countE_ge+8'h30,8'h20,countF_shi+8'h30,countF_ge+8'h30, 8'h20};

localparam CNT_1S = 27'd50_000_000;
reg [26:0] cnt;
wire cnt_eq_1s;
assign cnt_eq_1s = cnt==(CNT_1S-1);
always @(posedge clk_50M)
begin
    if (reset_btn)
    begin
        cnt <= 27'd0;
    end
    else if (cnt_eq_1s)
    begin
        cnt <= 27'd0;
    end
    else
    begin
        cnt <= cnt + 1'b1;
    end
end

reg [7:0] ascii;
always @(posedge clk_50M)
begin
    if (reset_btn)
    begin
        ascii <= 8'd0;
    end
    else if (cnt_eq_1s)
    begin
        if (ascii == 8'd9)
        begin
            ascii <= 8'd0;
        end
        else
        begin
            ascii <= ascii + 1'b1;
        end
    end
end

reg [4:0] number;
always @(posedge clk_50M)
begin
    if (reset_btn)
    begin
        number <= 5'h0;
    end
    else if (cnt_eq_1s)
    begin
        number <= number + 5'b1;
    end
end

endmodule

module ascii_rom_async (
    input  wire  [10:0] addr,
    output reg   [7:0] data
);

always @(*) begin
    case (addr)
        // code x30 (0)
			11'h300: data = 8'b00000000;	//
			11'h301: data = 8'b00000000;	//
			11'h302: data = 8'b00111000;	//  ***  
			11'h303: data = 8'b01101100;	// ** **
			11'h304: data = 8'b11000110;	//**   **
			11'h305: data = 8'b11000110;	//**   **
			11'h306: data = 8'b11000110;	//**   **
			11'h307: data = 8'b11000110;	//**   **
			11'h308: data = 8'b11000110;	//**   **
			11'h309: data = 8'b11000110;	//**   **
			11'h30a: data = 8'b01101100;	// ** **
			11'h30b: data = 8'b00111000;	//  ***
			11'h30c: data = 8'b00000000;	//
			11'h30d: data = 8'b00000000;	//
			11'h30e: data = 8'b00000000;	//
			11'h30f: data = 8'b00000000;	//
			// code x31 (1)
			11'h310: data = 8'b00000000;	//
			11'h311: data = 8'b00000000;	//
			11'h312: data = 8'b00011000;	//   **  
			11'h313: data = 8'b00111000;	//  ***
			11'h314: data = 8'b01111000;	// ****
			11'h315: data = 8'b00011000;	//   **
			11'h316: data = 8'b00011000;	//   **
			11'h317: data = 8'b00011000;	//   **
			11'h318: data = 8'b00011000;	//   **
			11'h319: data = 8'b00011000;	//   **
			11'h31a: data = 8'b01111110;	// ******
			11'h31b: data = 8'b01111110;	// ******
			11'h31c: data = 8'b00000000;	//
			11'h31d: data = 8'b00000000;	//
			11'h31e: data = 8'b00000000;	//
			11'h31f: data = 8'b00000000;	//
			// code x32 (2)
			11'h320: data = 8'b00000000;	//
			11'h321: data = 8'b00000000;	//
			11'h322: data = 8'b11111110;	//*******  
			11'h323: data = 8'b11111110;	//*******
			11'h324: data = 8'b00000110;	//     **
			11'h325: data = 8'b00000110;	//     **
			11'h326: data = 8'b11111110;	//*******
			11'h327: data = 8'b11111110;	//*******
			11'h328: data = 8'b11000000;	//**
			11'h329: data = 8'b11000000;	//**
			11'h32a: data = 8'b11111110;	//*******
			11'h32b: data = 8'b11111110;	//*******
			11'h32c: data = 8'b00000000;	//
			11'h32d: data = 8'b00000000;	//
			11'h32e: data = 8'b00000000;	//
			11'h32f: data = 8'b00000000;	//
			// code x33 (3)
			11'h330: data = 8'b00000000;	//
			11'h331: data = 8'b00000000;	//
			11'h332: data = 8'b11111110;	//*******  
			11'h333: data = 8'b11111110;	//*******
			11'h334: data = 8'b00000110;	//     **
			11'h335: data = 8'b00000110;	//     **
			11'h336: data = 8'b00111110;	//  *****
			11'h337: data = 8'b00111110;	//  *****
			11'h338: data = 8'b00000110;	//     **
			11'h339: data = 8'b00000110;	//     **
			11'h33a: data = 8'b11111110;	//*******
			11'h33b: data = 8'b11111110;	//*******
			11'h33c: data = 8'b00000000;	//
			11'h33d: data = 8'b00000000;	//
			11'h33e: data = 8'b00000000;	//
			11'h33f: data = 8'b00000000;	//
			// code x34 (4)
			11'h340: data = 8'b00000000;	//
			11'h341: data = 8'b00000000;	//
			11'h342: data = 8'b11000110;	//**   **  
			11'h343: data = 8'b11000110;	//**   **
			11'h344: data = 8'b11000110;	//**   **
			11'h345: data = 8'b11000110;	//**   **
			11'h346: data = 8'b11111110;	//*******
			11'h347: data = 8'b11111110;	//*******
			11'h348: data = 8'b00000110;	//     **
			11'h349: data = 8'b00000110;	//     **
			11'h34a: data = 8'b00000110;	//     **
			11'h34b: data = 8'b00000110;	//     **
			11'h34c: data = 8'b00000000;	//
			11'h34d: data = 8'b00000000;	//
			11'h34e: data = 8'b00000000;	//
			11'h34f: data = 8'b00000000;	//
			// code x35 (5)
			11'h350: data = 8'b00000000;	//
			11'h351: data = 8'b00000000;	//
			11'h352: data = 8'b11111110;	//*******  
			11'h353: data = 8'b11111110;	//*******
			11'h354: data = 8'b11000000;	//**
			11'h355: data = 8'b11000000;	//**
			11'h356: data = 8'b11111110;	//*******
			11'h357: data = 8'b11111110;	//*******
			11'h358: data = 8'b00000110;	//     **
			11'h359: data = 8'b00000110;	//     **
			11'h35a: data = 8'b11111110;	//*******
			11'h35b: data = 8'b11111110;	//*******
			11'h35c: data = 8'b00000000;	//
			11'h35d: data = 8'b00000000;	//
			11'h35e: data = 8'b00000000;	//
			11'h35f: data = 8'b00000000;	//
			// code x36 (6)
			11'h360: data = 8'b00000000;	//
			11'h361: data = 8'b00000000;	//
			11'h362: data = 8'b11111110;	//*******  
			11'h363: data = 8'b11111110;	//*******
			11'h364: data = 8'b11000000;	//**
			11'h365: data = 8'b11000000;	//**
			11'h366: data = 8'b11111110;	//*******
			11'h367: data = 8'b11111110;	//*******
			11'h368: data = 8'b11000110;	//**   **
			11'h369: data = 8'b11000110;	//**   **
			11'h36a: data = 8'b11111110;	//*******
			11'h36b: data = 8'b11111110;	//*******
			11'h36c: data = 8'b00000000;	//
			11'h36d: data = 8'b00000000;	//
			11'h36e: data = 8'b00000000;	//
			11'h36f: data = 8'b00000000;	//
			// code x37 (7)
			11'h370: data = 8'b00000000;	//
			11'h371: data = 8'b00000000;	//
			11'h372: data = 8'b11111110;	//*******  
			11'h373: data = 8'b11111110;	//*******
			11'h374: data = 8'b00000110;	//     **
			11'h375: data = 8'b00000110;	//     **
			11'h376: data = 8'b00000110;	//     **
			11'h377: data = 8'b00000110;	//     **
			11'h378: data = 8'b00000110;	//     **
			11'h379: data = 8'b00000110;	//     **
			11'h37a: data = 8'b00000110;	//     **
			11'h37b: data = 8'b00000110;	//     **
			11'h37c: data = 8'b00000000;	//
			11'h37d: data = 8'b00000000;	//
			11'h37e: data = 8'b00000000;	//
			11'h37f: data = 8'b00000000;	//
			// code x38 (8)
			11'h380: data = 8'b00000000;	//
			11'h381: data = 8'b00000000;	//
			11'h382: data = 8'b11111110;	//*******  
			11'h383: data = 8'b11111110;	//*******
			11'h384: data = 8'b11000110;	//**   **
			11'h385: data = 8'b11000110;	//**   **
			11'h386: data = 8'b11111110;	//*******
			11'h387: data = 8'b11111110;	//*******
			11'h388: data = 8'b11000110;	//**   **
			11'h389: data = 8'b11000110;	//**   **
			11'h38a: data = 8'b11111110;	//*******
			11'h38b: data = 8'b11111110;	//*******
			11'h38c: data = 8'b00000000;	//
			11'h38d: data = 8'b00000000;	//
			11'h38e: data = 8'b00000000;	//
			11'h38f: data = 8'b00000000;	//
			// code x39 (9)
			11'h390: data = 8'b00000000;	//
			11'h391: data = 8'b00000000;	//
			11'h392: data = 8'b11111110;	//*******  
			11'h393: data = 8'b11111110;	//*******
			11'h394: data = 8'b11000110;	//**   **
			11'h395: data = 8'b11000110;	//**   **
			11'h396: data = 8'b11111110;	//*******
			11'h397: data = 8'b11111110;	//*******
			11'h398: data = 8'b00000110;	//     **
			11'h399: data = 8'b00000110;	//     **
			11'h39a: data = 8'b11111110;	//*******
			11'h39b: data = 8'b11111110;	//*******
			11'h39c: data = 8'b00000000;	//
			11'h39d: data = 8'b00000000;	//
			11'h39e: data = 8'b00000000;	//
			11'h39f: data = 8'b00000000;	//
			// code x3a (:)
			11'h3a0: data = 8'b00000000;	//
			11'h3a1: data = 8'b00000000;	//
			11'h3a2: data = 8'b00000000;	//
			11'h3a3: data = 8'b00000000;	//
			11'h3a4: data = 8'b00011000;	//   **
			11'h3a5: data = 8'b00011000;	//   **
			11'h3a6: data = 8'b00000000;	//
			11'h3a7: data = 8'b00000000;	//
			11'h3a8: data = 8'b00011000;	//   **
			11'h3a9: data = 8'b00011000;	//   **
			11'h3aa: data = 8'b00000000;	//   
			11'h3ab: data = 8'b00000000;	//   
			11'h3ac: data = 8'b00000000;	//
			11'h3ad: data = 8'b00000000;	//
			11'h3ae: data = 8'b00000000;	//
			11'h3af: data = 8'b00000000;	//
            
            default: data = 8'b00000000;
endcase
end
endmodule

module bin2bcd(
    input wire [4:0] bin,
    output wire [7:0] bcd
);

integer i;

reg [3:0] ones;
reg [3:0] tens;

always @(bin) begin
    ones = 4'b0;
    tens = 4'b0;

    for (i = 4; i >=0; i = i - 1) begin
        if (ones >= 5) begin
            ones = ones + 3;
        end
        if (tens >= 5) begin
            tens = tens + 3;
        end
        tens = {tens[2:0], ones[3]};
        ones = {ones[2:0], bin[i]};
    end
end
assign bcd = {tens, ones};

endmodule

module clock_divider(
    input wire clk,
    input wire rst,
    output reg clk_div
);
always @(posedge clk) begin
    if (rst) begin
        clk_div <= 1'b0;
    end else begin
        clk_div <= ~clk_div;
    end
end
    
endmodule

module dvi_module (
    input   wire          clk,
    input     wire        clk_locked,
    //ͼ������ź�
    output wire [2:0] video_red,    //��ɫ���أ�3λ
    output wire [2:0] video_green,  //��ɫ���أ�3λ
    output wire [1:0] video_blue,   //��ɫ���أ�2λ
    output wire       video_hsync,  //��ͬ����ˮƽͬ�����ź�
    output wire       video_vsync,  //��ͬ������ֱͬ�����ź�
    output wire       video_clk,    //����ʱ�����
    output wire       video_de,     //��������Ч�źţ���������������

    input wire [79:0] line_0_ascii,  //ÿ��ascii��ռ8λ
    input wire [79:0] line_1_ascii

);

  // display sync signals and coordinaties
  localparam CORDW = 10;  // screen coordinate width in bits
  logic [CORDW-1:0] sx, sy;
  logic hsync, vsync, de;
  simple_480p display_inst (
      .clk_pix(clk),
      .rst_pix(clk_locked),  // wait for clock lock
      .sx,
      .sy,
      .hsync,
      .vsync,
      .de
  );

  wire [3:0] column_from_left;
  wire [3:0] line_from_top;
  localparam MAX_COLUMN = 10;
  localparam MAX_LINE = 3;
  assign column_from_left = sx[9:6]; // 64 bit per column, 640 / 64 = 10 columns (MAX column) 4'b1010
  assign line_from_top = sy[9:7];  // 480 / 128 = 3 lines (MAX line) 4'b0011

  wire [7:0] ascii;
  // wire []
  wire [6:0] column_location;
  assign column_location = column_from_left << 3;
  assign ascii = (line_from_top == 0) ? line_0_ascii[79-column_location -: 8] :
               (line_from_top == 1) ? line_1_ascii[79-column_location -: 8] :
              8'b0;

  wire [7:0] ascii_rom_line;

  wire [2:0] ascii_column;
  wire [3:0] ascii_line;
  assign ascii_column = sx[5:3]; // �Ŵ�8����Ĭ��״̬�£�һ���ַ�����ռ8������
  assign ascii_line = sy[6:3]; // �Ŵ�8����Ĭ��״̬�£�һ���ַ�����ռ16������

  ascii_rom_async ascii_rom_inst (
      .addr({ascii[6:0], ascii_line}),
      .data(ascii_rom_line)
  );

  wire draw_ascii;
  assign draw_ascii = ascii_rom_line[7-ascii_column];

  // paint colour: yellow lines, blue background
  logic [3:0] paint_r, paint_g, paint_b;
  always_comb begin
    paint_r = (draw_ascii) ? 4'hF : 4'h1;
    paint_g = (draw_ascii) ? 4'hC : 4'h3;
    paint_b = (draw_ascii) ? 4'h0 : 4'h7;
  end

  // display colour: paint colour but black in blanking interval
  logic [3:0] display_r, display_g, display_b;
  always_comb begin
    display_r = (de) ? paint_r : 4'h0;
    display_g = (de) ? paint_g : 4'h0;
    display_b = (de) ? paint_b : 4'h0;
  end

  reg vga_hsync, vga_vsync;
  reg [3:0] vga_r, vga_g, vga_b;
  // VGA Pmod output
  always_ff @(posedge clk) begin
    vga_hsync <= hsync;
    vga_vsync <= vsync;
    vga_r <= display_r;
    vga_g <= display_g;
    vga_b <= display_b;
  end

  assign video_clk   = clk;
  assign video_hsync = hsync;
  assign video_vsync = vsync;
  assign video_red   = display_r[3:1];
  assign video_green = display_g[3:1];
  assign video_blue  = display_b[3:2];
  assign video_de    = de;

endmodule


module simple_480p (
    input  wire logic clk_pix,  // pixel clock
    input  wire logic rst_pix,  // reset in pixel clock domain   
    output      logic [9:0] sx, // horizontal screen position
    output      logic [9:0] sy, // vertical screen position
    output      logic hsync,    // horizontal sync
    output      logic vsync,    // vertical sync
    output      logic de        // data enable (low in blanking interval)
);
    // horizontal timings
    parameter HA_END = 639;          // end of active pixels
    parameter HS_STA = HA_END + 16; // sync starts after front porch 655
    parameter HS_END = HS_STA + 96; // SYNC ENDS 
    parameter LINE   = 799;         // last pixel on line (after back porch)

    // vertical timings
    parameter VA_END = 479;         // end of active pixels
    parameter VS_STA = VA_END + 10; // sync starts after front porch
    parameter VS_END = VS_STA + 2;  // sync ends
    parameter SCREEN = 524;         // last line on screen (after back porch)

    always_comb begin
        hsync = ~(sx >= HS_STA && sx < HS_END); // invert: negative polarity
        vsync = ~(sy >= VS_STA && sy < VS_END); // invert: negative polarity
        de = (sx <= HA_END && sy <= VA_END);
    end

    // CALCULATE HORIZONTAL AND VERTICAL SCREEN POSTITION
    always_ff @(posedge clk_pix) begin
        if (sx == LINE) begin // last pixel on line ?
            sx <= 0;
            sy <= (sy == SCREEN) ? 0 : sy + 1; // last line on screen ?
        end else begin
            sx <= sx + 1;
        end

        if (rst_pix) begin
            sx <= 0;
            sy <= 0;
        end
    end

endmodule

module test_bin2bcd;

    reg [4:0] bin;
    wire [7:0] bcd;

    // Instantiate the module
    bin2bcd u_bin2bcd (
        .bin(bin),
        .bcd(bcd)
    );

    initial begin
        // Test case 1: binary 0
        bin = 5'b00000;
        #10;
        $display("bin: %b, bcd: %b", bin, bcd);

        // Test case 2: binary 10
        bin = 5'b01010;
        #10;
        $display("bin: %b, bcd: %b", bin, bcd);

        // Test case 3: binary 31
        bin = 5'b11111;
        #10;
        $display("bin: %b, bcd: %b", bin, bcd);

        // Add more test cases as needed
    end

endmodule