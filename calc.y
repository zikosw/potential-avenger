%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#define YYSTYPE double
%}

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
;

Expression:
  NUMBER { $$=$1; }
    | Expression PLUS Expression { $$=$1+$3; }
    | Expression MINUS Expression { $$=$1-$3; }
    | Expression TIMES Expression { $$=$1*$3; }
    | Expression DIVIDE Expression { $$=$1/$3; }
    | Expression MOD Expression { $$=fmod($1,$3); }
    | MINUS Expression %prec NEG { $$=-$2; }
    | Expression POWER Expression { $$=pow($1,$3); }
    | LEFT Expression RIGHT { $$=$2; }
;

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
