`timescale 1ps / 1ps

module MiniMIPS32_SYS_tb();

    // Inputs
	reg sys_clk_200M_p;
	reg sys_clk_200M_n;
	reg sys_rst_n;
	
	wire [`INST_ADDR_BUS]  debug_wb_pc;       // 供调试使用的PC值，上板测试时务必删除该信号
    wire                   debug_wb_rf_wen;   // 供调试使用的PC值，上板测试时务必删除该信号
    wire [`REG_ADDR_BUS  ] debug_wb_rf_wnum;  // 供调试使用的PC值，上板测试时务必删除该信号
    wire [`WORD_BUS      ] debug_wb_rf_wdata;  // 供调试使用的PC值，上板测试时务必删除该信号
    
    wire soc_clk;
    
    wire  [`REG_BUS] 	regs0;
	wire  [`REG_BUS] 	regs1;
	wire  [`REG_BUS] 	regs2;
	wire  [`REG_BUS] 	regs3;
	wire  [`REG_BUS] 	regs4;
	wire  [`REG_BUS] 	regs5;
	wire  [`REG_BUS] 	regs6;
	wire  [`REG_BUS] 	regs7;
	wire  [`REG_BUS] 	regs8;
	wire  [`REG_BUS] 	regs9;
	wire  [`REG_BUS] 	regs10;
	wire  [`REG_BUS] 	regs11;
	wire  [`REG_BUS] 	regs12;
	wire  [`REG_BUS] 	regs13;
	wire  [`REG_BUS] 	regs14;
	wire  [`REG_BUS] 	regs15;
	wire  [`REG_BUS] 	regs16;
	wire  [`REG_BUS] 	regs17;
	wire  [`REG_BUS] 	regs18;
	wire  [`REG_BUS] 	regs19;
	wire  [`REG_BUS] 	regs20;
	wire  [`REG_BUS] 	regs21;
	wire  [`REG_BUS] 	regs22;
	wire  [`REG_BUS] 	regs23;
	wire  [`REG_BUS] 	regs24;
	wire  [`REG_BUS] 	regs25;
	wire  [`REG_BUS] 	regs26;
	wire  [`REG_BUS] 	regs27;
	wire  [`REG_BUS] 	regs28;
	wire  [`REG_BUS] 	regs29;
	wire  [`REG_BUS] 	regs30;
	wire  [`REG_BUS] 	regs31;
	wire [`WORD_BUS      ] pc;
	wire [`INST_BUS     ] inst;
	wire [`REG_BUS       ] wb_wd_o;
	wire [`REG_BUS       ]      arithres;
	wire [`REG_BUS 	     ] id_src1_o;
	wire [`REG_BUS      ]    rd1;
	wire inst_2R12I_normal;
	wire inst_addiw;
	wire [16:0] op17;
	wire [`ALUOP_BUS     ] id_aluop_o;
	
	MiniMIPS32_SYS SoC (
		.sys_clk_200M_p(sys_clk_200M_p),
		.sys_clk_200M_n(sys_clk_200M_n),
		.sys_rst_n(sys_rst_n),
		
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
	    .inst(inst),
	    .wb_wd_o(wb_wd_o),
	    .arithres(arithres),
	    .id_src1_o(id_src1_o),
	    .rd1(rd1),
	    .inst_2R12I_normal(inst_2R12I_normal),
	    .inst_addiw(inst_addiw),
	    .op17(op17),
	    .id_aluop_o(id_aluop_o)
	);
	
	initial begin
		// Initialize Inputs
		sys_clk_200M_p = 1'b0;
		sys_clk_200M_n = 1'b1;
		sys_rst_n = 0;
		
		#200_000;
		sys_rst_n = 1'b1;
		
		#2_000_000 $stop;
	end
	
	always #2500 sys_clk_200M_p = ~sys_clk_200M_p;     // 每隔2.5ns，sys_clk_200M_p信号翻转一次，所以一个周期是5ns，对应200MHz
	always #2500 sys_clk_200M_n = ~sys_clk_200M_n;     // 每隔2.5ns，sys_clk_200M_n信号翻转一次，所以一个周期是5ns，对应200MHz
	
	// 以下程序仅供调试使用
	assign soc_clk           = SoC.cpu_clk_50M;
	
	assign debug_wb_pc        = SoC.debug_wb_pc;       // 供调试使用的PC值，上板测试时务必删除该信号
	assign debug_wb_rf_wen    = SoC.debug_wb_rf_wen;   // 供调试使用的PC值，上板测试时务必删除该信号
	assign debug_wb_rf_wnum   = SoC.debug_wb_rf_wnum;  // 供调试使用的PC值，上板测试时务必删除该信号
	assign debug_wb_rf_wdata  = SoC.debug_wb_rf_wdata; // 供调试使用的PC值，上板测试时务必删除该信号
	
	always @(posedge soc_clk) begin
	   if(debug_wb_rf_wen && debug_wb_rf_wnum!=5'd0) begin
	       $display("--------------------------------------------------------------");
           $display("[%t]ns",$time/1000);
           $display("reference: PC = 0x%8h, wb_rf_wnum = 0x%2h, wb_rf_wdata = 0x%8h",
                      debug_wb_pc, debug_wb_rf_wnum, debug_wb_rf_wdata);
           $display("--------------------------------------------------------------");    
	   end
	end

endmodule
