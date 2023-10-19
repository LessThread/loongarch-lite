#include "../inc/command.h"

// void getPC()
// {
//     strcpy(input,"")
// }


void sendRequest2Core()
{
    number++;
    strcat(input,"\n");
    write(input_pipefd[1], input, strlen(input));
    //fsync(input_pipefd[1]);

    //清空中间文件
    //ftruncate(logFD, 0);
}

char* extract_content(FILE* file) {
    const char* start_marker = "(temu)";
    const char* end_marker = "(temu)";
    char line[256];
    int start_len = strlen(start_marker);
    int end_len = strlen(end_marker);
    int is_inside_content = 0;
    char* content = NULL;
    size_t content_size = 0;
    
    while (fgets(line, sizeof(line), file) != NULL) {
        if (strstr(line, end_marker) != NULL) {
            if (is_inside_content) {
                break;
            }
            is_inside_content = 1;
        }
        
        if (is_inside_content) {
            size_t line_len = strlen(line);
            char* new_content = realloc(content, content_size + line_len + 1);
            if (new_content == NULL) {
                printf("内存分配失败\n");
                free(content);
                return NULL;
            }
            content = new_content;
            memcpy(content + content_size, line, line_len);
            content_size += line_len;
            content[content_size] = '\0';
        }
    }
    
    return content;
}

void getRespondFormCore()
{
    FILE* file = fopen("./output-log.txt", "r");
    if (file == NULL) {
        exit(0);
    }
    
    char* cont = extract_content(file);
    strcpy(output,cont);
    free(cont);
    fclose(file);
    return;
    // read(output_pipefd[0], output, sizeof(output));

    // char buffer[1024];
    // int fd = open(output_pipefd[0], O_RDONLY | O_NONBLOCK); // 以非阻塞模式打开管道文件
    // ssize_t bytesRead;
    // do {
    //     bytesRead = read(fd, buffer, sizeof(buffer));
    //     if (bytesRead > 0) {
    //     }
    // } while (bytesRead > 0);
    // close(fd);
}

void printRespondInGUI()
{
    mvprintw(main_win,2,1, " ");
    mvprintw(main_win,2,1, "%s", output);

    mvwprintw(win_1, 1, 1, "num:%d",number);
    wrefresh(win_1);
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
        sendRequest2Core();
        getRespondFormCore();
        printRespondInGUI();
    }
    else if (strcmp(input, "c") == 0)
    {   
        sendRequest2Core();
        getRespondFormCore();
        printRespondInGUI();
    }
    else if (strcmp(input, "next") == 0)
    {   
        strcpy(input,"si");
        sendRequest2Core();
        getRespondFormCore();
        printRespondInGUI();
    }
    else if (strcmp(input, "n") == 0)
    {   
        strcpy(input,"si");
        sendRequest2Core();
        getRespondFormCore();
        printRespondInGUI();
    }
    else
    {
        for(int i = CORE_OUTPUT;i<CORE_OUTPUT+10;i++)
        {
            mvprintw(main_win,2,1, " ");
        }
    }

    // 重置输入缓冲区
    for(int i=0;i<80;i++){input[i]='\0';}
    for(int i = CORE_OUTPUT;i<CORE_OUTPUT+10;i++)
        {
            mvprintw(main_win,2,1, "                  ");
        }
    inputIndex = 0; 
    mvprintw(LINES - 1, 0, "(TEMU GUI) %s\n", input);
}

