#define T_PID 0
#define T_NET 1
#define T_USER 2
#define T_WAKE 3 
#define T_PROC 4 
#define T_APK 5
#define T_SERVICE 6

struct node {
	int type;
	void* data;
	struct node* next;
};
typedef struct node node;

struct service_data {
	int id;
	int created;
	int start;
	int launch;
};
typedef struct service_data service_data;
extern node* new_service(int id, int created, int start, int launch);

struct apk_data {
	int wakeups;
	node* service_list;
};
typedef struct apk_data apk_data;
extern node* new_apk(int wakeups, node* service_list);

struct proc_data {
	int id;
	int usr;
	int krn;
};
typedef struct proc_data proc_data;
extern node* new_proc(int id, int usr, int krn);

struct wakelock_data {
	int id;
	int duration;
	int times;
};
typedef struct wakelock_data wakelock_data;
extern node* new_wakelock(int id, int duration, int times);

struct net_data {
	int recv;
	int sent;
};
typedef struct net_data net_data;
extern net_data* new_net_data(int recv, int sent);

struct pid_data {
	int pid;
	int net_recv;
	int net_sent;
	int user_interactions;
	node* wake_list;
	node* proc_list;
	node* apk_list;
};
typedef struct pid_data pid_data;
extern node* new_pid(int pid, net_data* net, int user_interactions, node* wake_list, node* proc_list, node* apk_list);

extern void begin();
extern void visit_pid(pid_data* data);
extern void visit_wakelock(wakelock_data* data);
extern void visit_proc(proc_data* data);
extern void visit_apk(apk_data* data);
extern void visit_service(service_data* data);
extern void end();

