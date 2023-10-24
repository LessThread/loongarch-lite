`include "defines.v"

module exe_stage (

    // 从译码阶段获得的信息
    input  wire [`ALUTYPE_BUS	] 	exe_alutype_i,
    input  wire [`ALUOP_BUS	    ] 	exe_aluop_i,
    input  wire [`REG_BUS 		] 	exe_src1_i,
    input  wire [`REG_BUS 		] 	exe_src2_i,
    input  wire [`REG_ADDR_BUS 	] 	exe_wa_i,
    input  wire 					exe_wreg_i,
    input  wire [`INST_ADDR_BUS]    exe_debug_wb_pc,  // 供调试使用的PC值，上板测试时务必删除该信号
    
    input  wire  					exe_mreg_i, //new
    input  wire [`REG_BUS 		]   exe_din_i,  //new
    
    // 送至执行阶段的信息
    output wire [`ALUOP_BUS	    ] 	exe_aluop_o,
    output wire [`REG_ADDR_BUS 	] 	exe_wa_o,
    output wire 					exe_wreg_o,
    output reg  [`REG_BUS 		] 	exe_wd_o,
    
    output wire  					exe_mreg_o,  //new
    output wire [`REG_BUS 		]   exe_din_o,   //new
    
    output wire [`INST_ADDR_BUS] 	debug_wb_pc  // 供调试使用的PC值，上板测试时务必删除该信号
    );
    //add_w编写完成
    //or编写完成
    //xor编写完成
    //srl_w编写完成
    //sltu编写完成
    //ori编写完成
    //addi_w编写完成
    //andi编写完成
    //ld_w编写完成（存储器部分除外）
    //st_w编写完成（存储器部分除外）
    //ld_b编写完成（存储器部分除外）
    //st_b编写完成（存储器部分除外）
    //lu12i_w编写完成（该指令的alu_type应标记为arith）
    //pcaddu12i编写完成（该指令的alu_type应标记为arith且需要将PC放入src1中）

    // 直接传到下一阶段
    assign exe_aluop_o = exe_aluop_i;
    
    wire [`REG_BUS       ]      logicres;       // 保存逻辑运算的结果
    wire [`REG_BUS       ]      arithres;       // 保存数值运算的结果
    wire [`REG_BUS       ]      shiftres;       // 保存位移运算的结果
    // 根据内部操作码aluop进行逻辑运算
    //assign logicres = (exe_aluop_i == `MINIMIPS32_AND )  ? (exe_src1_i & exe_src2_i) : `ZERO_WORD;
    ALU ALU0(.alu_aluop_i(exe_aluop_i),
    .alu_src1_i(exe_src1_i),
    .alu_src2_i(exe_src2_i),
    
    .alu_logicres(logicres),
    .alu_arithres(arithres),
    .alu_shiftres(shiftres)
    );
    assign exe_wa_o   = exe_wa_i;   //3Rtype算数/逻辑运算指令，写地址直接向后传
    assign exe_wreg_o = exe_wreg_i; //3Rtype算数/逻辑运算指令，写使能直接向后传
    
    assign exe_mreg_o = exe_mreg_i; //LD_W指令内存使能直接后传
    assign exe_din_o  = exe_din_i;  //ST_W指令写入数据直接后传
    
    // 根据操作类型alutype确定执行阶段最终的运算结果（既可能是待写入目的寄存器的数据，也可能是访问数据存储器的地址）
    
    always @(*) begin
        case (exe_alutype_i)
            `LOGIC : exe_wd_o = logicres;
            `ARITH : exe_wd_o = arithres;
            `SHIFT : exe_wd_o = shiftres;
        endcase
    end
    
    assign debug_wb_pc = exe_debug_wb_pc;    // 上板测试时务必删除该语句 

endmodule