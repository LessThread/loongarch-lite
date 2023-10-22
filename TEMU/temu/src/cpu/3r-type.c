#include "helper.h"
#include "monitor.h"
#include "reg.h"

extern uint32_t instr;
extern char assembly[80];
extern char golden_trace[128];

/* decode 3R-type instrucion */
static void decode_3r_type(uint32_t instr) {

	op_src1->type = OP_TYPE_REG;
	op_src1->reg = (instr >> 5) & 0x0000001F;
	op_src1->val = reg_w(op_src1->reg);
	
	op_src2->type = OP_TYPE_REG;
	op_src2->imm = (instr >> 10) & 0x0000001F;
	op_src2->val = reg_w(op_src2->reg);

	op_dest->type = OP_TYPE_REG;
	op_dest->reg = instr & 0x0000001F;
}

make_helper(or) {

	decode_3r_type(instr);
	reg_w(op_dest->reg) = (op_src1->val | op_src2->val);
	sprintf(assembly, "or  %s,  %s,  %s", REG_NAME(op_dest->reg), REG_NAME(op_src1->reg), REG_NAME(op_src2->reg));
	sprintf(golden_trace,"%s    0x%08x",REG_NAME(op_dest->reg),reg_w(op_dest->reg));

}

make_helper(add_w) {

	decode_3r_type(instr);
	// 是否需要考虑溢出问题而进行位置的框选
	reg_w(op_dest->reg) = (op_src1->val + op_src2->val);
	sprintf(assembly, "add.w  %s,  %s,  %s", REG_NAME(op_dest->reg), REG_NAME(op_src1->reg), REG_NAME(op_src2->reg));
	sprintf(golden_trace,"%s    0x%08x",REG_NAME(op_dest->reg),reg_w(op_dest->reg));
}

make_helper(xor) {

    decode_3r_type(instr);
	reg_w(op_dest->reg) = (op_src1->val ^ op_src2->val);
	sprintf(assembly, "xor  %s,  %s,  %s", REG_NAME(op_dest->reg), REG_NAME(op_src1->reg), REG_NAME(op_src2->reg));
	sprintf(golden_trace,"%s    0x%08x",REG_NAME(op_dest->reg),reg_w(op_dest->reg));
}
make_helper(srl_w) {

	decode_3r_type(instr);
    uint32_t temp;
	temp = (op_src2->val & 0x0000001f); 
	reg_w(op_dest->reg) = (uint32_t)(op_src1->val>>temp); 
	sprintf(assembly, "srl.w  %s,  %s,  %s", REG_NAME(op_dest->reg), REG_NAME(op_src1->reg), REG_NAME(op_src2->reg));
	sprintf(golden_trace,"%s    0x%08x",REG_NAME(op_dest->reg),reg_w(op_dest->reg));
}
make_helper(sltu) {

    decode_3r_type(instr);
	reg_w(op_dest->reg) = (uint32_t)op_src1->val < (uint32_t)op_src2->val ? 1 : 0;
	sprintf(assembly, "sltu  %s,  %s,  %s", REG_NAME(op_dest->reg), REG_NAME(op_src1->reg), REG_NAME(op_src2->reg));
	sprintf(golden_trace,"%s    0x%08x",REG_NAME(op_dest->reg),reg_w(op_dest->reg));
}