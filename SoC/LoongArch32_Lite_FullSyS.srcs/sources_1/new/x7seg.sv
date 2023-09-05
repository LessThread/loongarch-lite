`timescale 1ns / 1ps

module x7seg_scan(
    input                      sys_clk,
    input                      sys_rst_n,
    input                      clk_flag,
    input           [7 : 0]    iDIGH,
    input           [7 : 0]    iDIGL,
    output logic    [3 : 0]    x7seg_data,
    output logic    [3 : 0]    an
    );
    
    localparam STUBNUM = 4;
    localparam  AN0  = 4'b0001,
                AN1  = 4'b0010,
                AN2  = 4'b0100,
                AN3  = 4'b1000;
                
    logic [1 : 0] r_cnt;
    
    always_ff @(posedge sys_clk or negedge sys_rst_n) begin
        if (~sys_rst_n) r_cnt <= 2'b00;
        else if (clk_flag) begin
            if (r_cnt == STUBNUM - 1) r_cnt <= 2'b00;
            else r_cnt <= r_cnt + 1;
        end
        else r_cnt <= r_cnt;
    end
    
    always_ff @(posedge sys_clk or negedge sys_rst_n) begin
        if (~sys_rst_n) an <= 4'b1111;
        else begin
            case (r_cnt)
                2'b00 : an <= AN0;
                2'b01 : an <= AN1;
                2'b10 : an <= AN2;
                2'b11 : an <= AN3;
            endcase
        end
    end
    
    always_ff @(posedge sys_clk or negedge sys_rst_n) begin
        if (~sys_rst_n) x7seg_data <= 4'b0000;
        else begin
            case (r_cnt)
                2'b00 : x7seg_data <= iDIGL[3 : 0];
                2'b01 : x7seg_data <= iDIGL[7 : 4];
                2'b10 : x7seg_data <= iDIGH[3 : 0];
                2'b11 : x7seg_data <= iDIGH[7 : 4];
            endcase
        end
    end
    
endmodule

///////////////////////////////////////////////////////////

module x7seg_dec(
    input [3 : 0] D,
    output logic [7 : 0] a_to_g
    );
    
    localparam  NUM0 = 8'b1100_0000,
                NUM1 = 8'b1111_1001,
                NUM2 = 8'b1010_0100,
                NUM3 = 8'b1011_0000,
                NUM4 = 8'b1001_1001,
                NUM5 = 8'b1001_0010,
                NUM6 = 8'b1000_0010,
                NUM7 = 8'b1111_1000,
                NUM8 = 8'b1000_0000,
                NUM9 = 8'b1001_0000,
                NUMA = 8'b1000_1000,
                NUMB = 8'b1000_0011,
                NUMC = 8'b1100_0110,
                NUMD = 8'b1010_0001,
                NUME = 8'b1000_0110,
                NUMF = 8'b1000_1110;
    
    always_comb begin

        case(D)
            4'h0:   a_to_g = NUM0;  
            4'h1:   a_to_g = NUM1;  
            4'h2:   a_to_g = NUM2;  
            4'h3:   a_to_g = NUM3;  
            4'h4:   a_to_g = NUM4;  
            4'h5:   a_to_g = NUM5;  
            4'h6:   a_to_g = NUM6;  
            4'h7:   a_to_g = NUM7;  
            4'h8:   a_to_g = NUM8;  
            4'h9:   a_to_g = NUM9;
            4'hA:   a_to_g = NUMA;
            4'hB:   a_to_g = NUMB;
            4'hC:   a_to_g = NUMC;
            4'hD:   a_to_g = NUMD;
            4'hE:   a_to_g = NUME;
            4'hF:   a_to_g = NUMF;
        endcase
    
   end 
    
endmodule

///////////////////////////////////////////////////////////////

module clken(
    input           sys_clk,
    input           sys_rst_n,
    output logic    clk_flag
    );
    `ifdef SIMULATION
        localparam SYS_CLK_FREQ     = 25_000_000;
        localparam TARGET_CLK_FREQ  = 2_500_000;
        localparam N                = 20;
        localparam CNT_MAX          = SYS_CLK_FREQ / TARGET_CLK_FREQ;
    `else
        localparam SYS_CLK_FREQ     = 25_000_000;
        localparam TARGET_CLK_FREQ  = 1_000;
        localparam N                = 20;
        localparam CNT_MAX          = SYS_CLK_FREQ / TARGET_CLK_FREQ;
    `endif
    
    logic   [N - 1 : 0] r_cnt;
    
    always_ff @(posedge sys_clk or negedge sys_rst_n) begin
    
        if(!sys_rst_n)  r_cnt <= 0;
        else if (r_cnt == CNT_MAX - 1)    r_cnt <= 0;
        else    r_cnt <= r_cnt + 1;
    
    end
    
    always_ff @(posedge sys_clk or negedge sys_rst_n) begin
    
        if(!sys_rst_n)  clk_flag = 1'b0;
        else if (r_cnt == CNT_MAX - 1)    clk_flag <= 1'b1;
        else    clk_flag = 1'b0;
    
    end
    
endmodule

///////////////////////////////////////////////////////////////////////////

module x7seg(
    input                   sys_clk,
    input                   sys_rst_n,
    input        [7 : 0]    iDIGL,
    input        [7 : 0]    iDIGH,
    output logic [3 : 0]    an,
    output logic [7 : 0]    a_to_g
    );
    
    logic           clk_1MS;
    logic [3 : 0]   x7seg_data;
    
    clken U0( 
        .sys_clk    (sys_clk)   ,
        .sys_rst_n  (sys_rst_n) ,
        .clk_flag   (clk_1MS)
    );
    
    x7seg_scan U1(
        .sys_clk    (sys_clk)   ,
        .sys_rst_n  (sys_rst_n) ,
        .clk_flag   (clk_1MS)   ,
        .iDIGH      (iDIGH)     ,
        .iDIGL      (iDIGL)     ,
        .x7seg_data (x7seg_data),
        .an         (an)
    );
    
    x7seg_dec U2(
        .D      (x7seg_data),
        .a_to_g (a_to_g)    
    );
    
endmodule