`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/22 12:20:22
// Design Name: 
// Module Name: MCU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MCU(
    input  wire [`ALUOP_BUS	    ] 	mcu_aluop_i,
    input  wire [`REG_BUS 		] 	mcu_wd_i,
    
    output wire [3 : 0]   mcu_dre,
    output wire           mcu_dce,
    output wire [3 : 0]   mcu_we
    );
    assign mcu_dce = (mcu_aluop_i == `LoongArch32_LD_W) ? 1 : 
                     (mcu_aluop_i == `LoongArch32_ST_W) ? 1 :
                     (mcu_aluop_i == `LoongArch32_LD_B) ? 1 : 
                     (mcu_aluop_i == `LoongArch32_ST_B) ? 1 : 0;
    assign mcu_dre[3] = (mcu_aluop_i == `LoongArch32_LD_B) & (mcu_wd_i[1 : 0] == 2'b00) | (mcu_aluop_i == `LoongArch32_LD_W);
    assign mcu_dre[2] = (mcu_aluop_i == `LoongArch32_LD_B) & (mcu_wd_i[1 : 0] == 2'b01) | (mcu_aluop_i == `LoongArch32_LD_W);
    assign mcu_dre[1] = (mcu_aluop_i == `LoongArch32_LD_B) & (mcu_wd_i[1 : 0] == 2'b10) | (mcu_aluop_i == `LoongArch32_LD_W);
    assign mcu_dre[0] = (mcu_aluop_i == `LoongArch32_LD_B) & (mcu_wd_i[1 : 0] == 2'b11) | (mcu_aluop_i == `LoongArch32_LD_W);
    assign mcu_we[3] = (mcu_aluop_i == `LoongArch32_ST_B) & (mcu_wd_i[1 : 0] == 2'b00) | (mcu_aluop_i == `LoongArch32_ST_W);
    assign mcu_we[2] = (mcu_aluop_i == `LoongArch32_ST_B) & (mcu_wd_i[1 : 0] == 2'b01) | (mcu_aluop_i == `LoongArch32_ST_W);
    assign mcu_we[1] = (mcu_aluop_i == `LoongArch32_ST_B) & (mcu_wd_i[1 : 0] == 2'b10) | (mcu_aluop_i == `LoongArch32_ST_W);
    assign mcu_we[0] = (mcu_aluop_i == `LoongArch32_ST_B) & (mcu_wd_i[1 : 0] == 2'b11) | (mcu_aluop_i == `LoongArch32_ST_W);
endmodule
