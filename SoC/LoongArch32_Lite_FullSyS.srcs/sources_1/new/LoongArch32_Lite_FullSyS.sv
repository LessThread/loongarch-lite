`timescale 1ns / 1ps

module LoongArch32_Lite_FullSyS(
    input sys_clk_25M,                          // ϵͳʱ��25MHz
    input sys_rst_n,                            // ϵͳ��λ
    
    input        [7 : 0]    dip_sw,             // �������������
    input        [7 : 0]    btn_rc,             // �������������
    input                   rxd,                // ���ڽ��ն�
    output logic            txd,                // ���ڷ��Ͷ�
    output logic [3 : 0]    anL,                // ��λ�����ʹ�ܶ�
    output logic [7 : 0]    a_to_gL,            // ��λ��������ݶ�
    output logic [3 : 0]    anH,                // ��λ�����ʹ�ܶ�
    output logic [7 : 0]    a_to_gH,            // ��λ��������ݶ�
    output logic [7 : 0]    leds                // LED�������
    );
    
    logic [15 : 0] numberH, numberL;
    logic [ 3 : 0] btn_num, btn_num_buffer;
    logic [ 7 : 0] dip_sw_bits;
    
    // ע�⣺���´����Ϊ����������ʾʾ������������Ҫ�������޸�
    always_ff @(posedge sys_clk_25M or negedge sys_rst_n) begin
        if (~sys_rst_n) dip_sw_bits <= 0;
        else dip_sw_bits <= dip_sw; 
    end
    
    // ע�⣺���´����Ϊ����������ʾʾ������������Ҫ�������޸�
    btn_array btnA(.btn_rc(btn_rc), .btn_num(btn_num));
    
    always_ff @(posedge sys_clk_25M or negedge sys_rst_n) begin
        if (~sys_rst_n) btn_num_buffer <= 0;
        else btn_num_buffer <= btn_num; 
    end
    
    // ע�⣺���´����ΪLED����ʾʾ������������Ҫ�������޸�
    assign leds = dip_sw_bits;
    
     // ע�⣺���´����Ϊ7���������ʾʾ������������Ҫ�������޸�
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
    
    // ���´����Ϊֱ�����ڽ��շ�����ʾʾ��������ֱ�������յ��������ٷ��ͻش��ڣ�����������Ҫ�������޸�
    logic [7:0] ext_uart_rx;
    logic [7:0] ext_uart_buffer, ext_uart_tx;
    logic ext_uart_ready, ext_uart_clear, ext_uart_busy;
    logic ext_uart_start, ext_uart_avai;

    async_receiver #(.ClkFrequency(25000000),.Baud(9600)) //����ģ�飬9600�޼���λ
    ext_uart_r(
        .clk(sys_clk_25M),                       //�ⲿʱ���ź�
        .RxD(rxd),                           //�ⲿ�����ź�����
        .RxD_data_ready(ext_uart_ready),  //���ݽ��յ���־
        .RxD_clear(ext_uart_clear),       //������ձ�־
        .RxD_data(ext_uart_rx)             //���յ���һ�ֽ�����
    );

    assign ext_uart_clear = ext_uart_ready; //�յ����ݵ�ͬʱ�������־����Ϊ������ȡ��ext_uart_buffer��
    always @(posedge sys_clk_25M) begin //���յ�������ext_uart_buffer
        if(ext_uart_ready)begin
            ext_uart_buffer <= ext_uart_rx;
            ext_uart_avai <= 1;
        end else if(!ext_uart_busy && ext_uart_avai)begin 
            ext_uart_avai <= 0;
        end
    end
    always @(posedge sys_clk_25M) begin //��������ext_uart_buffer���ͳ�ȥ
        if(!ext_uart_busy && ext_uart_avai)begin 
            ext_uart_tx <= ext_uart_buffer;
            ext_uart_start <= 1;
        end else begin 
            ext_uart_start <= 0;
        end
    end

    async_transmitter #(.ClkFrequency(25000000),.Baud(9600)) //����ģ�飬9600�޼���λ
    ext_uart_t(
        .clk(sys_clk_25M),                  //�ⲿʱ���ź�
        .TxD(txd),                      //�����ź����
        .TxD_busy(ext_uart_busy),       //������æ״ָ̬ʾ
        .TxD_start(ext_uart_start),    //��ʼ�����ź�
        .TxD_data(ext_uart_tx)        //�����͵�����
    );
    
endmodule