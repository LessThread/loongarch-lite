#include "../inc/gui.h"

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
	
    " _______ ______ __  __ _    _    _____ _    _ _____ \n"
   " |__   __|  ____|  \\/  | |  | |  / ____| |  | |_   _|\n"
      "    | |  | |__  | \\  / | |  | | | |  __| |  | | | |  \n"
      "    | |  |  __| | |\\/| | |  | | | | |_ | |  | | | |  \n"
      "    | |  | |____| |  | | |__| | | |__| | |__| |_| |_ \n"
      "    |_|  |______|_|  |_|\\____/   \\_____|\\____/|_____|\n"
		;


    // 创建一个窗口
    WINDOW* icon_win = newwin(20, 60, 2, 2);
    mvwprintw(icon_win, 1, 1, hello);
    mvwprintw(icon_win, 10, 1, "Welcome TEMU GUI\n");
    mvwprintw(icon_win, 11, 1, "Enter 'exit' to exit the gui");
    box(icon_win, 0, 0);
    wrefresh(icon_win);

    // PC显示窗口
    WINDOW* pc_win = newwin(5, 20, 2, 70);
    mvwprintw(pc_win, 1, 1, "$PC:");
    box(pc_win, 0, 0);
    wrefresh(pc_win);

    // 总指令数窗口
    win_1 = newwin(5, 20, 9, 70);
    mvwprintw(win_1, 1, 1, "num:");
    box(win_1, 0, 0);
    wrefresh(win_1);

    // 显示窗口2
    WINDOW* win_2 = newwin(5, 20, 17, 70);
    box(win_2, 0, 0);
    wrefresh(win_2);

    //汇编历史显示窗口
    history_win = newwin(20, 25, 2, 95);
    mvwprintw(history_win, 1, 1, "history:");
    box(history_win, 0, 0);
    wrefresh(history_win);

    //主窗口
    main_win = newwin(20, 118, 23, 2);
    mvprintw(main_win, 1,1, "Output:");
    box(main_win, 0, 0);
    wrefresh(main_win);

    // 在命令行下方显示用户输入
    mvprintw(LINES - 1, 0, "(TEMU GUI) ");
    refresh();

    for(int i=0;i<80;i++){input[i]='\0';}

}
