#include "../inc/command.h"

void getPC()
{
    strcpy(input,"p $pc\n\0");
    sendRequest2Core();
    getRespondFormCore();
    strcat(output,"\n\0");

    int value = 0;
    char *ptr = strstr(output, "result:");
    if (ptr != NULL) {
        sscanf(ptr + strlen("result:"), "%d", &value);
        //printf("提取到的值为: %d\n", value);
    }else{
        printf("err\n");
    }

    mvwprintw(pc_win, 1, 1, "$PC:%d",value);
    wrefresh(pc_win);
}


void sendRequest2Core()
{
    strcat(input,"\n");
    write(input_pipefd[1], input, strlen(input));
    //fsync(input_pipefd[1]);

    //清空中间文件
    //ftruncate(logFD, 0);
}

char* extract_content(FILE* file) {
    const char* marker = "(temu)";
    char line[256];
    int marker_len = strlen(marker);
    char* content = NULL;
    size_t content_size = 0;
    int found_marker = 0;
    
    // 将文件指针移动到文件开头
    fseek(file, 0, SEEK_SET);
    
    while (fgets(line, sizeof(line), file) != NULL) {
        // 检查是否遇到了标记
        if (strstr(line, marker) != NULL) {
            found_marker = 1;
            content_size = 0; // 重置内容大小
            continue;
        }
        
        // 如果已经找到标记，则将读取到的内容存储在字符串中
        if (found_marker) {
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
    
    if (!found_marker) {
        printf("未找到标记\n");
        free(content);
        return NULL;
    }
    
    return content;
}

void getRespondFormCore()
{
    FILE* file = fopen("./output-log.txt", "r");
    if (file == NULL) {
        exit(0);
    }
    sleep(1);
    char* cont = extract_content(file);

    
    strcpy(output,cont);
    strcat(output,"\n\0");
    free(cont);
    //printf("%s\n",output);
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
    number++;
    strcat(output,"\n\0");
    //printf("%s",output);
    mvwprintw(main_win, 1,1, "Output:%s",output);
    box(main_win, 0, 0);
    wrefresh(main_win);
    
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

    getPC();

    // 重置输入缓冲区
    for(int i=0;i<80;i++){input[i]='\0';}
    for(int i = CORE_OUTPUT;i<CORE_OUTPUT+10;i++)
        {
            mvprintw(main_win,2,1, "                  ");
        }
    inputIndex = 0; 
    mvprintw(LINES - 1, 0, "(TEMU GUI) %s\n", input);
}

