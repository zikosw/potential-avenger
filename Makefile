calc: calc.y calc.lex
	cp calc.lex calc.lex.bak
	bison -d calc.y
	flex  -o calc.lex.c calc.lex
	gcc  -o calc calc.lex.c calc.tab.c -lfl -lm 
	mv calc.lex.bak calc.lex
clean:
	$(RM) calc.lex.c calc.tab.c calc.tab.h calc
