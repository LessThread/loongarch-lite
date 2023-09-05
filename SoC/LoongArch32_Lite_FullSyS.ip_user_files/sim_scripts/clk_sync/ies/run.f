-makelib ies_lib/xpm -sv \
  "D:/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies_lib/xpm \
  "D:/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../LoongArch32_Lite_FullSyS.srcs/sources_1/ip/clk_sync/clk_sync_clk_wiz.v" \
  "../../../../LoongArch32_Lite_FullSyS.srcs/sources_1/ip/clk_sync/clk_sync.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

