#include "helper.h"
#include "memory.h"
#include "monitor.h"
#include "reg.h"
#include <stdlib.h>


extern uint32_t instr;
extern char assembly[80];
extern char golden_trace[128];

/* decode I12-type instrucion with unsigned immediate */
static void decode_ui12_type(uint32_t instr) {

	op_src1->type = OP_TYPE_REG;
	op_src1->reg = (instr >> 5) & 0x0000001F;
	op_src1->val = reg_w(op_src1->reg);

	op_src2->type = OP_TYPE_IMM;
	op_src2->imm = (instr >> 10) & 0x00000FFF;
	op_src2->val = op_src2->imm;

	op_dest->type = OP_TYPE_REG;
	op_dest->reg = instr & 0x0000001F;
}


make_helper(ori) {

	decode_ui12_type(instr);
	reg_w(op_dest->reg) = op_src1->val | op_src2->val;
	sprintf(assembly, "ori  %s,  %s,  0x%03x", REG_NAME(op_dest->reg), REG_NAME(op_src1->reg), op_src2->imm);
}
make_helper(addi_w) {
	decode_ui12_type(instr);
	// 是否需要考虑溢出问题而进行位置的框选
	// 进行符号拓展
	uint32_t temp;
	if((op_src2->val >> 11) == 1)
	   temp = op_src2->val | 0xFFFFFFFF;
	else
	   temp = op_src2->val | 0x00000000;

	reg_w(op_dest->reg) = (op_src1->val + temp);

	sprintf(assembly, "addi.w  %s,  %s,  0x%03x", REG_NAME(op_dest->reg), REG_NAME(op_src1->reg), (unsigned int)strtoul(REG_NAME(op_src2->reg), NULL, 10));
	sprintf(golden_trace,"%s    0x%08x",REG_NAME(op_dest->reg),reg_w(op_dest->reg));
}

make_helper(andi) {
	decode_ui12_type(instr);
	// 是否需要考虑溢出问题而进行位置的框选
	reg_w(op_dest->reg) = (op_src1->val & op_src2->val);

	sprintf(assembly, "andi  %s,  %s,  0x%03x", REG_NAME(op_dest->reg), REG_NAME(op_src1->reg), (unsigned int)strtoul(REG_NAME(op_src2->reg), NULL, 10));
	sprintf(golden_trace,"%s    0x%08x",REG_NAME(op_dest->reg),reg_w(op_dest->reg));
}

make_helper(ld_w) {
	decode_ui12_type(instr);
    // 符号拓展
	uint32_t temp;
	if((op_src2->val >> 11) == 1)
	   temp = op_src2->val | 0xFFFFF000;
	else
	   temp = op_src2->val | 0x00000000;

	uint32_t vaddr;
	vaddr = op_src1->val + temp;
	//Assert(vaddr < HW_MEM_SIZE, "physical address %x is outside of the physical memory", vaddr);
    //指令中所指vaddr指的是虚拟吗？地址可能存在问题，未完全按照指令集定义进行实现
    //是否需要加转换
	printf("temp:%d,vaddr:%.8x->%.8x\n",temp,vaddr,vaddr& 0x7fffffff);
	vaddr = vaddr& 0x7fffffff;
	reg_w(op_dest->reg) = mem_read(vaddr,4);
	sprintf(assembly, "ld.w  %s,  %s,  0x%03x", REG_NAME(op_dest->reg), REG_NAME(op_src1->reg), (unsigned int)strtoul(REG_NAME(op_src2->reg), NULL, 10));
	sprintf(golden_trace,"%s    0x%08x",REG_NAME(op_dest->reg),reg_w(op_dest->reg));

}

make_helper(ld_b) {
	decode_ui12_type(instr);
    // 符号拓展
	uint32_t temp;
	if((op_src2->val >> 11) == 1)
	   temp = op_src2->val | 0xFFFFF000;
	else
	   temp = op_src2->val | 0x00000000;

	uint32_t vaddr;
	vaddr = op_src1->val + temp;
	//Assert(vaddr < HW_MEM_SIZE, "physical address %x is outside of the physical memory", vaddr);
    //指令中所指vaddr指的是虚拟吗？地址可能存在问题，未完全按照指令集定义进行实现
    //是否需要加转换
	reg_w(op_dest->reg) = mem_read(vaddr,1);
	sprintf(assembly, "ld.b  %s,  %s,  0x%03x", REG_NAME(op_dest->reg), REG_NAME(op_src1->reg), (unsigned int)strtoul(REG_NAME(op_src2->reg), NULL, 10));
	sprintf(golden_trace,"%s    0x%08x",REG_NAME(op_dest->reg),reg_w(op_dest->reg));

}

make_helper(st_w) {
	decode_ui12_type(instr);
    // 符号拓展
	uint32_t temp;
	if((op_src2->val >> 11) == 1)
	   temp = op_src2->val | 0xFFFFF000;
	else
	   temp = op_src2->val | 0x00000000;

	uint32_t vaddr;
	vaddr = op_src1->val + temp;
	//Assert(vaddr < HW_MEM_SIZE, "physical address %x is outside of the physical memory", vaddr);
    //指令中所指vaddr指的是虚拟吗？地址可能存在问题，未完全按照指令集定义进行实现
    //是否需要加转换
	mem_write(vaddr, 4, reg_w(op_dest->reg));
	sprintf(assembly, "st.w  %s,  %s,  0x%03x", REG_NAME(op_dest->reg), REG_NAME(op_src1->reg), (unsigned int)strtoul(REG_NAME(op_src2->reg), NULL, 10));
}

make_helper(st_b) {
	decode_ui12_type(instr);
    // 符号拓展
	uint32_t temp;
	if((op_src2->val >> 11) == 1)
	   temp = op_src2->val | 0xFFFFF000;
	else
	   temp = op_src2->val | 0x00000000;

	uint32_t vaddr;
	vaddr = op_src1->val + temp;
	//Assert(vaddr < HW_MEM_SIZE, "physical address %x is outside of the physical memory", vaddr);
    //指令中所指vaddr指的是虚拟吗？地址可能存在问题，未完全按照指令集定义进行实现
    //是否需要加转换
	mem_write(vaddr, 1, reg_w(op_dest->reg));
	sprintf(assembly, "st.b  %s,  %s,  0x%03x", REG_NAME(op_dest->reg), REG_NAME(op_src1->reg), (unsigned int)strtoul(REG_NAME(op_src2->reg), NULL, 10));
	sprintf(golden_trace,"%s    0x%08x",REG_NAME(op_dest->reg),0);
}