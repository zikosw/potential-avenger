%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#define YYSTYPE long long int

long long r[11];
extern char* yytext;
int flag = 0;
struct stack
{
    long long int *stk;
    long long int top;
    long long int maxsize;
};
typedef struct stack STACK;
STACK st;

void create(STACK *s){
    (*s).top = -1;
    (*s).maxsize = 100;
    (*s).stk = (long long int *) malloc(((*s).maxsize)*sizeof(long long int));
}

void copy(STACK *s){
    long long int *tmp;
    long long int i;
    (*s).maxsize *= 2;
    tmp = (long long int *) malloc(((*s).maxsize)*sizeof(long long int));
    for (i = (*s).top; i >= 0; i--){
        tmp[i] = (*s).stk[i];
    }
    free((*s).stk);
    (*s).stk = tmp;
}

long long int size(STACK *s){
    long long int size = ((*s).top)+1;
    //printf ("%llu\n", size);
    return size;
}

void push (STACK *s,const long long int num){
    if ((*s).top != ((*s).maxsize - 1)){
        (*s).stk[++((*s).top)]= num;
    }else{
        copy(&(*s));
        (*s).stk[++((*s).top)]= num;
    }
}

void pop (STACK *s,int reg){
    long long int local_size = size(s);
    if ( local_size > (long long int)0){
       //printf ("poped element is = %llu\n",(*s).stk[(*s).top]);
        r[reg] = (*s).stk[(*s).top--];
    }else{
        yyerror();
        flag = 0;
    }
}

void display (STACK *s){
    long long int i;
    if ((*s).top == -1){
        //printf ("Stack is empty\n");
    }else{
       /* printf ("\n The status of the stack is \n");
        for (i = (*s).top; i >= 0; i--){
            printf ("%llu\n", (*s).stk[i]);
        } */
    }
    printf ("\n");
}


long long int top (STACK *s){
    if ((*s).top != - 1){
       //printf ("%llu\n", (*s).stk[(*s).top]);
        return (*s).stk[(*s).top];
    }else{
        yyerror();
        flag = 0;
        return (*s).top;
    }
}

%}

%token ACC TOP SIZE REGISTER SHOW COPY TO
%token PUSH POP

%token NUMBER
%token PLUS MINUS TIMES DIVIDE MOD POWER
%token LEFT RIGHT ALEFT ARIGHT BLEFT BRIGHT
%token END OTHERS


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
  END { } 
  | val END { yyerror(); }
  | Expression END { printf("Result: %lld\n", $1); }
  | SHOW val END { printf("Result: %lld\n",$2); }
  | Memop END 
  | error END { yyerror(); flag = 0; }
;

Expression:
  NUMBER { $$=$1; r[10]=$$; }
    | Expression PLUS Expression { $$=$1+$3; r[10]=$$; }
    | Expression MINUS Expression { $$=$1-$3; r[10]=$$; }
    | Expression TIMES Expression { $$=$1*$3; r[10]=$$; }
    | Expression DIVIDE Expression { if($3==0){ yyerror(); } $$=$1/$3; r[10]=$$; }
    | Expression MOD Expression { $$=$1%$3; r[10]=$$; }
    | Expression AND Expression { $$=(int)$1&(int)$3; r[10]=$$; }
    | Expression OR Expression { $$=(int)$1|(int)$3; r[10]=$$; }
    | NOT Expression { $$=~$2; r[10]=$$; }
    | MINUS Expression %prec NEG { $$=-$2; r[10]=$$; }
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
  | PUSH val { push(&st,$2); }
  | POP reg { pop(&st,$2); }
;

reg:
  REGISTER { $$=(int)yylval; }
  | ACC { $$=10; }
;

val:
  REGISTER { $$=r[(int)yylval]; }
  | ACC { $$=r[10]; }
  | TOP { $$=top(&st); } 
  | SIZE  { $$=size(&st); }
;


%%

int yyerror() {
  if (flag == 0){
   printf("ERROR! \n");
   flag = 1;
  }
}

int main() {
  create(&st);
  yyparse();
}
