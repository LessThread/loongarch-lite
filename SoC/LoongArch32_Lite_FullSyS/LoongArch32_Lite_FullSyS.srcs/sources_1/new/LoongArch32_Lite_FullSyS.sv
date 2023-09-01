`timescale 1ns / 1ps

module LoongArch32_Lite_FullSyS(
    input sys_clk_25M,                          // 系统时钟25MHz
    input sys_rst_n,                            // 系统复位
    
    input        [7 : 0]    dip_sw,             // 拨动开关输入端
    input        [7 : 0]    btn_rc,             // 键盘阵列输入端
    input                   rxd,                // 串口接收端
    output logic            txd,                // 串口发送端
    output logic [3 : 0]    anL,                // 高位数码管使能段
    output logic [7 : 0]    a_to_gL,            // 高位数码管数据段
    output logic [3 : 0]    anH,                // 低位数码管使能段
    output logic [7 : 0]    a_to_gH,            // 高位数码管数据段
    output logic [7 : 0]    leds                // LED灯输出端
    );
    
    logic [15 : 0] numberH, numberL;
    logic [ 3 : 0] btn_num, btn_num_buffer;
    logic [ 7 : 0] dip_sw_bits;
    
    // 注意：如下代码仅为拨动开关演示示例，请根据设计要求自行修改
    always_ff @(posedge sys_clk_25M or negedge sys_rst_n) begin
        if (~sys_rst_n) dip_sw_bits <= 0;
        else dip_sw_bits <= dip_sw; 
    end
    
    // 注意：如下代码仅为键盘阵列演示示例，请根据设计要求自行修改
    btn_array btnA(.btn_rc(btn_rc), .btn_num(btn_num));
    
    always_ff @(posedge sys_clk_25M or negedge sys_rst_n) begin
        if (~sys_rst_n) btn_num_buffer <= 0;
        else btn_num_buffer <= btn_num; 
    end
    
    // 注意：如下代码仅为LED灯演示示例，请根据设计要求自行修改
    assign leds = dip_sw_bits;
    
     // 注意：如下代码仅为7端数码管演示示例，请根据设计要求自行修改
    x7seg segH(
        .sys_clk(sys_clk_25M), 
        .sys_rst_n(sys_rst_n), 
        .iDIGL(numberH[7 : 0]), 
        .iDIGH(numberH[15 : 8]), 
        .an(anH), 
        .a_to_g(a_to_gH)
    );
    
    x7seg segL(
        .sys_clk(sys_clk_25M), 
        .sys_rst_n(sys_rst_n), 
        .iDIGL(numberL[7 : 0]), 
        .iDIGH(numberL[15 : 8]), 
        .an(anL), 
        .a_to_g(a_to_gL)
    );
    assign numberH = {2{ext_uart_buffer}};
    assign numberL = {4{btn_num_buffer}};
    
    // 如下代码仅为直连串口接收发送演示示例（即从直连串口收到的数据再发送回串口），请根据设计要求自行修改
    logic [7:0] ext_uart_rx;
    logic [7:0] ext_uart_buffer, ext_uart_tx;
    logic ext_uart_ready, ext_uart_clear, ext_uart_busy;
    logic ext_uart_start, ext_uart_avai;

    async_receiver #(.ClkFrequency(25000000),.Baud(9600)) //接收模块，9600无检验位
    ext_uart_r(
        .clk(sys_clk_25M),                       //外部时钟信号
        .RxD(rxd),                           //外部串行信号输入
        .RxD_data_ready(ext_uart_ready),  //数据接收到标志
        .RxD_clear(ext_uart_clear),       //清除接收标志
        .RxD_data(ext_uart_rx)             //接收到的一字节数据
    );

    assign ext_uart_clear = ext_uart_ready; //收到数据的同时，清除标志，因为数据已取到ext_uart_buffer中
    always @(posedge sys_clk_25M) begin //接收到缓冲区ext_uart_buffer
        if(ext_uart_ready)begin
            ext_uart_buffer <= ext_uart_rx;
            ext_uart_avai <= 1;
        end else if(!ext_uart_busy && ext_uart_avai)begin 
            ext_uart_avai <= 0;
        end
    end
    always @(posedge sys_clk_25M) begin //将缓冲区ext_uart_buffer发送出去
        if(!ext_uart_busy && ext_uart_avai)begin 
            ext_uart_tx <= ext_uart_buffer;
            ext_uart_start <= 1;
        end else begin 
            ext_uart_start <= 0;
        end
    end

    async_transmitter #(.ClkFrequency(25000000),.Baud(9600)) //发送模块，9600无检验位
    ext_uart_t(
        .clk(sys_clk_25M),                  //外部时钟信号
        .TxD(txd),                      //串行信号输出
        .TxD_busy(ext_uart_busy),       //发送器忙状态指示
        .TxD_start(ext_uart_start),    //开始发送信号
        .TxD_data(ext_uart_tx)        //待发送的数据
    );
    
endmodule