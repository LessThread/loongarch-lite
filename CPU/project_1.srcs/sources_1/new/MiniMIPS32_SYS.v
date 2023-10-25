`include "defines.v"

module MiniMIPS32_SYS(
    input wire sys_clk_200M_p,
    input wire sys_clk_200M_n,
    input wire sys_rst_n
    );

    wire                  cpu_clk_50M;
    wire [`INST_ADDR_BUS] iaddr;
    wire                  ice;
    wire [`INST_BUS     ] inst;
    
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
        .debug_wb_rf_wdata(debug_wb_rf_wdata) // 供调试使用的PC值，上板测试时务必删除该信号
    );

endmodule
