#include "temu.h"

#define ENTRY_START 0x80000000

char *exec_file;

void init_regex();
void init_wp_pool();
void init_ddr3();

FILE *log_fp = NULL;

//初始化日志
static void init_log() {
	log_fp = fopen("log.txt", "w");
	Assert(log_fp, "Can not open 'log.txt'");
}

//欢迎界面
static void welcome() {
	char* hello = 
	" _    _      _ _         _______ ______ __  __ _    _ \n"
	"| |  | |    | | |       |__   __|  ____|  \\/  | |  | |\n"
	"| |__| | ___| | | ___      | |  | |__  | \\  / | |  | |\n"
	"|  __  |/ _ \\ | |/ _ \\     | |  |  __| | |\\/| | |  | |\n"
	"| |  | |  __/ | | (_) |    | |  | |____| |  | | |__| |\n"
	"|_|  |_|\\___|_|_|\\___/     |_|  |______|_|  |_|\\____/ \n"
		;

	printf("%s\n",hello);
	printf("Welcome to TEMU!\nThe executable is %s.\nFor help, type \"help\"\n",
			exec_file);
}

//全局初始化
void init_monitor(int argc, char *argv[]) {
	/* Perform some global initialization */

	/*初始化日志，可以从参数中指定日志文件 */
	exec_file = argv[1];
	init_log();

	/* 编译正则表达式*/
	init_regex();

	/* Initialize the watchpoint pool. */
	init_wp_pool();

	/* Display welcome message. */
	welcome();
}

static void load_entry() {
	int ret;

	//打开inst.bin文件，获取大小，将 ENTRY_START 的高位清零确保有效？
	FILE *fp = fopen("inst.bin", "rb");
	Assert(fp, "Can not open 'inst.bin'");
	fseek(fp, 0, SEEK_END);
	size_t file_size = ftell(fp);
	fseek(fp, 0, SEEK_SET);
	ret = fread((void *)(hw_mem + (ENTRY_START & 0x7FFFFFFF)), file_size, 1, fp);  

	// load .text segment to memory address 0x00000000
	// 将程序的代码段加载入0x0

	assert(ret == 1);

	//指定数据段的储存地址
	fp = fopen("data.bin", "rb");
	Assert(fp, "Can not open 'data.bin'");
	fseek(fp, 0, SEEK_END);
	file_size = ftell(fp);
	fseek(fp, 0, SEEK_SET);
	ret = fread((void *)(hw_mem + ((ENTRY_START + 0x400000) & 0x7FFFFFFF)), file_size, 1, fp); // load .data segment to memory address 0x00400000

	fclose(fp);
}

void restart() {
	/* Perform some initialization to restart a program */

	/* Read the entry code into memory. */
	load_entry();

	/* 设置PC计数器 */
	cpu.pc = ENTRY_START;

	/* Initialize DRAM. */
	init_ddr3();
}
