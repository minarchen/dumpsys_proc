%{
    #include "y.tab.h"
    #include <stdlib.h>
    #include <string.h>
    void yyerror(char *);
		void lprintf(char *);
%}
/*([0-9]+m[ ])?([0-9]+s[ ])?[0-9]+ms	{lprintf("DURATION"); return DURATION; }*/

%%

Network: 					{ lprintf("NETWORK"); return NETWORK; } 
received,					{ lprintf("RECEIVED"); return RECEIVED; }
sent							{ lprintf("SENT"); return SENT; }

User[ ]activity: 	{ lprintf("USER"); return USER; }

Wake[ ]lock 				{ lprintf("WAKELOCK"); return WAKELOCK; }
TOTAL[ ]wake:			{ lprintf("TOTAL_WAKE"); return TOTAL_WAKE; }
times							{ lprintf("TIMES"); return TIMES; }
partial|full			{ lprintf("WL_TYPE"); return WL_TYPE; }
realtime					{ lprintf("REALTIME"); return REALTIME; }

Sensor[ ][0-9]:|Vibrator:   	{ lprintf("SENSOR"); return SENSOR; } 
\(not[ ]used\)			{lprintf("NOT_USED"); return NOT_USED; }

Proc						{	lprintf("PROC"); return PROC; }
CPU:						{	lprintf("CPU"); return CPU; }
usr							{	lprintf("USR"); return USR; }
krn							{	lprintf("KRN"); return KRN; }
proc[ ]starts		{	lprintf("PROC_STARTS"); return PROC_STARTS; }

Apk						{	lprintf("APK"); return APK; }

wakeup[ ]alarms	{lprintf("WAKEUP_ALARMS"); return WAKEUP_ALARMS;}

Service				{lprintf("SERVICE"); return SERVICE;}
Created[ ]for:	{lprintf("CREATED_FOR"); return CREATED_FOR;}
uptime				{lprintf("UPTIME"); return UPTIME; }
Starts:				{lprintf("START"); return START; }
launches:	{lprintf("LAUNCHES"); return LAUNCHES; }
\(nothing[ ]executed\) 	{lprintf("NOTHING_EXEC"); return NOTHING_EXEC; }

MB							{lprintf("MB"); return MB;}
KB							{lprintf("KB"); return KB;}
B								{lprintf("B"); return B;}

ms							{lprintf("MS"); return MS;}
s								{lprintf("S"); return S;}
m								{lprintf("M"); return M;}
h								{lprintf("H"); return H;}


[A-Za-z_\-\/\*\{][A-Za-z0-9_\-\/:\.\*\$=@]*[A-Za-z0-9_\-\/\*/}]	{ lprintf("ID "); 
															lprintf(yytext); 
															yylval.strval = strdup(yytext); 
															return ID; }

[0-9]+			{ lprintf(yytext); yylval.intval = atoi(yytext); return INT; }

[+();,#:\.]    { lprintf(yytext); return *yytext; }

[\r\n]+						{	/* skip new line */ }

[ \t]       ;       /* skip whitespace */

.           yyerror(yytext);

%%

int yywrap(void) {
    return 1;
}
