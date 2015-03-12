%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#define YYSTYPE long long int


long long r[11];
extern char* yytext;
/***
 * STACK IMPLEMENTATION   
 ***/
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
        r[reg] = (*s).stk[(*s).top--];
    }else{
        yyerror();
    }
}


long long int top (STACK *s){
    if ((*s).top != - 1){
        return (*s).stk[(*s).top];
    }else{
        yyerror();
        return (*s).top;
    }
}

%}
//token declaration 
%token ACC TOP SIZE REGISTER SHOW COPY TO
%token PUSH POP

%token NUMBER
%token PLUS MINUS TIMES DIVIDE MOD POWER
%token LEFT RIGHT ALEFT ARIGHT BLEFT BRIGHT
%token END OTHERS

//operator token declaration 
%left AND OR NOT
%left PLUS MINUS
%left TIMES DIVIDE
%left NEG
%right POWER

//User input token
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
  | OTHERS END { yyerror(); }
  | error END { }
;

/*** 
 * Expression grammar match string pattern and do code in curly bracket
 * $1 = first tokens , $2 = second tokens ,so $N = N tokens ....
 * $$ = answer ... 
 * r[10] is register number 10 ,which defined as accumulator.
 ***/
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

/***
 * assign value to register number = reg  
 ***/
Memop:
  COPY val TO reg {
      r[(int)$4]=$2;
    }
  | PUSH val { push(&st,$2); }
  | POP reg { pop(&st,$2); }
;

/***
 * register number    
 ***/
reg:
  REGISTER { $$=(int)yylval; }
  | ACC { $$=10; }
;

/***
 * Every value is stored in register array,so we get it from register array.   
 ***/
val:
  REGISTER { $$=r[(int)yylval]; }
  | ACC { $$=r[10]; }
  | TOP { $$=top(&st); } 
  | SIZE  { $$=size(&st); }
;


%%
/***
 * Error handler 
 ***/
int yyerror() {
   printf("ERROR! \n");
}

int main() {
  create(&st);
  yyparse();
}