#include "monitor.h"
#include "helper.h"
#include "watchpoint.h"
/* The assembly code of instructions executed is only output to the screen
 * when the number of instructions executed is less than this value.
 * This is useful when you use the `si' command.
 * You can modify this value as you want.
 */
#define MAX_INSTR_TO_PRINT 1000

int temu_state = STOP;

void exec(uint32_t);

char assembly[80];
char asm_buf[128];

//Golden_trace实现
char golden_trace[128];

void print_bin_instr(uint32_t pc) {
	int i;
	int l = sprintf(asm_buf, "%8x:   ", pc);
	for(i = 3; i >= 0; i --) {
		l += sprintf(asm_buf + l, "%02x ", instr_fetch(pc + i, 1));
	}
	sprintf(asm_buf + l, "%*.s", 8, "");
}

void cpu_exec(volatile uint32_t n) {
	
	uint32_t pc;
	if(temu_state == END) {
		printf("Program execution has ended. To restart the program, exit TEMU and run again.\n");
		return;
	}
	temu_state = RUNNING;

#ifdef DEBUG
	volatile uint32_t n_temp = n;
#endif

	for(; n > 0; n --) {

		pc = cpu.pc & 0x7fffffff;  //将虚拟地址映射到物理地址，例如cpu中的最高位。清除pc
		
#ifdef DEBUG
		uint32_t pc_temp = pc;
		if((n & 0xffff) == 0) {
			
			fputc('.', stderr);
		}
#endif


		/*执行一条指令，包括指令获取，指令解码和实际执行*/
		exec(pc);

		cpu.pc += 4;

//trace实现
#ifdef DEBUG
		char buf[32] = {0};
		sprintf(buf, "0x8%.7x: ", pc_temp);
		Trace_write("%s %s\n",buf,golden_trace);
#endif

#ifdef DEBUG
		print_bin_instr(pc_temp);
		strcat(asm_buf, assembly);
		Log_write("%s\n", asm_buf);
		if(n_temp < MAX_INSTR_TO_PRINT) {
			printf("%s\n", asm_buf);
		}
#endif

		/* TODO: check watchpoints here. */
		WatcherExpHook();

		if(temu_state != RUNNING) { return; }
	}

	if(temu_state == RUNNING) { temu_state = STOP; }
}
