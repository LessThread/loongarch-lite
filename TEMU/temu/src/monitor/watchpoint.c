#include "watchpoint.h"
#include "expr.h"

#define NR_WP 32

static WP wp_pool[NR_WP];
static WP *head, *free_;

void init_wp_pool() {
	//初始化这个链表
	int i;
	for(i = 0; i < NR_WP; i ++) {
		wp_pool[i].NO = i;
		wp_pool[i].next = &wp_pool[i + 1];
	}
	wp_pool[NR_WP - 1].next = NULL; //末元素的指针指空

	head = NULL;
	free_ = wp_pool;
}

/* TODO: Implement the functionality of watchpoint */
WP* new_wp(){
	if(free_ == NULL){
		printf("No free wp.\n");
		assert(0);
	}
	else{
		WP* item = free_;
		free_ = item->next;
		item->next = head;
		head  = item;

		int free_num = 0;
		for(WP* ptr = free_;(ptr->next)!=NULL;ptr=ptr->next){
			free_num++;
		}
		printf("Left free WP: %d\n",free_num);
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
