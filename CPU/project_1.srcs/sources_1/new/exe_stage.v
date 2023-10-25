`include "defines.v"

module exe_stage (

    // ������׶λ�õ���Ϣ
    input  wire [`ALUTYPE_BUS	] 	exe_alutype_i,
    input  wire [`ALUOP_BUS	    ] 	exe_aluop_i,
    input  wire [`REG_BUS 		] 	exe_src1_i,
    input  wire [`REG_BUS 		] 	exe_src2_i,
    input  wire [`REG_ADDR_BUS 	] 	exe_wa_i,
    input  wire 					exe_wreg_i,
    input  wire [`INST_ADDR_BUS]    exe_debug_wb_pc,  // ������ʹ�õ�PCֵ���ϰ����ʱ���ɾ�����ź�
    
    input  wire  					exe_mreg_i, //new
    input  wire [`REG_BUS 		]   exe_din_i,  //new
    
    // ����ִ�н׶ε���Ϣ
    output wire [`ALUOP_BUS	    ] 	exe_aluop_o,
    output wire [`REG_ADDR_BUS 	] 	exe_wa_o,
    output wire 					exe_wreg_o,
    output reg  [`REG_BUS 		] 	exe_wd_o,
    
    output wire  					exe_mreg_o,  //new
    output wire [`REG_BUS 		]   exe_din_o,   //new
    
    output wire [`INST_ADDR_BUS] 	debug_wb_pc  // ������ʹ�õ�PCֵ���ϰ����ʱ���ɾ�����ź�
    );
    //add_w��д���
    //or��д���
    //xor��д���
    //srl_w��д���
    //sltu��д���
    //ori��д���
    //addi_w��д���
    //andi��д���
    //ld_w��д��ɣ��洢�����ֳ��⣩
    //st_w��д��ɣ��洢�����ֳ��⣩
    //ld_b��д��ɣ��洢�����ֳ��⣩
    //st_b��д��ɣ��洢�����ֳ��⣩
    //lu12i_w��д��ɣ���ָ���alu_typeӦ���Ϊarith��
    //pcaddu12i��д��ɣ���ָ���alu_typeӦ���Ϊarith����Ҫ��PC����src1�У�

    // ֱ�Ӵ�����һ�׶�
    assign exe_aluop_o = exe_aluop_i;
    
    wire [`REG_BUS       ]      logicres;       // �����߼�����Ľ��
    wire [`REG_BUS       ]      arithres;       // ������ֵ����Ľ��
    wire [`REG_BUS       ]      shiftres;       // ����λ������Ľ��
    // �����ڲ�������aluop�����߼�����
    //assign logicres = (exe_aluop_i == `MINIMIPS32_AND )  ? (exe_src1_i & exe_src2_i) : `ZERO_WORD;
    ALU ALU0(.alu_aluop_i(exe_aluop_i),
    .alu_src1_i(exe_src1_i),
    .alu_src2_i(exe_src2_i),
    
    .alu_logicres(logicres),
    .alu_arithres(arithres),
    .alu_shiftres(shiftres)
    );
    assign exe_wa_o   = exe_wa_i;   //3Rtype����/�߼�����ָ�д��ֱַ�����
    assign exe_wreg_o = exe_wreg_i; //3Rtype����/�߼�����ָ�дʹ��ֱ�����
    
    assign exe_mreg_o = exe_mreg_i; //LD_Wָ���ڴ�ʹ��ֱ�Ӻ�
    assign exe_din_o  = exe_din_i;  //ST_Wָ��д������ֱ�Ӻ�
    
    // ���ݲ�������alutypeȷ��ִ�н׶����յ����������ȿ����Ǵ�д��Ŀ�ļĴ��������ݣ�Ҳ�����Ƿ������ݴ洢���ĵ�ַ��
    
    always @(*) begin
        case (exe_alutype_i)
            `LOGIC : exe_wd_o = logicres;
            `ARITH : exe_wd_o = arithres;
            `SHIFT : exe_wd_o = shiftres;
        endcase
    end
    
    assign debug_wb_pc = exe_debug_wb_pc;    // �ϰ����ʱ���ɾ������� 

endmodule