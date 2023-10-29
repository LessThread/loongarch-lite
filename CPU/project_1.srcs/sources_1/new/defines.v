`timescale 1ns / 1ps

/*------------------- ȫ�ֲ��� -------------------*/
`define RST_ENABLE      1'b0                // ��λ�ź���Ч  RST_ENABLE
`define RST_DISABLE     1'b1                // ��λ�ź���Ч
`define ZERO_WORD       32'h00000000        // 32λ����ֵ0
`define ZERO_DWORD      64'b0               // 64λ����ֵ0
`define WRITE_ENABLE    1'b1                // ʹ��д
`define WRITE_DISABLE   1'b0                // ��ֹд
`define READ_ENABLE     1'b1                // ʹ�ܶ�
`define READ_DISABLE    1'b0                // ��ֹ��
`define ALUOP_BUS       7 : 0               // ����׶ε����aluop_o�Ŀ��
`define SHIFT_ENABLE    1'b1                // ��λָ��ʹ�� 
`define ALUTYPE_BUS     2 : 0               // ����׶ε����alutype_o�Ŀ��  
`define TRUE_V          1'b1                // �߼�"��"  
`define FALSE_V         1'b0                // �߼�"��"  
`define CHIP_ENABLE     1'b1                // оƬʹ��  
`define CHIP_DISABLE    1'b0                // оƬ��ֹ  
`define WORD_BUS        31: 0               // 32λ��
`define DOUBLE_REG_BUS  63: 0               // ������ͨ�üĴ����������߿��
`define RT_ENABLE       1'b1                // rtѡ��ʹ��
`define SIGNED_EXT      1'b1                // ������չʹ��
`define IMM_ENABLE      1'b1                // ������ѡ��ʹ��
`define UPPER_ENABLE    1'b1                // ��������λʹ��
`define MREG_ENABLE     1'b1                // д�ؽ׶δ洢�����ѡ���ź�
`define BSEL_BUS        3 : 0               // ���ݴ洢���ֽ�ѡ���źſ��
`define PC_INIT         32'h80000000        // PC��ʼֵ

/*------------------- ָ���ֲ��� -------------------*/
`define INST_ADDR_BUS   31: 0               // ָ��ĵ�ַ���
`define INST_BUS        31: 0               // ָ������ݿ��

// ��������alutype
`define NOP             3'b000
`define ARITH           3'b001
`define LOGIC           3'b010
`define MOVE            3'b011
`define SHIFT           3'b100

// �ڲ�������aluop
`define LoongArch32_LU12I_W         8'h05  //MINIMIPS32_LUI
`define LoongArch32_MFHI            8'h0C
`define LoongArch32_MFLO            8'h0D
`define LoongArch32_SLL             8'h11
`define LoongArch32_SRL_W           8'h12  //new
`define LoongArch32_MULT            8'h14
`define LoongArch32_ADD_W           8'h18  //MINIMIPS32_ADD
`define LoongArch32_ADDI_W          8'h19  //MINIMIPS32_ADDIU
`define LoongArch32_OR              8'h1A  //new
`define LoongArch32_SUBU            8'h1B
`define LoongArch32_ANDI            8'h1C  //MINIMIPS32_AND
`define LoongArch32_ORI             8'h1D
`define LoongArch32_XOR             8'h1E  //new
`define LoongArch32_SLT             8'h26
`define LoongArch32_SLTU            8'h27  //MINIMIPS32_SLTIU
`define LoongArch32_LD_B            8'h90  //MINIMIPS32_LB
`define LoongArch32_LD_W            8'h92  //MINIMIPS32_LW
`define LoongArch32_ST_B            8'h98  //MINIMIPS32_SB
`define LoongArch32_ST_W            8'h9A  //MINIMIPS32_SW
`define LoongArch32_PCADDU12I       8'h9B  //new

/*------------------- ͨ�üĴ����Ѳ��� -------------------*/
`define REG_BUS         31: 0               // �Ĵ������ݿ��
`define REG_ADDR_BUS    4 : 0               // �Ĵ����ĵ�ַ���
`define REG_NUM         32                  // �Ĵ�������32��
`define REG_NOP         5'b00000            // ��żĴ���