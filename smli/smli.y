%{
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

int yylex() ;
void yyerror (const char *message) ;
struct node *new_NUMBER_node (int value) ; // 生成空的新node
struct node *new_BOOL_node (char *value) ;
struct node *new_VARIABLE_node (char *name , int value) ;
struct node *new_node (int node_type , struct node *left , struct node *right) ;
struct node *new_logic_node (int node_type , struct node *left , struct node *right) ;
struct node *new_define_node (struct node *name , struct node *function) ;
struct node *new_function_node (struct node *arguments , struct node *function_body) ;
struct node *new_if_node (struct node *condition , struct node *if_statement , struct node *else_statement) ;

bool checkButtom (struct node *tree , int node_type , int checkError) ;
void print_tree (struct node *tree) ;
void search_tree (struct node *tree) ;

typedef struct node {       // node的結構
    int node_type ;         // node的型態
    int Number ;            // int
    char *BoolValue ;       // bool
    char *Variable ;        // variable
    char *name ;            // define的名字
    struct node *condition ;// 　　　　               ｜condition
    struct node *left ;     // 左子樹｜define_name    ｜if_statement  ｜arguments
    struct node *right ;    // 右子樹｜define_function｜else_statement｜function_body
}n;
n *defineArray[100] ;
bool error = false ;
int print ; // 1 for number , 2 for bool
int defineCount = 0 ;
%}
%union {
    int number ;
    char *string ;
    struct node *ast ;
}
%token <number> NUMBER
%token <string> VARIABLE BOOL_VAL
%token AND OR NOT
%token MOD
%token DEFINE IF LAMBDA
%token PRINT_BOOL PRINT_NUM
%type <ast> stmt print-stmt exp exp-recursive
%type <ast> num-op plus-op minus-op multiply-op divide-op modulus-op greater-op smaller-op equal-op
%type <ast> logical-op and-op or-op not-op
%type <ast> def-stmt variable
%type <ast> fun-exp fun-ids var_recursive fun-body fun-call param fun-name
%type <ast> if-exp test-exp then-exp else-exp

%left AND OR
%left NOT '='
%left '<' '>'
%left '+' '-'
%left '*' '/' MOD
%left '(' ')'

%%
startline   : program       { /*printf("finish\n\n");*/ }

program     : stmt program
            | stmt
            ;

stmt        : exp           { search_tree($1); if (error) {return(0); } /*printf("exp-stmt\n");*/ }
            | def-stmt      { search_tree($1); if (error) {return(0); } /*printf("define-stmt\n");*/ }
            | print-stmt    { search_tree($1); if (error) {return(0); } print_tree($1); /*printf("print-stmt\n");*/ }
            ;

print-stmt  : '(' PRINT_BOOL exp ')' { $$ = $3; print = 2;}
            | '(' PRINT_NUM  exp ')' { $$ = $3; print = 1;}
            ;

exp         : BOOL_VAL { $$ = new_BOOL_node($1); }
            | NUMBER { $$ = new_NUMBER_node ($1); }
            | VARIABLE { $$ = new_VARIABLE_node($1, 0); }
            | num-op { $$ = $1; }
            | logical-op { $$ = $1; }
            | fun-exp { $$ = $1; }
            | fun-call { $$ = $1; }
            | if-exp { $$ = $1; }
            ;

exp-recursive   : exp exp-recursive { $$ = new_node ('R', $1, $2); }
                | exp { $$ = $1; }
                ;

num-op      : plus-op { $$ = $1; }
            | minus-op { $$ = $1; }
            | multiply-op { $$ = $1; }
            | divide-op { $$ = $1; }
            | modulus-op { $$ = $1; }
            | greater-op { $$ = $1; }
            | smaller-op { $$ = $1; }
            | equal-op { $$ = $1; }
            ;
    plus-op     : '(' '+' exp exp-recursive ')' { $$ = new_node ('+', $3, $4); }
                ;
    minus-op    : '(' '-' exp exp ')' { $$ = new_node ('-', $3, $4); }
                ;
    multiply-op : '(' '*' exp exp-recursive ')' { $$ = new_node ('*', $3, $4); }
                ;
    divide-op   : '(' '/' exp exp ')' { $$ = new_node ('/', $3, $4); }
                ;
    modulus-op  : '(' MOD exp exp ')' { $$ = new_node ('M', $3, $4); }
                ;
    greater-op  : '(' '>' exp exp ')' { $$ = new_node ('>', $3, $4); }
                ;
    smaller-op  : '(' '<' exp exp ')' { $$ = new_node ('<', $3, $4); }
                ;
    equal-op    : '(' '=' exp exp-recursive ')' { $$ = new_node ('=', $3, $4); }
                ;

logical-op  : and-op { $$ = $1; }
            | or-op { $$ = $1; }
            | not-op { $$ = $1; }
            ;
    and-op      : '(' AND exp exp-recursive ')' { $$ = new_logic_node('&', $3, $4); }
                ;
    or-op       : '(' OR exp exp-recursive ')' { $$ = new_logic_node('|', $3, $4); }
                ;
    not-op      : '(' NOT exp ')' { $$ = new_logic_node('!', $3, NULL); }
                ;

def-stmt    : '(' DEFINE variable exp ')' { $$ = new_define_node ($3, $4); }
            ;
    variable    : VARIABLE { $$ = new_VARIABLE_node($1, 0); }
                ;
/**********************************************************************************/
fun-exp     : '(' LAMBDA fun-ids fun-body ')' { $$ = new_function_node($3, $4); }
            ;
    fun-ids     : '(' var_recursive ')' { $$ = $2; }
                ;
    var_recursive   : variable var_recursive { $$ = new_node ('V', $1, $2); }
                    | variable { $$ = $1; }
                    |
                    ;
    fun-body    : exp { $$ = $1; }
                ;
    fun-call    : '(' fun-exp param ')'  { $$ = new_node ('C', $2, $3); }
                | '(' fun-exp ')' { $$ = new_node ('C', $2, NULL); }
                | '(' fun-name param ')' { $$ = new_node ('C', $2, $3); }
                | '(' fun-name ')' { $$ = new_node ('C', $2, NULL); }
                ;
    param       : exp-recursive { $$ = $1; }
                ;
    fun-name    : VARIABLE { $$ = new_VARIABLE_node($1, 0); }
                ;
/**********************************************************************************/

if-exp      : '(' IF test-exp then-exp else-exp ')' { $$ = new_if_node($3, $4, $5); }
            ;
    test-exp    : exp  { $$ = $1; }
                ;
    then-exp    : exp { $$ = $1; }
                ;
    else-exp    : exp { $$ = $1; }
                ;

%%
void yyerror (const char *message) {
    printf("%s\n",message);
}

int main (int argc, char *argv[]) {
    yyparse();
    printf("\n") ;
    return(0);
}

struct node *new_NUMBER_node (int value) {
    struct node *node = malloc (sizeof (struct node));
    node->left = NULL ;
    node->right = NULL ;
    node->node_type = 'N';
    node->Number = value;
    return node;
}

struct node *new_BOOL_node (char *value) {
    struct node *node = malloc (sizeof (struct node));
    node->left = NULL ;
    node->right = NULL ;
    node->node_type = 'B';
    node->BoolValue = value;
    return node;
}

struct node *new_VARIABLE_node (char *name , int value) {
    struct node *node = malloc (sizeof (struct node));
    node->left = NULL ;
    node->right = NULL ;
    node->node_type = 'V';
    node->Variable = name;
    node->Number = value;
    return node;
}

struct node *new_node (int node_type , struct node *left , struct node *right) {
    struct node *node = malloc (sizeof (struct node));
    node->left = left ;
    node->right = right ;
    node->node_type = node_type;
    return node;
}

struct node *new_logic_node (int node_type , struct node *left , struct node *right) {
    struct node *node = malloc (sizeof (struct node));
    node->left = left ;
    node->right = right ;
    node->node_type = node_type ;
    return node ;
}

struct node *new_define_node (struct node *name , struct node *function) {
    struct node *node = malloc (sizeof (struct node));
    node->left = NULL ;
    node->right = function ;
    node->node_type = 'D' ;
    node->name = name->Variable ;
    return node ;
}

struct node *new_function_node (struct node *arguments , struct node *function_body) {
    struct node *node = malloc (sizeof (struct node));
    node->node_type = 'F' ;
    node->left = arguments ;
    node->right = function_body ;
    return node ;
}

struct node *new_if_node (struct node *condition , struct node *if_statement , struct node *else_statement) {
    struct node *node = malloc (sizeof (struct node)) ;
    node->condition = condition ;
    node->left = if_statement ;
    node->right = else_statement ;
    node->node_type = 'I' ;
    return node ;
}

bool checkButtom (struct node *tree , int node_type , int checkError) { // 檢查是否已經到最下面，且若是使用define過的東西就做替換
    if (node_type == 0) {
        if (tree->left->right!=NULL || tree->left->left!=NULL) {
            search_tree(tree->left) ;
        }
        if (tree->right->right!=NULL || tree->right->left!=NULL) {
            search_tree(tree->right) ;
        }
    }
    else {
        if (tree->left->right!=NULL || tree->left->left!=NULL) {
            if (tree->left->node_type == 'R') {
                tree->left->node_type = node_type ;
            }
            search_tree(tree->left) ;
        }
        if (tree->right->right!=NULL || tree->right->left!=NULL) {
            if (tree->right->node_type == 'R') {
                tree->right->node_type = node_type ;
            }
            search_tree(tree->right) ;
        }
    }
    if (tree->right->node_type == 'V') {
        for (int i = 0 ; i < defineCount ; i++) {
            if (strcmp(tree->right->Variable,defineArray[i]->name)==0) {
                tree->right = defineArray[i]->right ;
                break ;
            }
        }
    }
    if (tree->left->node_type == 'V') {
        for (int i = 0 ; i < defineCount ; i++) {
            if (strcmp(tree->left->Variable,defineArray[i]->name)==0) {
                tree->left = defineArray[i]->right ;
                break ;
            }
        }
    }
    if (checkError == 1) {
        if (tree->left->node_type == 'B' || tree->right->node_type == 'B') {
            error = true ;
            printf("Type Error: Expect ‘number’ but got ‘boolean’.\n") ;
            return false ;
        }
    }
    if (checkError == 2) {
        if (tree->left->node_type == 'N' || tree->right->node_type == 'N') {
            error = true ;
            printf("Type Error: Expect ‘boolean’ but got ‘number’.\n") ;
            return false ;
        }
    }
    return true ;
}

void search_tree (struct node *tree) {
    if (!tree) {
        return ;
    }
    switch (tree->node_type) {
        case '+' : { // ADD
            if (checkButtom(tree , '+' , 1)) {
                tree->node_type = 'N' ;
                tree->Number = tree->left->Number + tree->right->Number ;
                /*printf("%d = %d + %d\n" , tree->Number , tree->left->Number , tree->right->Number) ;*/
                tree->left = NULL ;
                tree->right = NULL ;
            }
            break ;
        }
        case '-' : { // SUB
            if (checkButtom(tree , 0 , 1)) {
                tree->node_type = 'N' ;
                tree->Number = tree->left->Number - tree->right->Number ;
                /*printf("%d = %d - %d\n" , tree->Number , tree->left->Number , tree->right->Number) ;*/
                tree->left = NULL ;
                tree->right = NULL ;
            }
            break ;
        }
        case '*' : { // MUL
            if (checkButtom(tree , '*' , 1)) {
                tree->node_type = 'N' ;
                tree->Number = tree->left->Number * tree->right->Number ;
                /*printf("%d = %d * %d\n" , tree->Number , tree->left->Number , tree->right->Number) ;*/
                tree->left = NULL ;
                tree->right = NULL ;
            }
            break ;
        }
        case '/' : { // DIV
            if (checkButtom(tree , 0 , 1)) {
                tree->node_type = 'N' ;
                tree->Number = tree->left->Number / tree->right->Number ;
                /*printf("%d = %d / %d\n" , tree->Number , tree->left->Number , tree->right->Number) ;*/
                tree->left = NULL ;
                tree->right = NULL ;
            }
            break ;
        }
        case 'M' : { // MOD
            if (checkButtom(tree , 0 , 1)) {
                tree->node_type = 'N' ;
                tree->Number = tree->left->Number % tree->right->Number ;
                /*printf("%d = %d M %d\n" , tree->Number , tree->left->Number , tree->right->Number) ;*/
                tree->left = NULL ;
                tree->right = NULL ;
            }
            break ;
        }
        case '>' : { // 大於
            if (checkButtom(tree , 0 , 1)) {
                tree->node_type = 'B' ;
                if (tree->left->Number > tree->right->Number) {
                    tree->BoolValue = "#t" ;
                }
                else {
                    tree->BoolValue = "#f" ;
                }
                /*printf("%s = %d > %d\n" , tree->BoolValue , tree->left->Number , tree->right->Number) ;*/
                tree->left = NULL ;
                tree->right = NULL ;
            }
            break ;
        }
        case '<' : { // 小於
            if (checkButtom(tree , 0 , 1)) {
                tree->node_type = 'B' ;
                if (tree->left->Number < tree->right->Number) {
                    tree->BoolValue = "#t" ;
                }
                else {
                    tree->BoolValue = "#f" ;
                }
                /*printf("%s = %d < %d\n" , tree->BoolValue , tree->left->Number , tree->right->Number) ;*/
                tree->left = NULL ;
                tree->right = NULL ;
            }
            break ;
        }
        case '=' : { // 等於
            if (checkButtom(tree , '=' , 1)) {
                tree->node_type = 'B' ;
                if (tree->left->Number == tree->right->Number) {
                    tree->BoolValue = "#t" ;
                }
                else {
                    tree->BoolValue = "#f" ;
                }
                /*printf("%s = %d = %d\n" , tree->BoolValue , tree->left->Number , tree->right->Number) ;*/
                tree->left = NULL ;
                tree->right = NULL ;
            }
            break ;
        }
        case '&' : { // AND
            if (checkButtom(tree , '&' , 2)) {
                tree->node_type = 'B' ;
                if (strcmp(tree->left->BoolValue,"#t")==0 && strcmp(tree->right->BoolValue,"#t")==0) {
                    tree->BoolValue = "#t" ;
                }
                else {
                    tree->BoolValue = "#f" ;
                }
                /*printf("%s = %s & %s\n" , tree->BoolValue , tree->left->BoolValue , tree->right->BoolValue) ;*/
                tree->left = NULL ;
                tree->right = NULL ;
            }
            break ;
        }
        case '|' : { // OR
            if (checkButtom(tree , '|' , 2)) {
                tree->node_type = 'B' ;
                if (strcmp(tree->left->BoolValue,"#f")==0 && strcmp(tree->right->BoolValue,"#f")==0) {
                    tree->BoolValue = "#f" ;
                }
                else {
                    tree->BoolValue = "#t" ;
                }
                /*printf("%s = %s | %s\n" , tree->BoolValue , tree->left->BoolValue , tree->right->BoolValue ) ;*/
                tree->left = NULL ;
                tree->right = NULL ;
            }
            break ;
        }
        case '!': { // NOT
            if (tree->left->right!=NULL || tree->left->left!=NULL) {
                search_tree(tree->left) ;
            }
            if (tree->left->right==NULL && tree->left->left==NULL) {
                if (tree->left->node_type == 'V') {
                    for (int i = 0 ; i < defineCount ; i++) {
                        if (strcmp(tree->left->Variable,defineArray[i]->name)==0) {
                            tree->left = defineArray[i]->right ;
                            break ;
                        }
                    }
                }
                if (tree->left->node_type == 'N') {
                    error = true ;
                    printf("Type Error: Expect ‘boolean’ but got ‘number’.\n") ;
                    break ;
                }
                tree->node_type = 'B' ;
                if (strcmp(tree->left->BoolValue,"#f")==0) {
                    tree->BoolValue = "#t" ;
                }
                if (strcmp(tree->left->BoolValue,"#t")==0) {
                    tree->BoolValue = "#f" ;
                }
                /*printf("%s = ! %s\n" , tree->BoolValue , tree->left->BoolValue) ;*/
                tree->left = NULL ;
                tree->right = NULL ;
            }
            break ;
        }
        case 'N' : { // Number
            break ;
        }
        case 'B' : { // BoolValue
            break ;
        }
        case 'V' : { // Variable
            break ;
        }
        case 'D' : { // Define
            search_tree(tree->right) ;
            int i ;
            for (i = 0 ; i < defineCount ; i ++) {
                if (strcmp(tree->name,defineArray[i]->name)==0) {
                    defineArray[i] = tree ;
                    break ;
                }
            }
            /*printf("i : %d , def : %d\n" , i , defineCount) ;*/
            if (defineCount == i) {
                defineArray[defineCount] = tree ;
                defineCount++ ;
            }
            /*printf("Define.\ndefineCount : %d\nrightType : %c\n" , defineCount , tree->right->node_type ) ;*/
        }
        case 'F' : { // Function
            break ;
        }
        case 'I' : { // If
            /*printf("If ") ;*/
            search_tree(tree->condition) ;
            if (tree->condition->node_type == 'N') {
                error = true ;
                printf("Type Error: Expect ‘boolean’ but got ‘number’.\n") ;
                break ;
            }
            tree->BoolValue = tree->condition->BoolValue ;
            tree->condition = NULL ;
            if (strcmp(tree->BoolValue,"#t")==0) {
                /*printf("go if statement\n") ;*/
                search_tree(tree->left) ;
                tree->right = NULL ;
            }
            else {
                /*printf("go else statement\n") ;*/
                search_tree(tree->right) ;
                tree->left = NULL ;
            }
            break ;
        }
    }
}



void print_tree (struct node *tree) {
    switch (tree->node_type) {
        /*printf("print case : %c\n" , tree->node_type) ;*/
        case 'N' : {
            if (print == 1) {
                printf("%d\n" , tree->Number) ;
            }
            break ;
        }
        case 'B' :{
            if (print == 2) {
                printf("%s\n" , tree->BoolValue) ;
            }
            break ;
        }
        case 'V' :{
            for (int i = 0 ; i < defineCount ; i++) {
                if (strcmp(tree->Variable,defineArray[i]->name)==0) {
                    print_tree(defineArray[i]->right) ;
                    break ;
                }
            }
            break ;
        }
        case 'I' : { // If
            if (strcmp(tree->BoolValue,"#t")==0) {
                print_tree(tree->left) ;
            }
            else {
                print_tree(tree->right) ;
            }
            break ;
        }
        default :
            printf ("Error: Bad node type '%c' to free!\n" , tree->node_type) ;
    }
    free (tree) ;
}
