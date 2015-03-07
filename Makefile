dtoj: y.tab.c lex.yy.c node.c user.c
	#gcc y.tab.c lex.yy.c -o dtoj -lfl
	gcc -g y.tab.c lex.yy.c node.c user.c -o dtoj
y.tab.c: dtoj.y
	bison -y -d -g --verbose dtoj.y
lex.yy.c: dtoj.l 
	lex dtoj.l
clean:
	rm -f lex.yy.c y.output y.tab.c y.tab.h y.vcg
