%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#define YYSTYPE double

double r[11];
struct stack
{
    int *stk;
    int top;
    int maxsize;
};
typedef struct stack STACK;
STACK st;

void create(STACK *s){
    (*s).top = -1;
    (*s).maxsize = 100;
    (*s).stk = (int *) malloc(((*s).maxsize)*sizeof(int));
}

void copy(STACK *s){
    int *tmp;
    int i;
    (*s).maxsize *= 2;
    tmp = (int *) malloc(((*s).maxsize)*sizeof(int));
    for (i = (*s).top; i >= 0; i--){
            printf("hell");
        tmp[i] = (*s).stk[i];
    }
    free((*s).stk);
    (*s).stk = tmp;
}

void push (STACK *s,const int num){
    if ((*s).top != ((*s).maxsize - 1)){
        (*s).stk[++((*s).top)]= num;
    }else{
        copy(&(*s));
        (*s).stk[++((*s).top)]= num;
    }
}

int pop (STACK *s){
    if ((*s).top != - 1){
        printf ("poped element is = %d\n",(*s).stk[(*s).top]);
        return (*s).stk[(*s).top--];
    }else{
        printf ("Stack is Empty\n");
        return ((*s).top);
    }
}

void display (STACK *s){
    int i;
    if ((*s).top == -1){
        printf ("Stack is empty\n");
    }else{
        printf ("\n The status of the stack is \n");
        for (i = (*s).top; i >= 0; i--){
            printf ("%d\n", (*s).stk[i]);
        }
    }
    printf ("\n");
}


int top (STACK *s){
    if ((*s).top != - 1){
        printf ("%d\n", (*s).stk[(*s).top]);
        return (*s).stk[(*s).top];
    }else{
        printf ("Stack is Empty\n");
        return (*s).top;
    }
}

int size(STACK *s){
    int size = ((*s).top)+1;
    printf ("%d\n", size);
    return size;
}

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
  | val END {}
  | Expression END { printf("Result: %f\n", $1); }
  | SHOW val END { printf("Result: %f\n",$2); }
  | Memop END { }
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
  | PUSH reg { push(&st,$2); }
  | POP reg { $$=pop(&st); }
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
  printf("%s\n", s);
}

int main() {
  create(&st);
  if (yyparse())
     fprintf(stderr, "Successful parsing.\n");
  else
     fprintf(stderr, "error found.\n");
}
