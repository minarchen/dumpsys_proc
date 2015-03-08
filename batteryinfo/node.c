#include "node.h"
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

static void nprintf(char *s) {
	if(0)
    fprintf(stdout, "%s\n", s);
}

static node* new_node(int type) {
	node* n = (node*)malloc(sizeof(node));
	n->type = type;
	n->next = NULL;
	return n;
}

static void check_type (node* n, int type) {
	assert(n == NULL || n->type == type);
}

node* new_service(char* id, int created, int start, int launch) {
	node* n = new_node(T_SERVICE);
	service_data* data = (service_data*) malloc (sizeof(service_data));
	data->service_id = id;
	data->created = created;
	data->start = start;
	data->launch = launch;
	n->data = (void*) data;
	return n;
}

node* new_apk(char* apkid, int wakeups, node* service_list) {
	node* n = new_node(T_APK);
	apk_data* data = (apk_data*) malloc (sizeof(apk_data));
	data->apkid = apkid;
	data->wakeups = wakeups;
	check_type(service_list, T_SERVICE);
	data->service_list = service_list;
	nprintf("new apk ");
	nprintf(data->apkid);
	n->data = (void*) data;
	return n;
}

node* new_proc(char* procid, int usr, int krn) {
	node* n = new_node(T_PROC);
	proc_data* data = (proc_data*) malloc (sizeof(proc_data));
	data->procid = procid;
	data->usr = usr;
	data->krn = krn;
	n->data = (void*) data;
	nprintf("new proc ");
	nprintf(data->procid);
	return n;
}

node* new_wakelock(int duration) {
	node* n = new_node(T_WAKE);
	wakelock_data* data = (wakelock_data*) malloc (sizeof(wakelock_data));
	data->duration = duration;
	n->data = (void*) data;
	return n;
}

void add_wakelock(int duration, node* wakelock_node) {
	check_type(wakelock_node, T_WAKE);
	wakelock_data* data = (wakelock_data*) wakelock_node -> data;
	data->duration += duration;
}

net_data* new_net_data(int recv, int sent) {
	net_data* data = (net_data*) malloc (sizeof(net_data));
	data->recv = recv;
	data->sent = sent;
	return data;
}

node* new_pid(int pid, net_data* net, int user_interactions, node* wake_list, node* proc_list, node* apk_list) {
	node* n = new_node(T_PID);
	pid_data* data = (pid_data*) malloc (sizeof(pid_data));

	data->pid = pid;
	data->name = (char*) malloc(5*sizeof(char));
	sprintf(data->name, "%d", pid);
	if(net) {
		data->net_recv = net->recv;
		data->net_sent = net->sent;
	} else {
		data->net_recv = 0;
		data->net_sent = 0;
	}

	data->user_interactions = user_interactions;
	check_type(wake_list, T_WAKE);
	data->wake_list = wake_list;

	check_type(proc_list, T_PROC);
	data->proc_list = proc_list;
	if(proc_list) {
		// Set the name as first proc
		proc_data* pdata = (proc_data*) proc_list->data;
		data->name = pdata->procid;
	}

	check_type(apk_list, T_APK);
	data->apk_list = apk_list;
	if(apk_list) {
		// Set the name as first apk
		apk_data* adata = (apk_data*) apk_list->data;
		data->name = adata->apkid;
	}

	n->data = (void*) data;
	nprintf("new pid ");
	nprintf(data->name);
	return n;
}

