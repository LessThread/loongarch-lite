#include "monitor.h"
#include "temu.h"

#include <stdlib.h>
#include <readline/readline.h>
#include <readline/history.h>

void cpu_exec(uint32_t);

void display_reg();

/* We use the `readline' library to provide more flexibility to read from stdin. */
char* rl_gets() {
	static char *line_read = NULL;

	if (line_read) {
		free(line_read);
		line_read = NULL;
	}

	line_read = readline("(temu) ");

	if (line_read && *line_read) {
		add_history(line_read);
	}

	return line_read;
}

static int cmd_c(char *args) {
	//向CPU执行传入了-1的参数
	cpu_exec(-1);
	return 0;
}

static int cmd_q(char *args) {
	return -1;
}

static int cmd_help(char *args);

static int cmd_si(char *args);
static int cmd_info();
static int cmd_p();
static int cmd_x();
static int cmd_w();
static int cmd_d();

static struct {
	char *name;
	char *description;
	int (*handler) (char *);
} cmd_table [] = {
	{ "help", "Display informations about all supported commands", cmd_help },
	{ "c", "Continue the execution of the program", cmd_c },
	{ "q", "Exit TEMU", cmd_q },
	{ "si","Single step execution",cmd_si},
	{"info [SUBCMD]","Print program status",cmd_info},
	{"p [EXPR]","Expression",cmd_p},
	{"x [N] [EXPR]","Scan Memory",cmd_x},
	{"w [EXPR]","Set up monitoring points",cmd_w},
	{"d [N]","Delete Watchpoint",cmd_d}

	/* TODO: Add more commands */

};

#define NR_CMD (sizeof(cmd_table) / sizeof(cmd_table[0]))

//处理help信息
static int cmd_help(char *args) {
	/* extract the first argument */
	char *arg = strtok(NULL, " ");
	int i;

	if(arg == NULL) {
		/* no argument given */
		for(i = 0; i < NR_CMD; i ++) {
			printf("%s - %s\n", cmd_table[i].name, cmd_table[i].description);
		}
	}
	else {
		for(i = 0; i < NR_CMD; i ++) {
			if(strcmp(arg, cmd_table[i].name) == 0) {
				printf("%s - %s\n", cmd_table[i].name, cmd_table[i].description);
				return 0;
			}
		}
		printf("Unknown command '%s'\n", arg);
	}
	return 0;
}

void ui_mainloop() {
	while(1) {
		char *str = rl_gets();
		char *str_end = str + strlen(str);

		/* extract the first token as the command */
		char *cmd = strtok(str, " ");
		if(cmd == NULL) { continue; }

		/* treat the remaining string as the arguments,
		 * which may need further parsing
		 */
		char *args = cmd + strlen(cmd) + 1;
		if(args >= str_end) {
			args = NULL;
		}

		int i;
		for(i = 0; i < NR_CMD; i ++) {
			if(strcmp(cmd, cmd_table[i].name) == 0) {
				if(cmd_table[i].handler(args) < 0) { return; }
				break;
			}
		}

		if(i == NR_CMD) { printf("Unknown command '%s'\n", cmd); }
	}
}

bool isDigit(char c) {
    return (c >= '0' && c <= '9');
}

static int cmd_si(char *args){

	char* charArray = args;
    uint32_t result = 0;

	// 处理字符串的转化
    for (int i = 0; i < strlen(charArray); i++) {
		if (!isDigit(charArray[i])) {
            printf("Invalid character '%c' found. Conversion aborted.\n", charArray[i]);
            return 0;
        }
        result = result * 10 + (charArray[i] - '0');
    }

	//执行指定步数
	printf("step: %s\n",args);
	cpu_exec(result);
	return 0;
}

static int cmd_info(){return 0;}
static int cmd_p(){return 0;}
static int cmd_x(){return 0;}
static int cmd_w(){return 0;}
static int cmd_d(){return 0;}