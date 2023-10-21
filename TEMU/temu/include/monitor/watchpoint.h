#ifndef __WATCHPOINT_H__
#define __WATCHPOINT_H__

#include "common.h"
#include <stdlib.h>

typedef struct watchpoint {
	int NO;
	struct watchpoint *next;
	char* expr ;
	int result;

} WP;

void WatcherExpHook();

#endif
