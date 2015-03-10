%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#define YYSTYPE double

double acc;
double top;
int size;
double r[10];
%}

%token ACC TOP SIZE REGISTER SHOW COPY TO
%token PUSH POP

%token NUMBER
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
     | Expression END { printf("Result: %f\n", $1); }
     | Memop END { printf("Result: %f\n", $1); }
     | reg END { printf("Result: %f\n", $1); }
;

Expression:
  NUMBER { acc=$1; $$=acc; }
    | Expression PLUS Expression { acc=$1+$3; $$=acc; }
    | Expression MINUS Expression { acc=$1-$3; $$=acc; }
    | Expression TIMES Expression { acc=$1*$3; $$=acc; }
    | Expression DIVIDE Expression { acc=$1/$3; $$=acc; }
    | Expression MOD Expression { acc=fmod($1,$3); $$=acc; }
    | MINUS Expression %prec NEG { acc=-$2; $$=acc; }
    | Expression POWER Expression { acc=pow($1,$3); $$=acc; }
    | LEFT Expression RIGHT { acc=$2; $$=acc; }
    | ALEFT Expression ARIGHT { acc=$2; $$=acc; }
    | BLEFT Expression BRIGHT { acc=$2; $$=acc; }
;

Memop:
  | SHOW reg {}
  | COPY val TO reg {
      r[$4]=r[$2];
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
  | ACC { $$=acc; }
  | TOP { $$=top; }
  | SIZE  { $$=size; }

%%

int yyerror(char *s) {
  printf("%s\n", s);
}

int main() {
  if (yyparse())
     fprintf(stderr, "Successful parsing.\n");
  else
     fprintf(stderr, "error found.\n");
}
