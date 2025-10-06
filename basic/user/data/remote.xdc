# Clock
set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS33} [get_ports clk_50M]

create_clock -period 20.000 -name clk_50M -waveform {0.000 10.000} [get_ports clk_50M]

# 按钮引脚约束
set_property -dict {PACKAGE_PIN T3 IOSTANDARD LVCMOS33} [get_ports AS]
set_property -dict {PACKAGE_PIN J3 IOSTANDARD LVCMOS33} [get_ports BS]
set_property -dict {PACKAGE_PIN U5 IOSTANDARD LVCMOS33} [get_ports reset_btn]

# Digital Video - VGA输出
set_property -dict {PACKAGE_PIN H22 IOSTANDARD LVCMOS33} [get_ports video_clk]
set_property -dict {PACKAGE_PIN E26 IOSTANDARD LVCMOS33} [get_ports {video_red[2]}]
set_property -dict {PACKAGE_PIN F24 IOSTANDARD LVCMOS33} [get_ports {video_red[1]}]
set_property -dict {PACKAGE_PIN K23 IOSTANDARD LVCMOS33} [get_ports {video_red[0]}]
set_property -dict {PACKAGE_PIN F23 IOSTANDARD LVCMOS33} [get_ports {video_green[2]}]
set_property -dict {PACKAGE_PIN E23 IOSTANDARD LVCMOS33} [get_ports {video_green[1]}]
set_property -dict {PACKAGE_PIN K22 IOSTANDARD LVCMOS33} [get_ports {video_green[0]}]
set_property -dict {PACKAGE_PIN D25 IOSTANDARD LVCMOS33} [get_ports {video_blue[1]}]
set_property -dict {PACKAGE_PIN E25 IOSTANDARD LVCMOS33} [get_ports {video_blue[0]}]
set_property -dict {PACKAGE_PIN J24 IOSTANDARD LVCMOS33} [get_ports video_hsync]
set_property -dict {PACKAGE_PIN H24 IOSTANDARD LVCMOS33} [get_ports video_vsync]
set_property -dict {PACKAGE_PIN G24 IOSTANDARD LVCMOS33} [get_ports video_de]

# LED指示灯 - 用于显示交通灯状态
set_property -dict {PACKAGE_PIN B24 IOSTANDARD LVCMOS33} [get_ports {led[0]}]
set_property -dict {PACKAGE_PIN E21 IOSTANDARD LVCMOS33} [get_ports {led[1]}]
set_property -dict {PACKAGE_PIN A24 IOSTANDARD LVCMOS33} [get_ports {led[2]}]
set_property -dict {PACKAGE_PIN D23 IOSTANDARD LVCMOS33} [get_ports {led[3]}]
set_property -dict {PACKAGE_PIN C22 IOSTANDARD LVCMOS33} [get_ports {led[4]}]
set_property -dict {PACKAGE_PIN C21 IOSTANDARD LVCMOS33} [get_ports {led[5]}]

# 状态指示灯 - 使用LED显示状态
set_property -dict {PACKAGE_PIN E20 IOSTANDARD LVCMOS33} [get_ports {state[0]}]
set_property -dict {PACKAGE_PIN B22 IOSTANDARD LVCMOS33} [get_ports {state[1]}]

# 时间显示 - 使用数码管显示剩余时间
# A_time - 使用第一个数码管(DPY0)
set_property -dict {PACKAGE_PIN B19 IOSTANDARD LVCMOS33} [get_ports {A_time[0]}]
set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS33} [get_ports {A_time[1]}]
set_property -dict {PACKAGE_PIN B21 IOSTANDARD LVCMOS33} [get_ports {A_time[2]}]
set_property -dict {PACKAGE_PIN A19 IOSTANDARD LVCMOS33} [get_ports {A_time[3]}]
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS33} [get_ports {A_time[4]}]
set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVCMOS33} [get_ports {A_time[5]}]

# B_time - 使用第二个数码管(DPY1)
set_property -dict {PACKAGE_PIN A17 IOSTANDARD LVCMOS33} [get_ports {B_time[0]}]
set_property -dict {PACKAGE_PIN D16 IOSTANDARD LVCMOS33} [get_ports {B_time[1]}]
set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVCMOS33} [get_ports {B_time[2]}]
set_property -dict {PACKAGE_PIN F17 IOSTANDARD LVCMOS33} [get_ports {B_time[3]}]
set_property -dict {PACKAGE_PIN E16 IOSTANDARD LVCMOS33} [get_ports {B_time[4]}]
set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVCMOS33} [get_ports {B_time[5]}]

# 系统状态指示灯
set_property -dict {PACKAGE_PIN C23 IOSTANDARD LVCMOS33} [get_ports leds]

# 解决时钟路由问题
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets reset_btn_IBUF]

# 必要的配置属性
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]