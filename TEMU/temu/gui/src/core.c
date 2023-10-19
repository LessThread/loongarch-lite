#include "../inc/core.h"
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
        int logFD = open("./output-log.txt", O_RDWR | O_CREAT | O_TRUNC, 0644);
        if (logFD == -1) {
            perror("Error opening file");
            exit(1);
        }

        // 子进程重定向读写
        close(input_pipefd[1]);
        close(output_pipefd[0]);
        dup2(input_pipefd[0], STDIN_FILENO);
        //dup2(output_pipefd[1], STDOUT_FILENO);
        dup2(logFD, STDOUT_FILENO);

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
        signal(SIGTERM, signal_handler);

        return 0;
    }

}