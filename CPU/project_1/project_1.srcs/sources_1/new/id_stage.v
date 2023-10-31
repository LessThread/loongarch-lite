`include "defines.v"

module id_stage(
    //���Ӵ���Ĵ�����ʱ�Ӻ͸�λ�ź�
    input  wire 						cpu_clk_50M,
	input  wire 						cpu_rst_n,
    
    // ��ȡָ�׶λ�õ�PCֵ
    input  wire [`INST_ADDR_BUS]    id_pc_i,
    input  wire [`INST_ADDR_BUS]    id_debug_wb_pc,  // ������ʹ�õ�PCֵ���ϰ����ʱ���ɾ�����ź�

    // ��ָ��洢��������ָ����
    input  wire [`INST_BUS     ]    id_inst_i,
    
    //ɾ����input rd1��rd2
    //��������wb�׶δ����Ĵ������ź�
    input  wire                     id_wbwreg_i,
    input  wire [`REG_ADDR_BUS ]    id_wbwa_i,
    input  wire [`REG_BUS      ]    id_wbwd_i,
    
    // ����ִ�н׶ε�������Ϣ
    output wire [`ALUTYPE_BUS  ]    id_alutype_o,
    output wire [`ALUOP_BUS    ]    id_aluop_o,
    output wire [`REG_ADDR_BUS ]    id_wa_o,
    output wire                     id_wreg_o,

    // ����ִ�н׶ε�Դ������1��Դ������2
    output wire [`REG_BUS      ]    id_src1_o,
    output wire [`REG_BUS      ]    id_src2_o,
    output wire                     id_mreg_o,   //new
    output wire [`REG_BUS      ]    id_din_o,    //new
    
    //ɾ����output rreg1 ra1 rrg2 ra2
    //�������
    output wire  [`REG_BUS] 	regs0,
	output wire  [`REG_BUS] 	regs1,
	output wire  [`REG_BUS] 	regs2,
	output wire  [`REG_BUS] 	regs3,
	output wire  [`REG_BUS] 	regs4,
	output wire  [`REG_BUS] 	regs5,
	output wire  [`REG_BUS] 	regs6,
	output wire  [`REG_BUS] 	regs7,
	output wire  [`REG_BUS] 	regs8,
	output wire  [`REG_BUS] 	regs9,
	output wire  [`REG_BUS] 	regs10,
	output wire  [`REG_BUS] 	regs11,
	output wire  [`REG_BUS] 	regs12,
	output wire  [`REG_BUS] 	regs13,
	output wire  [`REG_BUS] 	regs14,
	output wire  [`REG_BUS] 	regs15,
	output wire  [`REG_BUS] 	regs16,
	output wire  [`REG_BUS] 	regs17,
	output wire  [`REG_BUS] 	regs18,
	output wire  [`REG_BUS] 	regs19,
	output wire  [`REG_BUS] 	regs20,
	output wire  [`REG_BUS] 	regs21,
	output wire  [`REG_BUS] 	regs22,
	output wire  [`REG_BUS] 	regs23,
	output wire  [`REG_BUS] 	regs24,
	output wire  [`REG_BUS] 	regs25,
	output wire  [`REG_BUS] 	regs26,
	output wire  [`REG_BUS] 	regs27,
	output wire  [`REG_BUS] 	regs28,
	output wire  [`REG_BUS] 	regs29,
	output wire  [`REG_BUS] 	regs30,
	output wire  [`REG_BUS] 	regs31,
	output wire [`REG_BUS      ]    rd1,
	output wire inst_2R12I_normal,
	output wire inst_addiw,
	output wire [16:0] op17,

    output       [`INST_ADDR_BUS] 	debug_wb_pc  // ������ʹ�õ�PCֵ���ϰ����ʱ���ɾ�����ź�
    );
    
    // ����С��ģʽ��ָ֯����
    wire [`INST_BUS] id_inst = {id_inst_i[7:0], id_inst_i[15:8], id_inst_i[23:16], id_inst_i[31:24]};
    
    // ������ͨ�üĴ����Ѷ˿ڵ�ʹ�ܺ͵�ַ
    wire                     rreg1;
    wire [`REG_ADDR_BUS ]    ra1;
    wire                     rreg2;
    wire [`REG_ADDR_BUS ]    ra2;
    // ��ȡָ�����и����ֶε���Ϣ
    assign  op17  = id_inst[31:15];
    wire [4 :0] rd    = id_inst[4 : 0];
    wire [4 :0] rj    = id_inst[9 : 5];
    wire [4 :0] rk    = id_inst[14:10];
    wire [11:0] imm12 = id_inst[21:10];
    wire [15:0] imm16 = id_inst[25:10];
    wire [19:0] imm20 = id_inst[24: 5];

    wire immsel;
    wire sext;
    wire upper;
    wire pcadd;

    DCU DCU0(.dcu_op17(op17),
    
    .dcu_wreg(id_wreg_o),
    .dcu_alutype(id_alutype_o),
    .dcu_aluop(id_aluop_o),
    .dcu_rreg1(rreg1),
    .dcu_rreg2(rreg2),
    .dcu_mreg(id_mreg_o),
    .dcu_immsel(immsel),
    .dcu_sext(sext),
    .dcu_upper(upper),
    .dcu_pcadd(pcadd),
    .inst_2R12I_normal(inst_2R12I_normal),
    .inst_addiw(inst_addiw)
    );

    // ��ͨ�üĴ����Ѷ��������� 
    //wire [`REG_BUS      ]    rd1;
    wire [`REG_BUS      ]    rd2;
    
    regfile regfile0(.cpu_clk_50M(cpu_clk_50M), .cpu_rst_n(cpu_rst_n),
        .we(id_wbwreg_i), .wa(id_wbwa_i), .wd(id_wbwd_i),
        .re1(rreg1), .ra1(ra1), .rd1(rd1),
        .re2(rreg2), .ra2(ra2), .rd2(rd2),
        .regs0(regs0),
	    .regs1(regs1),
	    .regs2(regs2),
        .regs3(regs3),
	    .regs4(regs4),
	    .regs5(regs5),
	    .regs6(regs6),
	    .regs7(regs7),
	    .regs8(regs8),
	    .regs9(regs9),
	    .regs10(regs10),
	    .regs11(regs11),
	    .regs12(regs12),
	    .regs13(regs13),
	    .regs14(regs14),
	    .regs15(regs15),
	    .regs16(regs16),
	    .regs17(regs17),
	    .regs18(regs18),
	    .regs19(regs19),
	    .regs20(regs20),
	    .regs21(regs21),
	    .regs22(regs22),
	    .regs23(regs23),
	    .regs24(regs24),
	    .regs25(regs25),
	    .regs26(regs26),
	    .regs27(regs27),
	    .regs28(regs28),
	    .regs29(regs29),
	    .regs30(regs30),
	    .regs31(regs31)
    );
    
    // ��ͨ�üĴ����Ѷ˿�1�ĵ�ַΪrj�ֶΣ����˿�2�ĵ�ַΪrk�ֶ�
    assign ra1   = rj;
    assign ra2   = rk;
                                            
    // ��ô�д��Ŀ�ļĴ����ĵ�ַ��rt��rd��
    assign id_wa_o      = rd;

    // ���Դ������1�����shift�ź���Ч����Դ������1Ϊ��λλ��������Ϊ�Ӷ�ͨ�üĴ����Ѷ˿�1��õ�����
    //LoongArch32Ӧ��û����λ����
    //���pcaddu12iָ��
    assign id_src1_o = (pcadd == `TRUE_V) ? id_pc_i : rd1;
    
    //���λ�ƺ������������upper��Ч��ѡ�����ƣ����upper��Ч��sext��Ч�������չ�����upper��Ч��sext��Ч������չ
    wire [31:0] imm32;
    assign imm32 = (upper == `TRUE_V) ? ({imm20,12'b0}) : 
                   (sext  == `TRUE_V) ? ({ {20{imm12[11]}} , imm12}) : ({20'b0,imm12});
    
    // ���Դ������2�����immsel�ź���Ч����Դ������2Ϊ������������Ϊ�Ӷ�ͨ�üĴ����Ѷ˿�2��õ�����
    assign id_src2_o = (immsel == `TRUE_V) ? imm32 : rd2;
    
    //���д�洢��ʱ��ַ
    assign id_din_o = rd2;
        
    assign debug_wb_pc = id_debug_wb_pc;    // �ϰ����ʱ���ɾ�������      

endmodule