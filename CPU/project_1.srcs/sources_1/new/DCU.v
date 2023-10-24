`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/24 12:20:34
// Design Name: 
// Module Name: DCU
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


module DCU(
    input  wire [16 : 0]         dcu_op17,
    
    output wire                  dcu_wreg,
    output wire [2 : 0]          dcu_alutype,
    output wire [7 : 0]          dcu_aluop,
    output wire                  dcu_rreg1,
    output wire                  dcu_rreg2,
    output wire                  dcu_mreg,
    output wire                  dcu_immsel,
    output wire                  dcu_sext,
    output wire                  dcu_upper,
    output wire                  dcu_pcadd
    );
    /*-------------------- 第一级译码逻辑：确定当前需要译码的指令 --------------------*/
    // 3R型指令
    wire inst_3R = ~|dcu_op17[16:6];//针对实现的3R型指令op字段高11位均为0，单独提取 
    wire inst_addw = inst_3R &  dcu_op17[5] & ~dcu_op17[4] & ~dcu_op17[3] & ~dcu_op17[2] & ~dcu_op17[1] & ~dcu_op17[0];
    wire inst_sltu = inst_3R &  dcu_op17[5] & ~dcu_op17[4] & ~dcu_op17[3] &  dcu_op17[2] & ~dcu_op17[1] &  dcu_op17[0];
    wire inst_or   = inst_3R &  dcu_op17[5] & ~dcu_op17[4] &  dcu_op17[3] & ~dcu_op17[2] &  dcu_op17[1] & ~dcu_op17[0];
    wire inst_xor  = inst_3R &  dcu_op17[5] & ~dcu_op17[4] &  dcu_op17[3] & ~dcu_op17[2] &  dcu_op17[1] &  dcu_op17[0];
    wire inst_srlw = inst_3R &  dcu_op17[5] & ~dcu_op17[4] &  dcu_op17[3] &  dcu_op17[2] &  dcu_op17[1] &  dcu_op17[0];
    
    // 2R12I型指令
    wire inst_2R12I_normal = ~|dcu_op17[16:11] & ~inst_3R;//针对2R12i型指令中部分需实现指令op字段高6位为0进行简化
    wire inst_addiw = inst_2R12I_normal &  dcu_op17[10] & ~dcu_op17[9] &  dcu_op17[8] & ~dcu_op17[7];
    wire inst_andi  = inst_2R12I_normal &  dcu_op17[10] &  dcu_op17[9] & ~dcu_op17[8] &  dcu_op17[7];
    wire inst_ori   = inst_2R12I_normal &  dcu_op17[10] &  dcu_op17[9] &  dcu_op17[8] & ~dcu_op17[7];

    //指令lu12i.w和pacddu12i
    wire inst_20I = ~|dcu_op17[16:14] & ~inst_3R & ~inst_2R12I_normal;
    wire inst_lu12iw    = inst_20I &  dcu_op17[13] & ~dcu_op17[12] &  dcu_op17[11] &  ~dcu_op17[10];
    wire inst_pcaddu12i = inst_20I &  dcu_op17[13] &  dcu_op17[12] &  dcu_op17[11] &  ~dcu_op17[10];
    
    //2R12I型访存指令
    wire inst_2R12I_mem = ~|dcu_op17[16:15] & (dcu_op17[14:11] == 4'b1010) & ~inst_3R & ~inst_2R12I_normal & ~inst_20I;
    wire inst_ldb   = inst_2R12I_mem & ~dcu_op17[10] & ~dcu_op17[9] & ~dcu_op17[8] & ~dcu_op17[7];
    wire inst_ldw   = inst_2R12I_mem & ~dcu_op17[10] & ~dcu_op17[9] &  dcu_op17[8] & ~dcu_op17[7];
    wire inst_stb   = inst_2R12I_mem & ~dcu_op17[10] &  dcu_op17[9] & ~dcu_op17[8] & ~dcu_op17[7];
    wire inst_stw   = inst_2R12I_mem & ~dcu_op17[10] &  dcu_op17[9] &  dcu_op17[8] & ~dcu_op17[7];
    /*------------------------------------------------------------------------------*/

    /*-------------------- 第二级译码逻辑：生成具体控制信号 --------------------*/
 // 操作类型alutype
    assign dcu_alutype[2] = inst_srlw;
    assign dcu_alutype[1] = inst_ori | inst_andi | inst_or | inst_xor ;
    assign dcu_alutype[0] = inst_addiw | inst_ldb | inst_ldw | inst_stb | inst_stw | inst_addw | inst_sltu | inst_pcaddu12i | inst_lu12iw; 

    // 内部操作码aluop
    assign dcu_aluop[7]   = inst_ldb | inst_ldw | inst_stb | inst_stw | inst_pcaddu12i;
    assign dcu_aluop[6]   = 1'b0;
    assign dcu_aluop[5]   = inst_sltu;
    assign dcu_aluop[4]   = inst_srlw | inst_addw | inst_addiw | inst_or | inst_andi | inst_ori | inst_xor | inst_ldb | inst_ldw | inst_stb | inst_stw | inst_pcaddu12i;
    assign dcu_aluop[3]   = inst_addw | inst_addiw | inst_or | inst_andi | inst_ori | inst_xor | inst_stb | inst_stw | inst_pcaddu12i;
    assign dcu_aluop[2]   = inst_lu12iw | inst_andi | inst_ori | inst_xor | inst_sltu;
    assign dcu_aluop[1]   = inst_srlw | inst_or | inst_xor | inst_sltu | inst_ldw | inst_stw | inst_pcaddu12i;
    assign dcu_aluop[0]   = inst_lu12iw | inst_addiw | inst_ori | inst_sltu | inst_pcaddu12i;
    
    // 写通用寄存器使能信号
    assign dcu_wreg       = 1'b1;
    
    // 移位使能指令
    wire shift = 0;
    //应该不需要移位使能？

    //确定第二个操作数来源的信号（寄存器or立即数）
    assign dcu_immsel = inst_2R12I_normal & inst_2R12I_mem & inst_20I;
    //1为立即数
    
    //确定目的寄存器是rt还是rd的信号
    wire rtsel = (inst_addiw |  inst_ori | inst_lu12iw | inst_ldb | inst_ldw | inst_andi);
    //这个似乎也不需要？

    //对立即数进行符号扩展或者零扩展的信号
    assign dcu_sext = inst_addiw | inst_ldb | inst_ldw | inst_stb | inst_stw; 
    //sext为1时是符号扩展
    
    //加载高半字使能信号
    assign dcu_upper = inst_lu12iw | inst_pcaddu12i;

    // 存储器到寄存器使能信号
    assign dcu_mreg = inst_ldb | inst_ldw;

    // 读通用寄存器堆端口1使能信号
    assign dcu_rreg1 = inst_3R & inst_2R12I_normal & inst_2R12I_mem;
    
    // 读通用寄存器堆读端口2使能信号
    assign dcu_rreg2 = inst_3R;

    //针对pcaddu12i指令的信号
    assign dcu_pcadd = inst_pcaddu12i;



    /*------------------------------------------------------------------------------*/
endmodule
