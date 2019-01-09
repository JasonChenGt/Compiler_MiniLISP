%{
#include "smli.tab.h"
%}
letter          [a-z]
digit           [0-9]
separator       "\t"|"\n"|"\r"|" "
number          0|[1-9]{digit}*|\-[1-9]{digit}*
variable        {letter}({letter}|{digit}|"-")*
bool_val        #t|#f
%%
\/|\+|\-|\*|\>|\<|\=    { /*printf("numerical_operators : %s\n",yytext);*/ return(yytext[0]); }
"mod"                   { /*printf("numerical_operators : %s\n",yytext);*/ return(MOD); }
"and"                   { /*printf("logical_operators : %s\n", yytext);*/ return(AND); }
"or"                    { /*printf("logical_operators : %s\n", yytext);*/ return(OR); }
"not"                   { /*printf("logical_operators : %s\n", yytext);*/ return(NOT); }
"define"                { /*printf("define : %s\n", yytext);*/ return(DEFINE); }
"if"                    { /*printf("if : %s\n", yytext);*/ return(IF); }
"lambda"                { /*printf("lambda : %s\n", yytext);*/ return(LAMBDA); }
"print-bool"            { /*printf("print : %s\n", yytext);*/ return(PRINT_BOOL); }
"print-num"             { /*printf("print : %s\n", yytext);*/ return(PRINT_NUM); }
{variable}              { /*printf("VARIABLE : %s\n", yytext);*/ yylval.string = strdup(yytext); return(VARIABLE); }
{bool_val}              { /*printf("BOOL_VAL : %s\n", yytext);*/ yylval.string = strdup(yytext); return(BOOL_VAL); }
{number}                { /*printf("NUMBER : %s\n", yytext);*/ yylval.number = atoi(yytext); return(NUMBER); }
\(                      { /*printf("parenthesis : %s\n", yytext);*/ return(yytext[0]); }
\)                      { /*printf("parenthesis : %s\n", yytext);*/ return(yytext[0]); }
{separator}
%%
/*int main(int argc , char *argv[]) {
    yylex() ;
    printf("\n") ;
    return(0) ;
}

int yywrap() {
    return(1) ;
}*/
