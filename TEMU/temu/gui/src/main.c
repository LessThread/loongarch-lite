#include <ncurses.h>
#include <string.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

//GUI命令读取
char input[80];
int inputIndex = 0;

// 核心进程
char output[1000];
int input_pipefd[2];
int output_pipefd[2];
pid_t pid;
pid_t child_pid;
ssize_t bytesRead;

// 绘制位置
#define CORE_OUTPUT 25


// 向子进程发送SIGTERM信号
void signal_handler(int signum) {
    kill(child_pid, SIGTERM);
}

void initGUI()
{
    // 初始化ncurses
    initscr();
    cbreak();
    noecho();
    keypad(stdscr, TRUE);

    // 清空屏幕并输出欢迎信息
    clear();
    //printw("Welcome TEMU GUI\n");
    refresh();

    //
    char* hello = 
	"  _    _      _ _         _______ ______ __  __ _    _ \n"
	"  | |  | |    | | |       |__   __|  ____|  \\/  | |  | |\n"
	"  | |__| | ___| | | ___      | |  | |__  | \\  / | |  | |\n"
	"  |  __  |/ _ \\ | |/ _ \\     | |  |  __| | |\\/| | |  | |\n"
	"  | |  | |  __/ | | (_) |    | |  | |____| |  | | |__| |\n"
	"  |_|  |_|\\___|_|_|\\___/     |_|  |______|_|  |_|\\____/ \n"
		;


    // 创建一个窗口
    WINDOW* win = newwin(20, 60, 2, 2);
    mvwprintw(win, 1, 1, hello);
    mvwprintw(win, 10, 1, "Welcome TEMU GUI\n");
    mvwprintw(win, 11, 1, "Enter 'exit' to exit the gui");
    mvprintw(CORE_OUTPUT-1, 0, "Output:");
    box(win, 0, 0);  // 绘制窗口边框
    wrefresh(win);

    // read(output_pipefd[0], output, sizeof(output));
    // mvprintw(CORE_OUTPUT, 0, "\n %s\n", output);

    // 在命令行下方显示用户输入
    mvprintw(LINES - 1, 0, "(TEMU GUI) ");
    refresh();

    for(int i=0;i<80;i++){input[i]='\0';}

}

int initCore()
{
    // 创建管道
    if (pipe(input_pipefd) == -1) {
        printf("无法创建管道\n");
    }

    if (pipe(output_pipefd) == -1) {
        printf("无法创建管道\n");
    }

    // 创建子进程
    pid = fork();
    if (pid < 0) {
        printf("无法创建子进程\n");
        return 1;
    }

    if (pid == 0) 
    {
        // 子进程

        // 重定向读写
        close(input_pipefd[1]);
        close(output_pipefd[0]);
        dup2(input_pipefd[0], STDIN_FILENO);
        dup2(output_pipefd[1], STDOUT_FILENO);

        // 执行另一个程序
        execl("../../build/temu", NULL);

        // 执行到这里表示execl调用失败
        printf("无法执行命令\n");
        exit(-1);
    } 
    else 
    {
        // 父进程
        close(input_pipefd[0]);
        close(output_pipefd[1]);

        // 注册信号，管理子进程的结束工作
        child_pid = pid;

        // 注册信号处理程序
        signal(SIGTERM, signal_handler);


        //以下是测试部分
        strcpy(input,"si");
        write(input_pipefd[1], input, sizeof(input));

        // while ((bytesRead = read(output_pipefd[0], output, sizeof(output))) > 0) {
        //     printf("%.*s", (int)bytesRead, output);
        // }

        return 0;
    }

}

void getCommand()
{
    // 循环获取用户输入
    while (1)
        {
            int ch = getch();
            if(ch == '\n') // 指令输入结束
            {
                mvprintw(LINES - 2, 0, "(TEMU GUI) %s\n", input);
                refresh();
                break;

            }
            else // 打印用户输入
            {
                input[inputIndex] = ch;  // 存储用户输入的字符
                inputIndex++;
                mvprintw(LINES - 1, 0, "(TEMU GUI) %s\n", input);  
                refresh();
            }
        }
}

void execCommand()
{
    // 检查用户输入是否为 "q"，如果是，则退出程序
    if (strcmp(input, "exit") == 0)
    {   
        close(input_pipefd[1]);
        close(output_pipefd[0]);

        // 清理 ncurses 并退出程序
        endwin();
        exit(0);
    }
    else if (strcmp(input, "info") == 0)
    {   
        write(input_pipefd[1], input, sizeof(input));
        read(output_pipefd[0], output, sizeof(output));
        mvprintw(CORE_OUTPUT, 0, "\n \n");
        mvprintw(CORE_OUTPUT, 0, "\n %s\n", output);

    }
    else if (strcmp(input, "c") == 0)
    {   
        write(input_pipefd[1], input, sizeof(input));
        read(output_pipefd[0], output, sizeof(output));
        mvprintw(CORE_OUTPUT, 0, "\n \n");
        mvprintw(CORE_OUTPUT, 0, "\n %s\n", output);

    }
    else
    {
        for(int i = CORE_OUTPUT;i<CORE_OUTPUT+10;i++)
        {
            mvprintw(i, 0, " ");
        }
    }

    // 重置输入缓冲区
    for(int i=0;i<80;i++){input[i]='\0';}
    for(int i = CORE_OUTPUT;i<CORE_OUTPUT+10;i++)
        {
            mvprintw(i, 0, "                  ");
        }
    inputIndex = 0; 
    mvprintw(LINES - 1, 0, "(TEMU GUI) %s\n", input);
}


int main()
{
    if(initCore())
    {
        printf("An error occurred during the initialization of the core.\nChild pid:%d\n",child_pid);
        char id[10];
        sprintf(id, "%d", (int)child_pid);
        //execl("/bin/bash","kill",id, NULL);
        execl("/bin/bash","stty echo", NULL);
        return 0;
    };
    initGUI();

    while (1)
    {
        getCommand();
        execCommand();
    }
    
}