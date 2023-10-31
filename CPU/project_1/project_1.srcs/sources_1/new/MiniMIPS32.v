`include "defines.v"

module MiniMIPS32(
    input  wire                  cpu_clk_50M,
    input  wire                  cpu_rst_n,
    
    // inst_rom
    output wire [`INST_ADDR_BUS] iaddr,
    output wire                  ice,
    input  wire [`INST_BUS]      inst,
    
    output wire [`INST_ADDR_BUS]  debug_wb_pc,       // 供调试使用的PC值，上板测试时务必删除该信号
    output wire                   debug_wb_rf_wen,   // 供调试使用的PC值，上板测试时务必删除该信号
    output wire [`REG_ADDR_BUS  ] debug_wb_rf_wnum,  // 供调试使用的PC值，上板测试时务必删除该信号
    output wire [`WORD_BUS      ] debug_wb_rf_wdata,  // 供调试使用的PC值，上板测试时务必删除该信号
    
    //测试输出
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
	
	//记得删除
	output wire [`WORD_BUS      ] pc,
	output wire [`REG_BUS       ] wb_wd_o,
	output wire [`REG_BUS       ]      arithres,
	output wire [`REG_BUS 	     ] id_src1_o,
	output wire [`REG_BUS      ]    rd1,
	output wire inst_2R12I_normal,
	output wire inst_addiw,
	output wire [16:0] op17,
	output wire [`ALUOP_BUS     ] id_aluop_o
    );

    //wire [`WORD_BUS      ] pc;

    // 连接IF/ID模块与译码阶段ID模块的变量 
    wire [`WORD_BUS      ] id_pc_i;
    
    // 连接译码阶段ID模块与通用寄存器Regfile模块的变量 
//    wire 				   re1;
//    wire [`REG_ADDR_BUS  ] ra1;
//    wire [`REG_BUS       ] rd1;
//    wire 				   re2;
//    wire [`REG_ADDR_BUS  ] ra2;
//    wire [`REG_BUS       ] rd2;
    
    //wire [`ALUOP_BUS     ] id_aluop_o;
    wire [`ALUTYPE_BUS   ] id_alutype_o;
    //wire [`REG_BUS 	     ] id_src1_o;
    wire [`REG_BUS 	     ] id_src2_o;
    wire 				   id_wreg_o;
    wire [`REG_ADDR_BUS  ] id_wa_o;
    wire                   id_mreg_o;  //new
    wire [`REG_BUS      ]  id_din_o;   //new
    wire [`ALUOP_BUS     ] exe_aluop_i;
    wire [`ALUTYPE_BUS   ] exe_alutype_i;
    wire [`REG_BUS 	     ] exe_src1_i;
    wire [`REG_BUS 	     ] exe_src2_i;
    wire 				   exe_wreg_i;
    wire [`REG_ADDR_BUS  ] exe_wa_i;
    wire  				   exe_mreg_i; //new
    wire [`REG_BUS 		]  exe_din_i;  //new

    wire [`REG_BUS 	     ] exe_hi_i;
    wire [`REG_BUS 	     ] exe_lo_i;
    
    wire [`ALUOP_BUS     ] exe_aluop_o;
    wire 				   exe_wreg_o;
    wire [`REG_ADDR_BUS  ] exe_wa_o;
    wire [`REG_BUS 	     ] exe_wd_o;
    wire  				   exe_mreg_o;  //new
    wire [`REG_BUS 		]  exe_din_o;   //new
    wire [`ALUOP_BUS     ] mem_aluop_i;
    wire 				   mem_wreg_i;
    wire [`REG_ADDR_BUS  ] mem_wa_i;
    wire [`REG_BUS 	     ] mem_wd_i;
    wire  				   mem_mreg_i; //new
    wire [`REG_BUS 		]  mem_din_i;  //new

    wire 				   mem_wreg_o;
    wire [`REG_ADDR_BUS  ] mem_wa_o;
    wire [`REG_BUS 	     ] mem_dreg_o;
    wire  				   mem_mreg_o;  //new
    wire [`REG_BUS       ]mem_dm_o;   //new
    wire 				   wb_wreg_i;
    wire [`REG_ADDR_BUS  ] wb_wa_i;
    wire [`REG_BUS       ] wb_dreg_i;
    wire                   wb_mreg_i;  //new
	wire [`REG_BUS       ] wb_dm_i;    //new

    wire 				   wb_wreg_o;
    wire [`REG_ADDR_BUS  ] wb_wa_o;
    //wire [`REG_BUS       ] wb_wd_o;
    
    wire [`INST_ADDR_BUS]  if_debug_wb_pc;       // 上板测试时务必删除该信号
    wire [`INST_ADDR_BUS]  id_debug_wb_pc_i;       // 上板测试时务必删除该信号
    wire [`INST_ADDR_BUS]  id_debug_wb_pc_o;       // 上板测试时务必删除该信号
    wire [`INST_ADDR_BUS]  exe_debug_wb_pc_i;       // 上板测试时务必删除该信号
    wire [`INST_ADDR_BUS]  exe_debug_wb_pc_o;       // 上板测试时务必删除该信号
    wire [`INST_ADDR_BUS]  mem_debug_wb_pc_i;       // 上板测试时务必删除该信号
    wire [`INST_ADDR_BUS]  mem_debug_wb_pc_o;       // 上板测试时务必删除该信号
    wire [`INST_ADDR_BUS]   wb_debug_wb_pc_i;       // 上板测试时务必删除该信号

    if_stage if_stage0(.cpu_clk_50M(cpu_clk_50M), .cpu_rst_n(cpu_rst_n),
        .pc(pc), .ice(ice), .iaddr(iaddr), .debug_wb_pc(if_debug_wb_pc));
    
    ifid_reg ifid_reg0(.cpu_clk_50M(cpu_clk_50M), .cpu_rst_n(cpu_rst_n),
        .if_pc(pc), .if_debug_wb_pc(if_debug_wb_pc), .id_pc(id_pc_i), .id_debug_wb_pc(id_debug_wb_pc_i)
    );

    id_stage id_stage0(.cpu_clk_50M(cpu_clk_50M), .cpu_rst_n(cpu_rst_n),
        .id_pc_i(id_pc_i), 
        .id_inst_i(inst),
        .id_debug_wb_pc(id_debug_wb_pc_i),
        //.rd1(rd1), .rd2(rd2),
        //.rreg1(re1), .rreg2(re2), 	  
        //.ra1(ra1), .ra2(ra2), 
        .id_aluop_o(id_aluop_o), .id_alutype_o(id_alutype_o),
        .id_src1_o(id_src1_o), .id_src2_o(id_src2_o),
        .id_wa_o(id_wa_o), .id_wreg_o(id_wreg_o),
        .id_mreg_o(id_mreg_o),   //new
        .id_din_o(id_din_o),     //new
        .debug_wb_pc(id_debug_wb_pc_o),
        .id_wbwreg_i(wb_wreg_o),
        .id_wbwa_i(wb_wa_o),
        .id_wbwd_i(wb_wd_o),
        
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
	    .regs31(regs31),
	    .rd1(rd1),
	    .inst_2R12I_normal(inst_2R12I_normal),
	    .inst_addiw(inst_addiw),
	    .op17(op17)
    );
    
    //该寄存器被移动至id_stage
//    regfile regfile0(.cpu_clk_50M(cpu_clk_50M), .cpu_rst_n(cpu_rst_n),
//        .we(wb_wreg_o), .wa(wb_wa_o), .wd(wb_wd_o),
//        .re1(re1), .ra1(ra1), .rd1(rd1),
//        .re2(re2), .ra2(ra2), .rd2(rd2)
//    );
    
    idexe_reg idexe_reg0(.cpu_clk_50M(cpu_clk_50M), .cpu_rst_n(cpu_rst_n), 
        .id_alutype(id_alutype_o), .id_aluop(id_aluop_o),
        .id_src1(id_src1_o), .id_src2(id_src2_o),
        .id_wa(id_wa_o), .id_wreg(id_wreg_o),
        .id_debug_wb_pc(id_debug_wb_pc_o),
        .exe_alutype(exe_alutype_i), .exe_aluop(exe_aluop_i),
        .exe_src1(exe_src1_i), .exe_src2(exe_src2_i), 
        .exe_wa(exe_wa_i), .exe_wreg(exe_wreg_i),
        .exe_debug_wb_pc(exe_debug_wb_pc_i)
    );
    
    exe_stage exe_stage0(
        .exe_alutype_i(exe_alutype_i), .exe_aluop_i(exe_aluop_i),
        .exe_src1_i(exe_src1_i), .exe_src2_i(exe_src2_i),
        .exe_wa_i(exe_wa_i), .exe_wreg_i(exe_wreg_i),
        .exe_debug_wb_pc(exe_debug_wb_pc_i),
        .exe_mreg_i(exe_mreg_i), //new
        .exe_din_i(exe_din_i),   //new
        .exe_aluop_o(exe_aluop_o),
        .exe_wa_o(exe_wa_o), .exe_wreg_o(exe_wreg_o), .exe_wd_o(exe_wd_o),
        .exe_mreg_o(exe_mreg_o),  //new
        .exe_din_o(exe_din_o),    //new
        .debug_wb_pc(exe_debug_wb_pc_o),
        
        .arithres(arithres)
    );
        
    exemem_reg exemem_reg0(.cpu_clk_50M(cpu_clk_50M), .cpu_rst_n(cpu_rst_n),
        .exe_aluop(exe_aluop_o),
        .exe_wa(exe_wa_o), .exe_wreg(exe_wreg_o), .exe_wd(exe_wd_o),
        .exe_debug_wb_pc(exe_debug_wb_pc_o),
        .mem_aluop(mem_aluop_i),
        .mem_wa(mem_wa_i), .mem_wreg(mem_wreg_i), .mem_wd(mem_wd_i),
        .mem_debug_wb_pc(mem_debug_wb_pc_i)
    );

    mem_stage mem_stage0(.cpu_clk_50M(cpu_clk_50M),.cpu_rst_n(cpu_rst_n),   //new
        .mem_aluop_i(mem_aluop_i),
        .mem_wa_i(mem_wa_i), .mem_wreg_i(mem_wreg_i), .mem_wd_i(mem_wd_i),
        .mem_debug_wb_pc(mem_debug_wb_pc_i),
        .mem_mreg_i(mem_mreg_i), //new
        .mem_din_i(mem_din_i),   //new
        .mem_wa_o(mem_wa_o), .mem_wreg_o(mem_wreg_o), .mem_dreg_o(mem_dreg_o),
        .debug_wb_pc(mem_debug_wb_pc_o),
        .mem_mreg_o(mem_mreg_o), //new
        .mem_dm_o(mem_dm_o)      //new
    );
    	
    memwb_reg memwb_reg0(.cpu_clk_50M(cpu_clk_50M), .cpu_rst_n(cpu_rst_n),
        .mem_wa(mem_wa_o), .mem_wreg(mem_wreg_o), .mem_dreg(mem_dreg_o),
        .mem_debug_wb_pc(mem_debug_wb_pc_o),
        .wb_wa(wb_wa_i), .wb_wreg(wb_wreg_i), .wb_dreg(wb_dreg_i),
        .wb_debug_wb_pc(wb_debug_wb_pc_i)
    );

    wb_stage wb_stage0(
        .wb_wa_i(wb_wa_i), .wb_wreg_i(wb_wreg_i), .wb_dreg_i(wb_dreg_i), 
        .wb_debug_wb_pc(wb_debug_wb_pc_i),
        .wb_mreg_i(wb_mreg_i),  //new
	    .wb_dm_i(wb_dm_i),      //new
        .wb_wa_o(wb_wa_o), .wb_wreg_o(wb_wreg_o), .wb_wd_o(wb_wd_o),
        .debug_wb_pc(debug_wb_pc),       
        .debug_wb_rf_wen(debug_wb_rf_wen),   
        .debug_wb_rf_wnum(debug_wb_rf_wnum),  
        .debug_wb_rf_wdata(debug_wb_rf_wdata)  
    );

endmodule
