// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Wed Oct 25 15:48:06 2023
// Host        : DESKTOP-9KI73P1 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/24121/Desktop/minimip32-lite-master/minimip32-lite-master/CPU/project_1/project_1.srcs/sources_1/ip/inst_rom_1/inst_rom_stub.v
// Design      : inst_rom
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k70tfbv676-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_2,Vivado 2018.3" *)
module inst_rom(clka, ena, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,addra[10:0],douta[31:0]" */;
  input clka;
  input ena;
  input [10:0]addra;
  output [31:0]douta;
endmodule
