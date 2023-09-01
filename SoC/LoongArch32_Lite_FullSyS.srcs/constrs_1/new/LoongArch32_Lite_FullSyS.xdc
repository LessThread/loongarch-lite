set_property IOSTANDARD LVCMOS33 [get_ports sys_clk_25M]
set_property IOSTANDARD LVCMOS33 [get_ports sys_rst_n]
set_property PACKAGE_PIN F5 [get_ports sys_clk_25M]
set_property PACKAGE_PIN K5 [get_ports sys_rst_n]

#Constraints of input ports dip_sw
set_property -dict { PACKAGE_PIN K15 IOSTANDARD LVCMOS33 } [get_ports { dip_sw[7] }];
set_property -dict { PACKAGE_PIN J13 IOSTANDARD LVCMOS33 } [get_ports { dip_sw[6] }];
set_property -dict { PACKAGE_PIN B10 IOSTANDARD LVCMOS33 } [get_ports { dip_sw[5] }];
set_property -dict { PACKAGE_PIN A10 IOSTANDARD LVCMOS33 } [get_ports { dip_sw[4] }];
set_property -dict { PACKAGE_PIN B12 IOSTANDARD LVCMOS33 } [get_ports { dip_sw[3] }];
set_property -dict { PACKAGE_PIN B11 IOSTANDARD LVCMOS33 } [get_ports { dip_sw[2] }];
set_property -dict { PACKAGE_PIN D11 IOSTANDARD LVCMOS33 } [get_ports { dip_sw[1] }];
set_property -dict { PACKAGE_PIN B9  IOSTANDARD LVCMOS33 } [get_ports { dip_sw[0] }];

#Constraints of input ports btn_array
set_property -dict { PACKAGE_PIN L2  IOSTANDARD LVCMOS33 } [get_ports { btn_rc[7] }];
set_property -dict { PACKAGE_PIN L3  IOSTANDARD LVCMOS33 } [get_ports { btn_rc[6] }];
set_property -dict { PACKAGE_PIN J1  IOSTANDARD LVCMOS33 } [get_ports { btn_rc[5] }];
set_property -dict { PACKAGE_PIN A9  IOSTANDARD LVCMOS33 } [get_ports { btn_rc[4] }];
set_property -dict { PACKAGE_PIN C8  IOSTANDARD LVCMOS33 } [get_ports { btn_rc[3] }];
set_property -dict { PACKAGE_PIN D10 IOSTANDARD LVCMOS33 } [get_ports { btn_rc[2] }];
set_property -dict { PACKAGE_PIN P6  IOSTANDARD LVCMOS33 } [get_ports { btn_rc[1] }];
set_property -dict { PACKAGE_PIN K16 IOSTANDARD LVCMOS33 } [get_ports { btn_rc[0] }];

#Constraints of ports uart
set_property IOSTANDARD LVCMOS33 [get_ports rxd]
set_property IOSTANDARD LVCMOS33 [get_ports txd]
set_property PACKAGE_PIN D8 [get_ports rxd]
set_property PACKAGE_PIN A12 [get_ports txd]

#Constraints of output ports anH
set_property -dict { PACKAGE_PIN D9   IOSTANDARD LVCMOS33 } [get_ports { anH[0] }];
set_property -dict { PACKAGE_PIN E12  IOSTANDARD LVCMOS33 } [get_ports { anH[1] }];
set_property -dict { PACKAGE_PIN E13  IOSTANDARD LVCMOS33 } [get_ports { anH[2] }];
set_property -dict { PACKAGE_PIN E11  IOSTANDARD LVCMOS33 } [get_ports { anH[3] }];
#Constraints of output ports a_to_gH
set_property -dict { PACKAGE_PIN C4  IOSTANDARD LVCMOS33 } [get_ports { a_to_gH[7] }];
set_property -dict { PACKAGE_PIN D5  IOSTANDARD LVCMOS33 } [get_ports { a_to_gH[6] }];
set_property -dict { PACKAGE_PIN D6  IOSTANDARD LVCMOS33 } [get_ports { a_to_gH[5] }];
set_property -dict { PACKAGE_PIN C6  IOSTANDARD LVCMOS33 } [get_ports { a_to_gH[4] }];
set_property -dict { PACKAGE_PIN T9  IOSTANDARD LVCMOS33 } [get_ports { a_to_gH[3] }];
set_property -dict { PACKAGE_PIN L12 IOSTANDARD LVCMOS33 } [get_ports { a_to_gH[2] }];
set_property -dict { PACKAGE_PIN L13 IOSTANDARD LVCMOS33 } [get_ports { a_to_gH[1] }];
set_property -dict { PACKAGE_PIN K13 IOSTANDARD LVCMOS33 } [get_ports { a_to_gH[0] }];

#Constraints of output ports anL
set_property -dict { PACKAGE_PIN E16 IOSTANDARD LVCMOS33 } [get_ports { anL[0] }];
set_property -dict { PACKAGE_PIN B4  IOSTANDARD LVCMOS33 } [get_ports { anL[1] }];
set_property -dict { PACKAGE_PIN A3  IOSTANDARD LVCMOS33 } [get_ports { anL[2] }];
set_property -dict { PACKAGE_PIN C3  IOSTANDARD LVCMOS33 } [get_ports { anL[3] }];
#Constraints of output ports a_to_gL
set_property -dict { PACKAGE_PIN F4  IOSTANDARD LVCMOS33 } [get_ports { a_to_gL[7] }];
set_property -dict { PACKAGE_PIN E5  IOSTANDARD LVCMOS33 } [get_ports { a_to_gL[6] }];
set_property -dict { PACKAGE_PIN D1  IOSTANDARD LVCMOS33 } [get_ports { a_to_gL[5] }];
set_property -dict { PACKAGE_PIN E2  IOSTANDARD LVCMOS33 } [get_ports { a_to_gL[4] }];
set_property -dict { PACKAGE_PIN B1  IOSTANDARD LVCMOS33 } [get_ports { a_to_gL[3] }];
set_property -dict { PACKAGE_PIN C1  IOSTANDARD LVCMOS33 } [get_ports { a_to_gL[2] }];
set_property -dict { PACKAGE_PIN B2  IOSTANDARD LVCMOS33 } [get_ports { a_to_gL[1] }];
set_property -dict { PACKAGE_PIN C2  IOSTANDARD LVCMOS33 } [get_ports { a_to_gL[0] }];

#Constraints of output ports leds
set_property -dict { PACKAGE_PIN F12 IOSTANDARD LVCMOS33 } [get_ports { leds[7] }];
set_property -dict { PACKAGE_PIN D15 IOSTANDARD LVCMOS33 } [get_ports { leds[6] }];
set_property -dict { PACKAGE_PIN D14 IOSTANDARD LVCMOS33 } [get_ports { leds[5] }];
set_property -dict { PACKAGE_PIN R7  IOSTANDARD LVCMOS33 } [get_ports { leds[4] }];
set_property -dict { PACKAGE_PIN R6  IOSTANDARD LVCMOS33 } [get_ports { leds[3] }];
set_property -dict { PACKAGE_PIN T5  IOSTANDARD LVCMOS33 } [get_ports { leds[2] }];
set_property -dict { PACKAGE_PIN R5  IOSTANDARD LVCMOS33 } [get_ports { leds[1] }];
set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports { leds[0] }];

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]