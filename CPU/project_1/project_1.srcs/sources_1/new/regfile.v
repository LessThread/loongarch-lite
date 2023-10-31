`include "defines.v"

module regfile(
    input  wire 				 cpu_clk_50M,
	input  wire 				 cpu_rst_n,
	
	// 写端口
	input  wire  [`REG_ADDR_BUS] wa,
	input  wire  [`REG_BUS 	   ] wd,
	input  wire 				 we,
	
	// 读端口1
	input  wire  [`REG_ADDR_BUS] ra1,
	output reg   [`REG_BUS 	   ] rd1,
	input  wire 				 re1,
	
	// 读端口2 
	input  wire  [`REG_ADDR_BUS] ra2,
	output reg   [`REG_BUS 	   ] rd2,
	input  wire 			     re2,
	
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
	output wire  [`REG_BUS] 	regs31
    );

    //定义32个32位寄存器
	reg [`REG_BUS] 	regs[0:`REG_NUM-1];
	
	always @(posedge cpu_clk_50M) begin
		if (cpu_rst_n == `RST_ENABLE) begin
			regs[ 0] <= `ZERO_WORD;
			regs[ 1] <= `ZERO_WORD;     //注意：寄存器1和2复位后应该均是0x00000000，此处赋了其他初值是因为如果只有R-型指令是无法给寄存器赋值的。因此后续加入I-型指令后可恢复为初值为0的设置
			regs[ 2] <= `ZERO_WORD;
			regs[ 3] <= `ZERO_WORD;
			regs[ 4] <= `ZERO_WORD;
			regs[ 5] <= `ZERO_WORD;
			regs[ 6] <= `ZERO_WORD;
			regs[ 7] <= `ZERO_WORD;
			regs[ 8] <= `ZERO_WORD;
			regs[ 9] <= `ZERO_WORD;
			regs[10] <= `ZERO_WORD;
			regs[11] <= `ZERO_WORD;
			regs[12] <= `ZERO_WORD;
			regs[13] <= `ZERO_WORD;
			regs[14] <= `ZERO_WORD;
			regs[15] <= `ZERO_WORD;
			regs[16] <= `ZERO_WORD;
			regs[17] <= `ZERO_WORD;
			regs[18] <= `ZERO_WORD;
			regs[19] <= `ZERO_WORD;
			regs[20] <= `ZERO_WORD;
			regs[21] <= `ZERO_WORD;
			regs[22] <= `ZERO_WORD;
			regs[23] <= `ZERO_WORD;
			regs[24] <= `ZERO_WORD;
			regs[25] <= `ZERO_WORD;
			regs[26] <= `ZERO_WORD;
			regs[27] <= `ZERO_WORD;
			regs[28] <= `ZERO_WORD;
			regs[29] <= `ZERO_WORD;
			regs[30] <= `ZERO_WORD;
			regs[31] <= `ZERO_WORD;
		end
		else begin
			if ((we == `WRITE_ENABLE) && (wa != 5'h0))	
				regs[wa] <= wd;
		end
	end
	
	//读端口1的读操作 
	// ra1是读地址、wa是写地址、we是写使能、wd是要写入的数据 
	always @(*) begin
		if (cpu_rst_n == `RST_ENABLE)
			rd1 <= `ZERO_WORD;
		else if (ra1 == `REG_NOP)
			rd1 <= `ZERO_WORD;
		else if (re1 == `READ_ENABLE)
			rd1 <= regs[ra1];
		else
			rd1 <= `ZERO_WORD;
	end
	
	//读端口2的读操作 
	// ra2是读地址、wa是写地址、we是写使能、wd是要写入的数据 
	always @(*) begin
		if (cpu_rst_n == `RST_ENABLE)
			rd2 <= `ZERO_WORD;
		else if (ra2 == `REG_NOP)
			rd2 <= `ZERO_WORD;
		else if (re2 == `READ_ENABLE)
			rd2 <= regs[ra2];
		else
			rd2 <= `ZERO_WORD;
	end

    assign regs0 = regs[0];
    assign regs1 = regs[1];
    assign regs2 = regs[2];
    assign regs3 = regs[3];
    assign regs4 = regs[4];
    assign regs5 = regs[5];
    assign regs6 = regs[6];
    assign regs7 = regs[7];
    assign regs8 = regs[8];
    assign regs9 = regs[9];
    assign regs10 = regs[10];
    assign regs11 = regs[11];
    assign regs12 = regs[12];
    assign regs13 = regs[13];
    assign regs14 = regs[14];
    assign regs15 = regs[15];
    assign regs16 = regs[16];
    assign regs17 = regs[17];
    assign regs18 = regs[18];
    assign regs19 = regs[19];
    assign regs20 = regs[20];
    assign regs21 = regs[21];
    assign regs22 = regs[22];
    assign regs23 = regs[23];
    assign regs24 = regs[24];
    assign regs25 = regs[25];
    assign regs26 = regs[26];
    assign regs27 = regs[27];
    assign regs28 = regs[28];
    assign regs29 = regs[29];
    assign regs30 = regs[30];
    assign regs31 = regs[31];
endmodule
