`include "defines.v"

module id_stage(
    //添加传入寄存器的时钟和复位信号
    input  wire 						cpu_clk_50M,
	input  wire 						cpu_rst_n,
    
    // 从取指阶段获得的PC值
    input  wire [`INST_ADDR_BUS]    id_pc_i,
    input  wire [`INST_ADDR_BUS]    id_debug_wb_pc,  // 供调试使用的PC值，上板测试时务必删除该信号

    // 从指令存储器读出的指令字
    input  wire [`INST_BUS     ]    id_inst_i,
    
    //删除了input rd1和rd2
    //添加了由wb阶段传到寄存器的信号
    input  wire                     id_wbwreg_i,
    input  wire [`REG_ADDR_BUS ]    id_wbwa_i,
    input  wire [`REG_BUS      ]    id_wbwd_i,
    
    // 送至执行阶段的译码信息
    output wire [`ALUTYPE_BUS  ]    id_alutype_o,
    output wire [`ALUOP_BUS    ]    id_aluop_o,
    output wire [`REG_ADDR_BUS ]    id_wa_o,
    output wire                     id_wreg_o,

    // 送至执行阶段的源操作数1、源操作数2
    output wire [`REG_BUS      ]    id_src1_o,
    output wire [`REG_BUS      ]    id_src2_o,
    output wire                     id_mreg_o,   //new
    output wire [`REG_BUS      ]    id_din_o,    //new
    
    //删除了output rreg1 ra1 rrg2 ra2

    output       [`INST_ADDR_BUS] 	debug_wb_pc  // 供调试使用的PC值，上板测试时务必删除该信号
    );
    
    // 根据小端模式组织指令字
    wire [`INST_BUS] id_inst = {id_inst_i[7:0], id_inst_i[15:8], id_inst_i[23:16], id_inst_i[31:24]};
    
    // 送至读通用寄存器堆端口的使能和地址
    wire                     rreg1;
    wire [`REG_ADDR_BUS ]    ra1;
    wire                     rreg2;
    wire [`REG_ADDR_BUS ]    ra2;
    // 提取指令字中各个字段的信息
    wire [5 :0] op17  = id_inst[31:15];
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
    .dcu_pcadd(pcadd)
    );

    // 从通用寄存器堆读出的数据 
    wire [`REG_BUS      ]    rd1;
    wire [`REG_BUS      ]    rd2;
    
    regfile regfile0(.cpu_clk_50M(cpu_clk_50M), .cpu_rst_n(cpu_rst_n),
        .we(id_wbwreg_i), .wa(id_wbwa_i), .wd(id_wbwd_i),
        .re1(rreg1), .ra1(ra1), .rd1(rd1),
        .re2(rreg2), .ra2(ra2), .rd2(rd2)
    );
    
    // 读通用寄存器堆端口1的地址为rj字段，读端口2的地址为rk字段
    assign ra1   = rj;
    assign ra2   = rk;
                                            
    // 获得待写入目的寄存器的地址（rt或rd）
    assign id_wa_o      = rd;

    // 获得源操作数1。如果shift信号有效，则源操作数1为移位位数；否则为从读通用寄存器堆端口1获得的数据
    //LoongArch32应该没有移位数？
    //针对pcaddu12i指令
    assign id_src1_o = (pcadd == `TRUE_V) ? id_pc_i : rd1;
    
    //获得位移后立即数，如果upper有效则选择左移，如果upper无效且sext有效则符号拓展，如果upper无效且sext无效则零拓展
    wire [31:0] imm32;
    assign imm32 = (upper == `TRUE_V) ? ({imm20,12'b0}) : 
                   (sext  == `TRUE_V) ? ({ {20{imm12[11]}} , imm12}) : ({20'b0,imm12});
    
    // 获得源操作数2。如果immsel信号有效，则源操作数2为立即数；否则为从读通用寄存器堆端口2获得的数据
    assign id_src2_o = (immsel == `TRUE_V) ? imm32 : rd2;
    
    //获得写存储器时地址
    assign id_din_o = rd2;
        
    assign debug_wb_pc = id_debug_wb_pc;    // 上板测试时务必删除该语句      

endmodule
