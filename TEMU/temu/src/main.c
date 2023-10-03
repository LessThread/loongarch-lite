
void init_monitor(int, char *[]);
void restart();
void ui_mainloop();

int main(int argc, char *argv[]) {

	//带参数的监视器初始化
	init_monitor(argc, argv);

	//模拟启动计算机系统
	restart();

	//循环取指的UI界面
	ui_mainloop();

	return 0;
}
