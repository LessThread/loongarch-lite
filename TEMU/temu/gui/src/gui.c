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
    mvwprintw(icon_win, 12, 1, " 'exit': Exit the gui");
    mvwprintw(icon_win, 13, 1, "  'n'  : Continue to execute the next code step");
    box(icon_win, 0, 0);
    wrefresh(icon_win);

    // PC显示窗口
    pc_win = newwin(5, 20, 2, 70);
    mvwprintw(pc_win, 1, 1, "$PC:0x800000014");
    mvwprintw(pc_win, 2, 1, "");
    box(pc_win, 0, 0);
    wrefresh(pc_win);

    // 总指令数窗口
    win_1 = newwin(5, 20, 9, 70);
    mvwprintw(win_1, 1, 1, "num:5");
    box(win_1, 0, 0);
    wrefresh(win_1);

    // 显示窗口2
    initscr();
    start_color();
    init_pair(1, COLOR_YELLOW, COLOR_MAGENTA);

    WINDOW* win_2 = newwin(5, 20, 17, 70);
    mvwprintw(win_2, 1,1, "Program status:");

    attron(COLOR_PAIR(1));
    mvwprintw(win_2, 2,1, "Running ");
    box(win_2, 0, 0);
    wrefresh(win_2);

    

    //汇编历史显示窗口
    history_win = newwin(20, 25, 2, 95);
    mvwprintw(history_win, 1, 1, "history:");
    mvwprintw(history_win, 3, 1, "1:n");
    mvwprintw(history_win, 4, 1, "2:n");
    mvwprintw(history_win, 5, 1, "3:n");
    mvwprintw(history_win, 6, 1, "4:n");
    box(history_win, 0, 0);
    wrefresh(history_win);

    //主窗口
    main_win = newwin(20, 118, 23, 2);
    box(main_win, 0, 0);
    mvwprintw(main_win, 1,1, "Output:");
    mvwprintw(main_win, 2,1, "  $zero    0x00000000     ra    0x00000000    $tp    0x00000000    $sp    0x00000000     a0    0x00000000");
    mvwprintw(main_win, 3,1, "  $a1      0x00000000    $a2    0x00000000    $a3    0x00000000    $a4    0x00000000    $a5    0x00000000");
    mvwprintw(main_win, 4,1, "  $a6      0x00000000    $a7    0x00000000    $t0    0x00000002    $t1    0x0000000a    $t2    0x00000001");
    mvwprintw(main_win, 5,1, "  $t3      0x00000002    $t4    0x00000008    $t5    0x00000002    $t6    0x00000000    $t7    0x0000001b");
    mvwprintw(main_win, 6,1, "  $t8      0x0000c000     $x    0x00000000    $fp    0x00000000    $s0    0x8000c028    $s1    0x00000000");
    mvwprintw(main_win, 7,1, "  $s2      0x00000000    $s3    0x00000024    $s4    0x00000000    $s5    0x00000000    $s6    0x00000000");
    mvwprintw(main_win, 8,1, "  $s7      0x00000000    $s8    0x00000000    ");

    mvwprintw(main_win, 10,1, " 02 80 04 0c         addi.w  $t0,  $zero,  0x000");
    mvwprintw(main_win, 11,1, " 02 80 28 0d         addi.w  $t1,  $zero,  0x000");
    mvwprintw(main_win, 12,1, " 00 10 31 8c         add.w  $t0,  $t0,  $t0");
    mvwprintw(main_win, 13,1, " 00 12 b5 8e         sltu  $t2,  $t0,  $t1");
    wrefresh(main_win);

    // 在命令行下方显示用户输入
    mvprintw(LINES - 1, 0, "(TEMU GUI) ");
    refresh();

    for(int i=0;i<80;i++){input[i]='\0';}

}
