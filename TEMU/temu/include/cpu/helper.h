#ifndef __HELPER_H__
#define __HELPER_H__

#include "temu.h"
#include "operand.h"

#define REG_NAME(index) regfile[index]

#define concat(x, y) concat_temp(x, y)

/*使用“make_helper”定义的所有函数都返回操作的长度*/
#define make_helper(name) void name(uint32_t pc)

static inline uint32_t instr_fetch(uint32_t addr, size_t len) {
	return mem_read(addr, len);
}

/* shared by all helper function */
extern Operands ops_decoded;

#define op_src1 (&ops_decoded.src1)
#define op_src2 (&ops_decoded.src2)
#define op_dest (&ops_decoded.dest)

#ifdef DEBUG
#define print_asm(...) Assert(snprintf(assembly, 80, __VA_ARGS__) < 80, "buffer overflow!")
#else
#define print_asm(...)
#endif


#endif
