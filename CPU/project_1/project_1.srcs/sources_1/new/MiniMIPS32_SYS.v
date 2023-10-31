`include "defines.v"

module MiniMIPS32_SYS(
    input wire sys_clk_200M_p,
    input wire sys_clk_200M_n,
    input wire sys_rst_n,
    
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
	output wire [`WORD_BUS      ] pc,
	output wire [`INST_BUS     ] inst,
	output wire [`REG_BUS       ] wb_wd_o,
	output wire [`REG_BUS       ]      arithres,
	output wire [`REG_BUS 	     ] id_src1_o,
	output wire [`REG_BUS      ]    rd1,
	output wire inst_2R12I_normal,
	output wire inst_addiw,
	output wire [16:0] op17,
	output wire [`ALUOP_BUS     ] id_aluop_o
    );

    wire                  cpu_clk_50M;
    wire [`INST_ADDR_BUS] iaddr;
    wire                  ice;
    //wire [`INST_BUS     ] inst;
    
    wire [`INST_ADDR_BUS]  debug_wb_pc;       // 供调试使用的PC值，上板测试时务必删除该信号
    wire                   debug_wb_rf_wen;   // 供调试使用的PC值，上板测试时务必删除该信号
    wire [`REG_ADDR_BUS  ] debug_wb_rf_wnum;  // 供调试使用的PC值，上板测试时务必删除该信号
    wire [`WORD_BUS      ] debug_wb_rf_wdata;  // 供调试使用的PC值，上板测试时务必删除该信号

    clkdiv clocking
   (
    // Clock out ports
    .cpu_clk(cpu_clk_50M),     // output cpu_clk
   // Clock in ports
    .clk_in1_p(sys_clk_200M_p),    // input clk_in1_p
    .clk_in1_n(sys_clk_200M_n)     // input clk_in1_n
    );    
    
    inst_rom inst_rom0 (
      .clka(cpu_clk_50M),    // input wire clka
      .ena(ice),      // input wire ena
      .addra(iaddr[12:2]),  // input wire [10 : 0] addra
      .douta(inst)  // output wire [31 : 0] douta
    );

    MiniMIPS32 minimips32 (
        .cpu_clk_50M(cpu_clk_50M),
        .cpu_rst_n(sys_rst_n),
        .iaddr(iaddr),
        .ice(ice),
        .inst(inst),
        .debug_wb_pc(debug_wb_pc),            // 供调试使用的PC值，上板测试时务必删除该信号
        .debug_wb_rf_wen(debug_wb_rf_wen),    // 供调试使用的PC值，上板测试时务必删除该信号
        .debug_wb_rf_wnum(debug_wb_rf_wnum),  // 供调试使用的PC值，上板测试时务必删除该信号
        .debug_wb_rf_wdata(debug_wb_rf_wdata), // 供调试使用的PC值，上板测试时务必删除该信号
        
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
	    .pc(pc),
	    .wb_wd_o(wb_wd_o),
	    .arithres(arithres),
	    .id_src1_o(id_src1_o),
	    .rd1(rd1),
	    .inst_2R12I_normal(inst_2R12I_normal),
	    .inst_addiw(inst_addiw),
	    .op17(op17),
	    .id_aluop_o(id_aluop_o)
    );

endmodule
