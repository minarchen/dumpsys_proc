%{
  #include <stdio.h>
  #include "node.h"
  #include "user.h"
  int yylex(void);
  void yyerror(char *);
  void lprintf(char *);
  void yprintf(char *);

	#define MILLION 1000000
	#define TENTHOUSAND 10000
	#define THOUSAND 1000
	#define HUNDERED 100
%}

%union{ 
	int intval;
	char* strval;
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
%type <nodeval> total_wake_duration
%type <nodeval> proc_list
%type <nodeval> proc
%type <nodeval> apk_list
%type <nodeval> apk
%type <intval> alarm
%type <nodeval> service_list
%type <nodeval> service

%token <strval> ID
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

pid_list: pid pid_list 	{ if($1) {
														$$ = $1; $$->next = $2;
													} else {
														$$ = $2;
													}
												}
			| /*epsilon*/			{ $$ = NULL; }
			;

pid: '#'INT':' net user wakelock_list sensor_list proc_list apk_list	{ $$ = new_pid($2, $4, $5, $6, $8, $9 );
																														yprintf("pid ");}
		| NOTHING_EXEC	{ $$ = NULL; }
	;

net: NETWORK bytes RECEIVED bytes SENT	{ $$ = new_net_data($2, $4);
																					yprintf("net ");}
			| /* epsilon */										{ $$ = NULL; }
																					
			;

bytes: INT'.'INT MB			{$$ = $1 * MILLION + $3*TENTHOUSAND;
												yprintf("bytes");}
			| INT'.'INT KB		{$$ = $1 * THOUSAND + $3*HUNDERED;
												yprintf("bytes");}
			| INT B						{$$ = $1;
												yprintf("bytes");}
			;

user: USER activity			{ $$ = $2; yprintf("user ");}
			| /*epsilon*/			{ $$ = 0;}
			;
			
activity: activity',' INT ID		{ $$ = $1 + $3; yprintf("activity ");}
				| INT ID								{ $$ = $1; yprintf("activity ");}
				;

sensor_list: sensor sensor_list					{ yprintf("sensor_list "); }
					 | /* epsilon */							{ yprintf("sensor_list "); }
					 ;

sensor: SENSOR duration REALTIME '(' INT TIMES ')'				{ yprintf("sensor "); }
				| SENSOR NOT_USED				{ yprintf("sensor "); }
				;

wakelock_list: TOTAL_WAKE total_wake_duration REALTIME	{ $$ = $2; }
						| /* epsilon */													{ $$ = NULL; }
						;
total_wake_duration: duration WL_TYPE ',' total_wake_duration { $$ = $4; add_wakelock($1, $$); yprintf("total_wake_duration"); }
								| duration WL_TYPE { $$ = new_wakelock($1);  yprintf("total_wake_duration");}
								;


proc_list: proc proc_list		{ $$ = $1; $$->next = $2; }
		| /* epsilon */					{ $$ = NULL; }
		;

proc: PROC ID':' CPU duration USR '+' duration KRN	{ $$ = new_proc($2, $5, $8); yprintf("proc ");}
		| PROC ID':' CPU duration USR '+' duration KRN INT PROC_STARTS	{ $$ = new_proc($2, $5, $8); yprintf("proc ");}
		;

apk_list: apk apk_list			{ $$ = $1; $$->next = $2; }
		| /* epsilon */ 				{ $$ = NULL; }
		;

apk : APK ID':' alarm service_list			{ $$ = new_apk($2, $4, $5); yprintf("apk ");}
		;

alarm : INT WAKEUP_ALARMS		{ $$ = $1; yprintf("alarm ");}
			| /* epsilon */				{ $$ = 0; yprintf("alarm ");}
			;

service_list : service service_list	{ $1->next = $2; $$ = $1; }
				| NOTHING_EXEC							{ $$ = NULL; yprintf("NOTHING_EXEC ");}
				| /* epsilon */							{ $$ = NULL; }
				;

service : SERVICE ID':' CREATED_FOR duration UPTIME START INT',' LAUNCHES INT	{ 
																$$ = new_service($2, $5, $8, $11);
																yprintf("service ");
																																							}
				;

duration : INT M INT S INT MS	{ $$ = $1 * 60000 + $3*1000 + $5;
																yprintf("duration ");}
         | INT S INT MS				{ $$ = $1 * 1000 + $3;
				 												yprintf("duration ");}
         | INT MS							{ $$ = $1;
				 												yprintf("duration ");}
				;
%%

void yyerror(char *s) {
    fprintf(stderr, "Unknown char %s\n", s);
}

void yprintf(char *s) {
	if(0)
    fprintf(stdout, "yacc: %s\n", s);
}

void lprintf(char *s) {
	if(0)
    fprintf(stdout, "lex: %s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}

