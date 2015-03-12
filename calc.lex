%{
#define YYSTYPE long long int
#include "calc.tab.h"
#include <stdlib.h>
#include <string.h>
%}

white [ \t]+
digit [0-9]
integer {digit}+
exponent [eE][+-]?{integer}
real {integer}("."{integer})?{exponent}?

%%

{white} { }

[01]+b {

  int dec=0,i=0;
  for(i=0;i<strlen(yytext)-1;i++){
    dec=dec*2+(yytext[i]-'0');
  }
  yylval=dec;
  return NUMBER;
}

[0-9a-fA-F]+h {

  int dec=0,i=0,val=0;
  for(i=0;i<strlen(yytext)-1;i++){
    if(yytext[i]<='9')
      val=yytext[i]-'0';
    else if(yytext[i]<='Z')
      val=yytext[i]-'A'+10;
    else
      val=yytext[i]-'a'+10;
    dec=dec*16+val;
  }
  yylval=dec;
  return NUMBER;
}

{real} {
  sscanf(yytext,"%llu",&yylval);
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
  yylval=yytext[2]-'0';
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
