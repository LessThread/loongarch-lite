`include "defines.v"

module exemem_reg (
    input  wire 				cpu_clk_50M,
    input  wire 				cpu_rst_n,

    // ����ִ�н׶ε���Ϣ
    input  wire [`ALUOP_BUS   ] exe_aluop,
    input  wire [`REG_ADDR_BUS] exe_wa,
    input  wire                 exe_wreg,
    input  wire [`REG_BUS 	  ] exe_wd,
    input  wire [`INST_ADDR_BUS]  exe_debug_wb_pc, // ������ʹ�õ�PCֵ���ϰ����ʱ���ɾ�����ź�
    
    // �͵��ô�׶ε���Ϣ 
    output reg  [`ALUOP_BUS   ] mem_aluop,
    output reg  [`REG_ADDR_BUS] mem_wa,
    output reg                  mem_wreg,
    output reg  [`REG_BUS 	  ] mem_wd,
    output reg  [`INST_ADDR_BUS]  mem_debug_wb_pc  // ������ʹ�õ�PCֵ���ϰ����ʱ���ɾ�����ź�
    );

    always @(posedge cpu_clk_50M) begin
    if (cpu_rst_n == `RST_ENABLE) begin
        mem_aluop              <= `LoongArch32_SLL;
        mem_wa 				   <= `REG_NOP;
        mem_wreg   			   <= `WRITE_DISABLE;
        mem_wd   			   <= `ZERO_WORD;
        mem_debug_wb_pc        <= `PC_INIT;   // �ϰ����ʱ���ɾ�������
    end
    else begin
        mem_aluop              <= exe_aluop;
        mem_wa 				   <= exe_wa;
        mem_wreg 			   <= exe_wreg;
        mem_wd 		    	   <= exe_wd;
        mem_debug_wb_pc        <= exe_debug_wb_pc;   // �ϰ����ʱ���ɾ�������
    end
  end

endmodule