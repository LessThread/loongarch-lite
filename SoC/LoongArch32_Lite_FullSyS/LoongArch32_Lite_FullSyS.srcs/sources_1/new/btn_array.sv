`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/27 16:24:45
// Design Name: 
// Module Name: btn_array
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module btn_array(
    input [7 : 0]   btn_rc,
    output logic [3 : 0] btn_num
    );
    
    always_comb begin
        case(btn_rc)
            8'b10001000 : btn_num = 4'hF;
            8'b10000100 : btn_num = 4'hE;
            8'b10000010 : btn_num = 4'hD;
            8'b10000001 : btn_num = 4'hC;
            8'b01001000 : btn_num = 4'hB;
            8'b01000100 : btn_num = 4'hA;
            8'b01000010 : btn_num = 4'h9;
            8'b01000001 : btn_num = 4'h8;
            8'b00101000 : btn_num = 4'h7;
            8'b00100100 : btn_num = 4'h6;
            8'b00100010 : btn_num = 4'h5;
            8'b00100001 : btn_num = 4'h4;
            8'b00011000 : btn_num = 4'h3;
            8'b00010100 : btn_num = 4'h2;
            8'b00010010 : btn_num = 4'h1;
            8'b00010001 : btn_num = 4'h0;
            default     : btn_num = 4'h0;
        endcase
    end
    
endmodule