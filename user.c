#include <stdio.h>
#include "node.h"

#define TRUE 1
#define FALSE 1

int first = TRUE;
int wake_duration = 0;
int wake_times = 0;
int service_starts = 0;
int service_launches = 0;
int usr_time = 0;
int krn_time = 0;
int wakeups = 0;

void begin() {
	printf("PID \tRECV \tSEND \tUSER_INTER \tWAKE_DUR \t#TIMES_ACQ \t#WAKEUPS \tSVC_STARTS \tSVC_LAUNCHES \tUSR \tSYS\n");
}

void end() { }

void visit_pid(pid_data* data) {
	if(!first) {
		printf(" \t%d \t%d \t%d \t%d \t%d \t%d \t%d\n", wake_duration , wake_times , wakeups, service_starts ,
			service_launches , usr_time , krn_time );
		first = FALSE;
	}
	printf("%d \t%d \t%d \t%d", data->pid, data->net_recv, data->net_sent, data->user_interactions);
	wakeups = 0;
	wake_duration = 0;
	wake_times = 0;
	service_starts = 0;
	service_launches = 0;
	usr_time = 0;
	krn_time = 0;
}
void visit_wakelock(wakelock_data* data) {
	wake_duration += data->duration;
	wake_times += data->times;
}
void visit_proc(proc_data* data) {
	usr_time += data->usr;
	krn_time += data->krn;
}
void visit_apk(apk_data* data) {
	wakeups += data->wakeups;
}
void visit_service(service_data* data) {
	service_starts += data->start;
	service_launches += data->launch;
}
