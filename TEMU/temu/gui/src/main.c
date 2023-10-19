
#include "../inc/core.h"
#include "../inc/public.h"
#include "../inc/command.h"

int main()
{   
    memset(input, 0, sizeof(input));
    inputIndex = 0;
    number = 0;

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
    
    //getRespondFormCore();
    memset(output, 0, sizeof(output));


    while (1)
    {
        getCommand();
        execCommand();
    }
    
}