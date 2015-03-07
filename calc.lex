%{
#define YYSTYPE double
#include "calc.tab.h"
#include <stdlib.h>
%}

white [ \t]+
digit [0-9]
integer {digit}+
exponent [eE][+-]?{integer}
real {integer}("."{integer})?{exponent}?

%%

{white} { }
{real} { yylval=atof(yytext);
 return NUMBER;
}

"AND" return AND;
"OR" return OR;
"NOT" return NOT;

"+" return PLUS;
"-" return MINUS;
"*" return TIMES;
"/" return DIVIDE;
"\\" return MOD;
"^" return POWER;

"(" return LEFT;
")" return RIGHT;
"[" return ALEFT;
"]" return ARIGHT;
"{" return BLEFT;
"}" return BRIGHT;

"\n" return END;
