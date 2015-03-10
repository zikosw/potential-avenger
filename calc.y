%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#define YYSTYPE long long int

long long top;
int size;
long long r[11];
extern char* yytext;

%}

%token ACC TOP SIZE REGISTER SHOW COPY TO
%token PUSH POP

%token BINARY HEX NUMBER
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
  | val END 
  | Expression END { printf("Result: %lld\n", $1); }
  | SHOW val END { printf("Result: %lld\n",$2); }
  | Memop END 
  | others END { printf("syntax error"); }
;

Expression:
  NUMBER { $$=$1; r[10]=$$; }
    | Expression PLUS Expression { $$=$1+$3; r[10]=$$; }
    | Expression MINUS Expression { $$=$1-$3; r[10]=$$; }
    | Expression TIMES Expression { $$=$1*$3; r[10]=$$; }
    | Expression DIVIDE Expression { if($3==0){ yyerror("Divide by Zero"); YYERROR; } $$=$1/$3; r[10]=$$; }
    | Expression MOD Expression { $$=$1%$3; r[10]=$$; }
    | Expression AND Expression { $$=(int)$1&(int)$3; r[10]=$$; }
    | Expression OR Expression { $$=(int)$1|(int)$3; r[10]=$$; }
    | NOT Expression { $$=~$2; r[10]=$$; }
    | MINUS Expression %prec NEG { r[10]=-$2; r[10]=$$; }
    | Expression POWER Expression { $$=pow($1,$3); r[10]=$$; }
    | LEFT Expression RIGHT { $$=$2; r[10]=$$; }
    | ALEFT Expression ARIGHT { $$=$2; r[10]=$$; }
    | BLEFT Expression BRIGHT { $$=$2; r[10]=$$; }
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


%%

int yyerror(char *s) {
   printf("%s", s);
}

int main() {
  yyparse();
}
