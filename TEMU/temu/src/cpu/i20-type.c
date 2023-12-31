#include "helper.h"
#include "monitor.h"
#include "reg.h"

extern uint32_t instr;
extern char assembly[80];
extern char golden_trace[128];

/* decode I20-type instrucion with signed immediate */
static void decode_i20_type(uint32_t instr) {

	
	op_src2->type = OP_TYPE_IMM;
	op_src2->imm = (instr >> 5) & 0x000FFFFF;
	op_src2->val = op_src2->imm;

	op_dest->type = OP_TYPE_REG;
	op_dest->reg = instr & 0x0000001F;
}

make_helper(lu12i_w) {

	decode_i20_type(instr);
	reg_w(op_dest->reg) = (op_src2->val << 12);
	sprintf(assembly, "lu12i.w  %s,  0x%04x", REG_NAME(op_dest->reg), op_src2->imm);
	sprintf(golden_trace,"%s    0x%08x",REG_NAME(op_dest->reg),reg_w(op_dest->reg));
}

make_helper(pcaddu12i){

	decode_i20_type(instr);
	//printf("val:%.8x->%.8x\n",op_src2->val,op_src2->val>>4);
	reg_w(op_dest->reg) = (op_src2->val << 12) + cpu.pc;
	sprintf(assembly, "pcaddu12i  %s,  0x%04x", REG_NAME(op_dest->reg), op_src2->imm);
	sprintf(golden_trace,"%s    0x%08x",REG_NAME(op_dest->reg),reg_w(op_dest->reg));

}