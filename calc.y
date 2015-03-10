%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#define YYSTYPE double

double top;
int size;
double r[11];
extern char* yytext;

%}

%token ACC TOP SIZE REGISTER SHOW COPY TO
%token PUSH POP

%token NUMBER
%token OTHERS
%token PLUS MINUS TIMES DIVIDE MOD POWER
%token LEFT RIGHT ALEFT ARIGHT BLEFT BRIGHT
%token END

%left AND OR NOT
%left PLUS MINUS
%left TIMES DIVIDE
%left NEG
%right POWER

%start Input


%%

Input:
         
     | Input Line
;

Line:
  END
  | val END { }
  | Expression END { printf("Result: %f\n", $1); }
  | SHOW val END { printf("Result: %f\n",$2); }
  | Memop END { }
  | others END { printf("input error"); }
;

Expression:
  NUMBER { r[10]=$1; $$=r[10]; }
    | Expression PLUS Expression { r[10]=$1+$3; $$=r[10]; }
    | Expression MINUS Expression { r[10]=$1-$3; $$=r[10]; }
    | Expression TIMES Expression { r[10]=$1*$3; $$=r[10]; }
    | Expression DIVIDE Expression { r[10]=$1/$3; $$=r[10]; }
    | Expression MOD Expression { r[10]=fmod($1,$3); $$=r[10]; }
    | MINUS Expression %prec NEG { r[10]=-$2; $$=r[10]; }
    | Expression POWER Expression { r[10]=pow($1,$3); $$=r[10]; }
    | LEFT Expression RIGHT { r[10]=$2; $$=r[10]; }
    | ALEFT Expression ARIGHT { r[10]=$2; $$=r[10]; }
    | BLEFT Expression BRIGHT { r[10]=$2; $$=r[10]; }
    | val { $$=$1; }
;

Memop:
  COPY val TO reg {
      r[(int)$4]=$2;
    }
  | PUSH reg {}
  | POP reg {}
;

reg:
  REGISTER { $$=(int)yylval; }
  | ACC { $$=10; }
;

val:
  REGISTER { $$=r[(int)yylval]; }
  | ACC { $$=r[10]; }
  | TOP { $$=top; }
  | SIZE  { $$=size; }
;

others:
  OTHERS { }
;

%%

int yyerror(char *s) {
   printf("%s at expression %s\n", s, yytext);
}

int main() {
  yyparse();
}
