#ifndef USER_H
#define USER_H
void finish(node* pid) {
	begin();
	while(pid) {
		pid_data* pdata = (pid_data*) pid->data;
		visit_pid(pdata);

		{
			node* wake = pdata->wake_list;
			while(wake) {
				visit_wakelock((wakelock_data*)wake->data);
				wake = wake->next;
			}
		}
		{
			node* proc = pdata->proc_list;
			while(proc) {
				visit_proc((proc_data*) proc->data);
				proc = proc->next;
			}
		}
		{
			node* apk = pdata->apk_list;
			while(apk) {
				apk_data* adata = (apk_data*) apk->data;
				visit_apk(adata);
				node* service = adata->service_list;
				while(service) {
					visit_service((service_data*) service->data);
					service = service->next;
				}
				apk = apk->next;
			}
		}
		pid = pid->next;
	}
	end();
}
#endif
