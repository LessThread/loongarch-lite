#include "helper.h"
#include "monitor.h"
#include "reg.h"
#include <stdlib.h>

extern uint32_t instr;
extern char assembly[80];
extern char golden_trace[128];

/* decode I16-type instrucion with unsigned immediate */
static void decode_i16_type(uint32_t instr) {
    
    //操作数1是rj
	op_src1->type = OP_TYPE_REG;
	op_src1->reg = (instr >> 5) & 0x0000001F;
	op_src1->val = reg_w(op_src1->reg);
   
    // 操作数2是立即数
	op_src2->type = OP_TYPE_IMM;
	op_src2->imm = (instr >> 10) & 0x0000FFFF; //取16位
	op_src2->val = op_src2->imm;
    
    // dest寄存器是rd
	op_dest->type = OP_TYPE_REG;
	op_dest->reg = instr & 0x0000001F;
    op_dest->val = reg_w(op_dest->reg);
}

make_helper(beq) {

    decode_i16_type(instr);
	
    if(op_dest->val == op_src1->val)
    {
        uint32_t temp;
      	if((op_src2->val >> 15) == 1)
	        temp = (op_src2->val << 2) | 0xFFFC0000;
	    else
	        temp = (op_src2->val << 2) | 0x00000000;
        cpu.pc = cpu.pc + temp;
    }
	sprintf(assembly, "beq  %s,  %s,  0x%03x", REG_NAME(op_dest->reg), REG_NAME(op_src1->reg), (unsigned int)strtoul(REG_NAME(op_src2->val), NULL, 10));
	sprintf(golden_trace,"%s    0x%08x ",REG_NAME(op_dest->reg),0);
}

make_helper(bne) {

    decode_i16_type(instr);
	
    if(op_dest->val != op_src1->val)
    {
        uint32_t temp;
      	if((op_src2->val >> 15) == 1)
	        temp = (op_src2->val << 2) | 0xFFFC0000;
	    else
	        temp = (op_src2->val << 2) | 0x00000000;
        cpu.pc = cpu.pc + temp;
    }
	sprintf(assembly, "bne  %s,  %s,  0x%03x", REG_NAME(op_dest->reg), REG_NAME(op_src1->reg), (unsigned int)strtoul(REG_NAME(op_src2->val), NULL, 10));
	sprintf(golden_trace,"%s    0x%08x ",REG_NAME(op_dest->reg),0);
}

make_helper(bge) {

    decode_i16_type(instr);
	
    if(op_src1->val >= op_dest->val)
    {
        uint32_t temp;
      	if((op_src2->val >> 15) == 1)
	        temp = (op_src2->val << 2) | 0xFFFC0000;
	    else
	        temp = (op_src2->val << 2) | 0x00000000;
        cpu.pc = cpu.pc + temp;
    }
	sprintf(assembly, "bge  %s,  %s,  0x%03x", REG_NAME(op_dest->reg), REG_NAME(op_src1->reg), (unsigned int)strtoul(REG_NAME(op_src2->val), NULL, 10));
	sprintf(golden_trace,"%s    0x%08x ",REG_NAME(op_dest->reg),0);
 
}