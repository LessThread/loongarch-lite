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
    /*-------------------- ��һ�������߼���ȷ����ǰ��Ҫ�����ָ�� --------------------*/
    // 3R��ָ��
    wire inst_3R = ~|dcu_op17[16:6];//���ʵ�ֵ�3R��ָ��op�ֶθ�11λ��Ϊ0��������ȡ 
    wire inst_addw = inst_3R &  dcu_op17[5] & ~dcu_op17[4] & ~dcu_op17[3] & ~dcu_op17[2] & ~dcu_op17[1] & ~dcu_op17[0];
    wire inst_sltu = inst_3R &  dcu_op17[5] & ~dcu_op17[4] & ~dcu_op17[3] &  dcu_op17[2] & ~dcu_op17[1] &  dcu_op17[0];
    wire inst_or   = inst_3R &  dcu_op17[5] & ~dcu_op17[4] &  dcu_op17[3] & ~dcu_op17[2] &  dcu_op17[1] & ~dcu_op17[0];
    wire inst_xor  = inst_3R &  dcu_op17[5] & ~dcu_op17[4] &  dcu_op17[3] & ~dcu_op17[2] &  dcu_op17[1] &  dcu_op17[0];
    wire inst_srlw = inst_3R &  dcu_op17[5] & ~dcu_op17[4] &  dcu_op17[3] &  dcu_op17[2] &  dcu_op17[1] &  dcu_op17[0];
    
    // 2R12I��ָ��
    wire inst_2R12I_normal = ~|dcu_op17[16:11] & ~inst_3R;//���2R12i��ָ���в�����ʵ��ָ��op�ֶθ�6λΪ0���м�
    wire inst_addiw = inst_2R12I_normal &  dcu_op17[10] & ~dcu_op17[9] &  dcu_op17[8] & ~dcu_op17[7];
    wire inst_andi  = inst_2R12I_normal &  dcu_op17[10] &  dcu_op17[9] & ~dcu_op17[8] &  dcu_op17[7];
    wire inst_ori   = inst_2R12I_normal &  dcu_op17[10] &  dcu_op17[9] &  dcu_op17[8] & ~dcu_op17[7];

    //ָ��lu12i.w��pacddu12i
    wire inst_20I = ~|dcu_op17[16:14] & ~inst_3R & ~inst_2R12I_normal;
    wire inst_lu12iw    = inst_20I &  dcu_op17[13] & ~dcu_op17[12] &  dcu_op17[11] &  ~dcu_op17[10];
    wire inst_pcaddu12i = inst_20I &  dcu_op17[13] &  dcu_op17[12] &  dcu_op17[11] &  ~dcu_op17[10];
    
    //2R12I�ͷô�ָ��
    wire inst_2R12I_mem = ~|dcu_op17[16:15] & (dcu_op17[14:11] == 4'b1010) & ~inst_3R & ~inst_2R12I_normal & ~inst_20I;
    wire inst_ldb   = inst_2R12I_mem & ~dcu_op17[10] & ~dcu_op17[9] & ~dcu_op17[8] & ~dcu_op17[7];
    wire inst_ldw   = inst_2R12I_mem & ~dcu_op17[10] & ~dcu_op17[9] &  dcu_op17[8] & ~dcu_op17[7];
    wire inst_stb   = inst_2R12I_mem & ~dcu_op17[10] &  dcu_op17[9] & ~dcu_op17[8] & ~dcu_op17[7];
    wire inst_stw   = inst_2R12I_mem & ~dcu_op17[10] &  dcu_op17[9] &  dcu_op17[8] & ~dcu_op17[7];
    /*------------------------------------------------------------------------------*/

    /*-------------------- �ڶ��������߼������ɾ�������ź� --------------------*/
 // ��������alutype
    assign dcu_alutype[2] = inst_srlw;
    assign dcu_alutype[1] = inst_ori | inst_andi | inst_or | inst_xor ;
    assign dcu_alutype[0] = inst_addiw | inst_ldb | inst_ldw | inst_stb | inst_stw | inst_addw | inst_sltu | inst_pcaddu12i | inst_lu12iw; 

    // �ڲ�������aluop
    assign dcu_aluop[7]   = inst_ldb | inst_ldw | inst_stb | inst_stw | inst_pcaddu12i;
    assign dcu_aluop[6]   = 1'b0;
    assign dcu_aluop[5]   = inst_sltu;
    assign dcu_aluop[4]   = inst_srlw | inst_addw | inst_addiw | inst_or | inst_andi | inst_ori | inst_xor | inst_ldb | inst_ldw | inst_stb | inst_stw | inst_pcaddu12i;
    assign dcu_aluop[3]   = inst_addw | inst_addiw | inst_or | inst_andi | inst_ori | inst_xor | inst_stb | inst_stw | inst_pcaddu12i;
    assign dcu_aluop[2]   = inst_lu12iw | inst_andi | inst_ori | inst_xor | inst_sltu;
    assign dcu_aluop[1]   = inst_srlw | inst_or | inst_xor | inst_sltu | inst_ldw | inst_stw | inst_pcaddu12i;
    assign dcu_aluop[0]   = inst_lu12iw | inst_addiw | inst_ori | inst_sltu | inst_pcaddu12i;
    
    // дͨ�üĴ���ʹ���ź�
    assign dcu_wreg       = 1'b1;
    
    // ��λʹ��ָ��
    wire shift = 0;
    //Ӧ�ò���Ҫ��λʹ�ܣ�

    //ȷ���ڶ�����������Դ���źţ��Ĵ���or��������
    assign dcu_immsel = inst_2R12I_normal & inst_2R12I_mem & inst_20I;
    //1Ϊ������
    
    //ȷ��Ŀ�ļĴ�����rt����rd���ź�
    wire rtsel = (inst_addiw |  inst_ori | inst_lu12iw | inst_ldb | inst_ldw | inst_andi);
    //����ƺ�Ҳ����Ҫ��

    //�����������з�����չ��������չ���ź�
    assign dcu_sext = inst_addiw | inst_ldb | inst_ldw | inst_stb | inst_stw; 
    //sextΪ1ʱ�Ƿ�����չ
    
    //���ظ߰���ʹ���ź�
    assign dcu_upper = inst_lu12iw | inst_pcaddu12i;

    // �洢�����Ĵ���ʹ���ź�
    assign dcu_mreg = inst_ldb | inst_ldw;

    // ��ͨ�üĴ����Ѷ˿�1ʹ���ź�
    assign dcu_rreg1 = inst_3R & inst_2R12I_normal & inst_2R12I_mem;
    
    // ��ͨ�üĴ����Ѷ��˿�2ʹ���ź�
    assign dcu_rreg2 = inst_3R;

    //���pcaddu12iָ����ź�
    assign dcu_pcadd = inst_pcaddu12i;



    /*------------------------------------------------------------------------------*/
endmodule
