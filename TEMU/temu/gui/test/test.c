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
        execl("./main", NULL);

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
        signal(SIGTERM, signal_handler);

        return 0;
    }

}
void execCommand()
{
    if (strcmp(input, "exit") == 0)
    {   
        close(input_pipefd[1]);
        close(output_pipefd[0]);

        exit(0);
    }
    else if (strcmp(input, "info") == 0)
    {   
        printf("in:%s\n",input);
        write(input_pipefd[1], input, sizeof(input));
        read(output_pipefd[0], output, sizeof(output));
        while ((bytesRead = read(output_pipefd[0], output, sizeof(output))) > 0) {
            printf("%.*s", (int)bytesRead, output);
        }
        printf("res: %s",output);

    }
    else if (strcmp(input, "c") == 0)
    {   strcat(input,"\n");
        write(input_pipefd[1], input, sizeof(input));
        read(output_pipefd[0], output, sizeof(output));
        printf("res: %s",output);
    }


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

    while (1)
    {
        printf("wait:");
        scanf("%s", input);
        execCommand();
    }
    
}