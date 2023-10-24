`include "defines.v"

module mem_stage (

    // 从执行阶段获得的信息
    input  wire [`ALUOP_BUS     ]       mem_aluop_i,
    input  wire [`REG_ADDR_BUS  ]       mem_wa_i,
    input  wire                         mem_wreg_i,
    input  wire [`REG_BUS       ]       mem_wd_i,
    input  wire [`INST_ADDR_BUS]        mem_debug_wb_pc,  // 供调试使用的PC值，上板测试时务必删除该信号
    
    input  wire  					    mem_mreg_i, //new
    input  wire [`REG_BUS 		]       mem_din_i,  //new
    
    // 送至写回阶段的信息
    output wire [`REG_ADDR_BUS  ]       mem_wa_o,
    output wire                         mem_wreg_o,
    output wire [`REG_BUS       ]       mem_dreg_o,
    
    output wire [`INST_ADDR_BUS] 	    debug_wb_pc,  // 供调试使用的PC值，上板测试时务必删除该信号
    
    output wire  					    mem_mreg_o,  //new
    output reg [`REG_BUS       ]       mem_dm_o   //new
    
    );
    wire [3 : 0]           dre;
    wire [`REG_BUS       ] daddr;
    wire                   dce;
    wire [3 : 0]           we;
    wire [`REG_BUS       ] dm;
    // 如果当前不是访存指令，则只需要把从执行阶段获得的信息直接输出
    assign mem_wa_o     = mem_wa_i;
    assign mem_wreg_o   = mem_wreg_i;
    assign mem_dreg_o   = mem_wd_i;
    
    MCU MCU0(.mcu_aluop_i(mem_aluop_i),
    .mcu_wd_i(mem_wd_i),
    .mcu_dre(dre),
    .mcu_dce(dce),
    .mcu_we(we)
    );
    
    always @(*) begin
        case(dre)
            4'b1000 : mem_dm_o = {28'b0, dm[31:24]};
            4'b0100 : mem_dm_o = {28'b0, dm[23:16]};
            4'b0010 : mem_dm_o = {28'b0, dm[15:8]};
            4'b0001 : mem_dm_o = {28'b0, dm[7:0]}; 
            default : mem_dm_o = 32'b0;
        endcase
    end
    
    assign debug_wb_pc = mem_debug_wb_pc;    // 上板测试时务必删除该语句 

endmodule