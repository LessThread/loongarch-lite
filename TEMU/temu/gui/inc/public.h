#include <string.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <ncurses.h>
#include <fcntl.h>

#ifndef _GOBAL_VARIABLE_
#define _GOBAL_VARIABLE_

#define _OUTPUT_BUFF_SIZE_ 1000
#define _INPUT_BUFF_SIZE_ 100
#define CORE_OUTPUT 25 // 绘制位置
#define INFO_POSTION 25,2

//GUI命令读取
char input[_INPUT_BUFF_SIZE_];
int inputIndex;

//GUI
WINDOW* history_win;
WINDOW* main_win;
WINDOW* win_1;

// 核心进程
char output[_OUTPUT_BUFF_SIZE_];
int input_pipefd[2];
int output_pipefd[2];
pid_t pid;
pid_t child_pid;
ssize_t bytesRead;

//指令相关
int number;


#define debugger getchar()

#endif