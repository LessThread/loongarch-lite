// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Tue Sep  5 13:52:18 2023
// Host        : LAPTOP-BEASOA6F running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               d:/Work/vivado_project/LoongArch32_Lite_FullSyS/LoongArch32_Lite_FullSyS.srcs/sources_1/ip/clk_sync/clk_sync_stub.v
// Design      : clk_sync
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tftg256-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_sync(clk_out, resetn, locked, clk_in)
/* synthesis syn_black_box black_box_pad_pin="clk_out,resetn,locked,clk_in" */;
  output clk_out;
  input resetn;
  output locked;
  input clk_in;
endmodule
