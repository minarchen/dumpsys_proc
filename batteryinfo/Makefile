batteryinfo: y.tab.c lex.yy.c node.c user.c
	#gcc y.tab.c lex.yy.c -o batteryinfo -lfl
	gcc -g y.tab.c lex.yy.c node.c user.c -o batteryinfo
y.tab.c: batteryinfo.y
	bison -y -d -g --verbose batteryinfo.y
lex.yy.c: batteryinfo.l 
	lex batteryinfo.l
clean:
	rm -f lex.yy.c y.output y.tab.c y.tab.h y.vcg
