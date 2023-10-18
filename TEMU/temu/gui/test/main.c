#include <stdio.h>

char input[80];

int main(int argc, char const *argv[])
{
    system("stty -icanon");
    while (1)
    {
        printf("\nmain-wait:");
        char c =getchar();
        putchar(c);
    }
    return 0;
}
