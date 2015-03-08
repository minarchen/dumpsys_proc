%{
  #include <stdio.h>
  #include "node.h"
  #include "user.h"
  int yylex(void);
  void yyerror(char *);
  void lprintf(char *);
  void myprintf(char *);

	#define MILLION 1000000
	#define TENTHOUSAND 10000
	#define THOUSAND 1000
	#define HUNDERED 100
%}

%union{ 
	int intval;
	struct node* nodeval;
	struct net_data* netval;
}

%type <intval> duration
%type <intval> bytes
%type <nodeval> pid_list
%type <nodeval> pid
%type <netval> net
%type <intval> user
%type <intval> activity
%type <nodeval> wakelock_list
%type <nodeval> wakelock
%type <nodeval> wakelock_duration
%type <nodeval> proc_list
%type <nodeval> proc
%type <nodeval> apk_list
%type <nodeval> apk
%type <intval> alarm
%type <nodeval> service_list
%type <nodeval> service

%token <intval> ID
%token <intval> INT

/* tokens related to network */
%token NETWORK
%token SENT
%token RECEIVED

/* tokens related to user */
%token USER

/* tokens related to wakelock */
%token WAKELOCK
%token TOTAL_WAKE
%token TIMES
%token WL_TYPE
%token REALTIME

/* tokens related to sensor */
%token SENSOR
%token NOT_USED

/* tokens related to proc */
%token PROC
%token CPU
%token USR
%token KRN
%token PROC_STARTS

/* tokens related to apk */
%token APK

/* tokens related to alarm */
%token WAKEUP_ALARMS

/* tokens related to service */
%token SERVICE
%token CREATED_FOR
%token UPTIME
%token START
%token LAUNCHES
%token NOTHING_EXEC

/* tokens related to bytes */
%token MB
%token KB
%token B

/* tokens related to duration */
%token M
%token S
%token MS

%%
batteryinfo: pid_list	{ printf("Successfully parsed !\n"); finish($1);}
				;

pid_list: pid pid_list 	{ if($1) {$$ = $1; $$->next = $2;} }
			| /*epsilon*/			{ $$ = NULL; }
			;

pid: '#'INT':' net user wakelock_list sensor_list proc_list apk_list	{ $$ = new_pid($2, $4, $5, $6, $8, $9 );
																														myprintf("pid ");}
		| NOTHING_EXEC	{ $$ = NULL; }
	;

net: NETWORK bytes RECEIVED bytes SENT	{ $$ = new_net_data($2, $4);
																					myprintf("net ");}
			| /* epsilon */										{ $$ = NULL; }
																					
			;

bytes: INT'.'INT MB			{$$ = $1 * MILLION + $3*TENTHOUSAND;
												myprintf("bytes");}
			| INT'.'INT KB		{$$ = $1 * THOUSAND + $3*HUNDERED;
												myprintf("bytes");}
			| INT B						{$$ = $1;
												myprintf("bytes");}
			;

user: USER activity			{ $$ = $2; myprintf("user ");}
			| /*epsilon*/			{ $$ = 0;}
			;
			
activity: activity',' INT ID		{ $$ = $1 + $3; myprintf("activity ");}
				| INT ID								{ $$ = $1; myprintf("activity ");}
				;

sensor_list: sensor sensor_list					{ myprintf("sensor_list "); }
					 | /* epsilon */							{ myprintf("sensor_list "); }
					 ;

sensor: SENSOR duration REALTIME '(' INT TIMES ')'				{ myprintf("sensor "); }
				| SENSOR NOT_USED				{ myprintf("sensor "); }
				;

wakelock_list: wakelock wakelock_list								{ $$ = $1; $$->next = $2; }
						| TOTAL_WAKE total_wake_duration REALTIME	{ $$ = NULL; }
						| /* epsilon */													{ $$ = NULL; }
						;

wakelock: WAKELOCK wakelock_name':' wakelock_duration REALTIME { $$ = $4; set_wl_id(0,$$);  myprintf("wakelock ");}
		;

wakelock_duration: duration WL_TYPE '('INT TIMES')' ',' wakelock_duration { $$ = $8; add_wakelock($1, $4, $$); myprintf("wakelock_duration"); }
								| duration WL_TYPE '('INT TIMES')' { $$ = new_wakelock($1, $4);  myprintf("wakelock_duration");}
								;

wakelock_name: ID wakelock_name
						| ID
						;

total_wake_duration: duration WL_TYPE ',' total_wake_duration 
								| duration WL_TYPE 
								;


proc_list: proc proc_list		{ $$ = $1; $$->next = $2; }
		| /* epsilon */					{ $$ = NULL; }
		;

proc: PROC ID':' CPU duration USR '+' duration KRN	{ $$ = new_proc($2, $5, $8); myprintf("proc ");}
		| PROC ID':' CPU duration USR '+' duration KRN INT PROC_STARTS	{ $$ = new_proc($2, $5, $8); myprintf("proc ");}
		;

apk_list: apk apk_list			{ $$ = $1; $$->next = $2; }
		| /* epsilon */ 				{ $$ = NULL; }
		;

apk : APK ID':' alarm service_list			{ $$ = new_apk($4, $5); myprintf("apk ");}
		;

alarm : INT WAKEUP_ALARMS		{ $$ = $1; myprintf("alarm ");}
			| /* epsilon */				{ $$ = 0; myprintf("alarm ");}
			;

service_list : service service_list	{ $1->next = $2; $$ = $1; }
				| NOTHING_EXEC							{ $$ = NULL; myprintf("NOTHING_EXEC ");}
				| /* epsilon */							{ $$ = NULL; }
				;

service : SERVICE ID':' CREATED_FOR duration UPTIME START INT',' LAUNCHES INT	{ 
																$$ = new_service($2, $5, $8, $11);
																myprintf("service ");
																																							}
				;

duration : INT M INT S INT MS	{ $$ = $1 * 60000 + $3*1000 + $5;
																myprintf("duration ");}
         | INT S INT MS				{ $$ = $1 * 1000 + $3;
				 												myprintf("duration ");}
         | INT MS							{ $$ = $1;
				 												myprintf("duration ");}
				;
%%

void yyerror(char *s) {
    fprintf(stderr, "Unknown char %s\n", s);
}

void myprintf(char *s) {
	if(1)
    fprintf(stdout, "%s\n", s);
}

void lprintf(char *s) {
	if(1)
    fprintf(stdout, "%s", s);
}

int main(void) {
    yyparse();
    return 0;
}

