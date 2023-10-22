#include "watchpoint.h"
#include "expr.h"

#define NR_WP 32

static WP wp_pool[NR_WP];
static WP *head, *free_;

enum { STOP, RUNNING, END };
extern int temu_state;

void init_wp_pool() {
	//初始化这个链表
	int i;
	for(i = 0; i < NR_WP; i ++) {
		wp_pool[i].NO = i;
		wp_pool[i].next = &wp_pool[i + 1];
		wp_pool[i].expr = (char*)malloc(sizeof(char)*32);
	}
	wp_pool[NR_WP - 1].next = NULL; //末元素的指针指空

	head = NULL;
	free_ = wp_pool;
}

/* TODO: Implement the functionality of watchpoint */
WP* new_wp()
{
	if(free_ == NULL)
	{
		printf("No free wp.\n");
		assert(0);
	}
	else
	{
		WP* item = free_;
		free_ = item->next;
		item->next = head;
		head  = item;

		int free_num = 0;
		for(WP* ptr = free_;(ptr->next)!=NULL;ptr=ptr->next){
			free_num++;
		}
		printf("Left free WP: %d\n",free_num-1);
		return head;
	}
}

void free_wp(WP *wp){
	if(head == NULL){
		printf("No WP in using.\n");
		return;
	}
	else{
		WP* tail = head;
		for(;tail->next != wp ;tail = tail->next){

		}
		tail->next = wp->next;
		wp->next = free_;
		free_ = wp;
		
	}
}


void delete_wp(int id){
	for(WP* seacher = head;seacher!=NULL;seacher=seacher->next){
		if(seacher->NO == id){
			free_wp(seacher);
			return;
		}
	}
	printf("Not a valid serial number.\n");
}

void display_watcher(){
	printf("using watcher:\n");
	for(WP* seacher = head;seacher!=NULL;seacher=seacher->next){
		printf(" No.%d\n",seacher->NO);
	}

	printf("free watcher:\n");
	for(WP* seacher = free_;seacher!=NULL;seacher=seacher->next){
		printf(" No.%d\n",seacher->NO);
	}
}


//每次执行完成后触发调试器的钩子,检查每个调试点的表达式求值
void WatcherExpHook()
{
	if(head != NULL){
		for(WP* wp=head;;){
			int res = callRegExp(wp->expr);
			// printf("Watcher NO.%d Exp %s: %d -> %d\n",wp->NO,wp->expr,wp->result,res);


			if(res != wp->result){
				printf("# Watcher NO.%d is hit.Exp %s: %d -> %d\n",wp->NO,wp->expr,wp->result,res);
				wp->result = res;
				temu_state = STOP;
			}


			if(wp->next!=NULL){
				wp = wp->next;
			}
			else{
				break;
			} 
		}

		
	}
}

//w $pc==-2147483644