%{
    #include "y.tab.h"
    #include <stdlib.h>
    void yyerror(char *);
		void myprintf(char *);
%}
/*([0-9]+m[ ])?([0-9]+s[ ])?[0-9]+ms	{myprintf("DURATION"); return DURATION; }*/

%%

Network: 					{ myprintf("NETWORK"); return NETWORK; } 
received,					{ myprintf("RECEIVED"); return RECEIVED; }
sent							{ myprintf("SENT"); return SENT; }

User[ ]activity: 	{ myprintf("USER"); return USER; }

Wake[ ]lock 				{ myprintf("WAKELOCK"); return WAKELOCK; }
TOTAL[ ]wake:			{ myprintf("TOTAL_WAKE"); return TOTAL_WAKE; }
times							{ myprintf("TIMES"); return TIMES; }
partial						{ myprintf("PARTIAL"); return PARTIAL; }
realtime					{ myprintf("REALTIME"); return REALTIME; }

Sensor[ ][0-9]:|Vibrator:   	{ myprintf("SENSOR"); return SENSOR; } 

Proc						{	myprintf("PROC"); return PROC; }
CPU:						{	myprintf("CPU"); return CPU; }
usr							{	myprintf("USR"); return USR; }
krn							{	myprintf("KRN"); return KRN; }

Apk						{	myprintf("APK"); return APK; }

wakeup[ ]alarms	{myprintf("WAKEUP_ALARMS"); return WAKEUP_ALARMS;}

Service				{myprintf("SERVICE"); return SERVICE;}
Created[ ]for:	{myprintf("CREATED_FOR"); return CREATED_FOR;}
uptime				{myprintf("UPTIME"); return UPTIME; }
Starts:				{myprintf("START"); return START; }
,[ ]+launches:	{myprintf("LAUNCHES"); return LAUNCHES; }
\(nothing[ ]executed\) 	{myprintf("NOTHING_EXEC"); return NOTHING_EXEC; }

MB							{myprintf("MB"); return MB;}
KB							{myprintf("KB"); return KB;}
B								{myprintf("B"); return B;}

ms							{myprintf("MS"); return MS;}
s								{myprintf("S"); return S;}
m								{myprintf("M"); return M;}


[A-Za-z_\-\/][A-Za-z0-9_\-\/:]*[A-Za-z0-9_\-\/]	{ myprintf("ID"); 
																											myprintf(yytext); 
																											yylval.intval = atoi(yytext); 
																											return ID; }

[0-9]+			{ myprintf(yytext); yylval.intval = atoi(yytext); return INT; }

[+();,#:\.]    { myprintf(yytext); return *yytext; }

[\r\n]+						{	/* skip new line */ }

[ \t]       ;       /* skip whitespace */

.           yyerror(yytext);

%%

int yywrap(void) {
    return 1;
}
