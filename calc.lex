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

"SHOW" return SHOW;
"COPY" return COPY;
"TO" return TO;

"PUSH" return PUSH;
"POP" return POP;

"$acc" return ACC;
"$top" return TOP;
"$size" return SIZE;
$r{digit} { 
 return REGISTER;
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
