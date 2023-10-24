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
	
	MiniMIPS32_SYS SoC (
		.sys_clk_200M_p(sys_clk_200M_p),
		.sys_clk_200M_n(sys_clk_200M_n),
		.sys_rst_n(sys_rst_n)
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
