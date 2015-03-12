%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#define YYSTYPE long long int

long long r[11];
extern char* yytext;
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

void push (STACK *s,const long long int num){
    if ((*s).top != ((*s).maxsize - 1)){
        (*s).stk[++((*s).top)]= num;
    }else{
        copy(&(*s));
        (*s).stk[++((*s).top)]= num;
    }
}

long long int pop (STACK *s){
    if ((*s).top != - 1){
       //printf ("poped element is = %llu\n",(*s).stk[(*s).top]);
        return (*s).stk[(*s).top--];
    }else{
        //printf ("Stack is Empty\n");
        return ((*s).top);
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
        //printf ("Stack is Empty\n");
        return (*s).top;
    }
}

long long int size(STACK *s){
    long long int size = ((*s).top)+1;
    //printf ("%llu\n", size);
    return size;
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
  END
  | val END { printf("syntax error"); }
  | Expression END { printf("Result: %lld\n", $1); }
  | SHOW val END { printf("Result: %lld\n",$2); }
  | Memop END 
  | OTHERS END { printf("syntax error"); }
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
  | POP reg { r[$2]=pop(&st); }
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

int yyerror(char *s) {
   printf("%s", s);
}

int main() {
  create(&st);
  yyparse();
}
