`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/21 14:44:44
// Design Name: 
// Module Name: ALU
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


module ALU(
    input  wire [`ALUOP_BUS	    ] 	alu_aluop_i,
    input  wire [`REG_BUS 		] 	alu_src1_i,
    input  wire [`REG_BUS 		] 	alu_src2_i,
    
    output reg [`REG_BUS 		]   alu_logicres,
    output reg [`REG_BUS 		]   alu_arithres,
    output reg [`REG_BUS 		]   alu_shiftres
    );
    always @(*) begin
        case(alu_aluop_i)
            `LoongArch32_OR : begin
                alu_logicres = alu_src1_i | alu_src2_i;
                alu_arithres = `ZERO_WORD;
                alu_shiftres = `ZERO_WORD;
            end
            `LoongArch32_ORI : begin
                alu_logicres = alu_src1_i | alu_src2_i;
                alu_arithres = `ZERO_WORD;
                alu_shiftres = `ZERO_WORD;
            end
            `LoongArch32_ADD_W : begin
                alu_logicres = `ZERO_WORD;
                alu_arithres = alu_src1_i + alu_src2_i;
                alu_shiftres = `ZERO_WORD;
            end
            `LoongArch32_ADDI_W : begin
                alu_logicres = `ZERO_WORD;
                alu_arithres = alu_src1_i + alu_src2_i;
                alu_shiftres = `ZERO_WORD;
            end
            `LoongArch32_XOR : begin
                alu_logicres = alu_src1_i ^ alu_src2_i;
                alu_arithres = `ZERO_WORD;
                alu_shiftres = `ZERO_WORD;
            end
            `LoongArch32_SRL_W : begin
                alu_logicres = `ZERO_WORD;
                alu_arithres = `ZERO_WORD;
                alu_shiftres = alu_src1_i >> alu_src2_i[4:0];
            end
            `LoongArch32_SLTU : begin
                alu_logicres = `ZERO_WORD;
                alu_arithres = ( $unsigned(alu_src1_i) < $unsigned(alu_src2_i) ) ? 32'b1 : `ZERO_WORD ;
                alu_shiftres = `ZERO_WORD;
            end
            `LoongArch32_ANDI : begin
                alu_logicres = alu_src1_i & alu_src2_i;
                alu_arithres = `ZERO_WORD;
                alu_shiftres = `ZERO_WORD;
            end
            `LoongArch32_LD_W : begin
                alu_logicres = `ZERO_WORD;
                alu_arithres = alu_src1_i + alu_src2_i;
                alu_shiftres = `ZERO_WORD;
            end
            `LoongArch32_LD_B : begin
                alu_logicres = `ZERO_WORD;
                alu_arithres = alu_src1_i + alu_src2_i;
                alu_shiftres = `ZERO_WORD;
            end
            `LoongArch32_ST_W : begin
                alu_logicres = `ZERO_WORD;
                alu_arithres = alu_src1_i + alu_src2_i;
                alu_shiftres = `ZERO_WORD;
            end
            `LoongArch32_ST_B : begin
                alu_logicres = `ZERO_WORD;
                alu_arithres = alu_src1_i + alu_src2_i;
                alu_shiftres = `ZERO_WORD;
            end
            `LoongArch32_LU12I_W : begin
                alu_logicres = `ZERO_WORD;
                alu_arithres = alu_src2_i + alu_src1_i;
                alu_shiftres = `ZERO_WORD;
            end
            `LoongArch32_PCADDU12I : begin
                alu_logicres = `ZERO_WORD;
                alu_arithres = alu_src2_i + alu_src1_i;
                alu_shiftres = `ZERO_WORD;
            end
        endcase
    end
endmodule
