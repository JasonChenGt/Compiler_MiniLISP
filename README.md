# Mini-LISP
    Compiler final project.
    使用 Lex 和 Yacc 編寫，概念為讀取輸入的指令，建立AST後，search整棵樹，依照每個node的type去執行不同的動作。
## Environment 
    Linux
## How to Run?
    $ ./smli < example.lsp
    or
    $ sh BuildSmliBasic.sh // for creat only Basic Answer in output.txt
    or
    $ sh BuildSmliBonus.sh // for creat Basic and Bonus Answer in output.txt
## Type Definition
    Boolean : Boolean type includes two values, #t for true and #f for false.
    Number  : Signed integer from −(231) to 231 – 1, behavior out of this range is not defined.

## Operation Overview
### Numerical 
| OperatorsName | Symbol | Example |
| :--------: | :-: | :------------: |
| Plus       | +   | (+ 1 2) => 3   |
| Minus      | -   | (- 1 2) => -1  |
| Multiply   | *   | (* 2 3) => 6   |
| Divide     | /   | (/ 6 3) => 2   |
| Modulus    | mod | (mod 8 3) => 2 |
| Greater    | >   | (> 1 2) => #f  |
| Smaller    | <   | (< 1 2) => #t  | 
| Equal      | =   | (= 1 2) => #f  |
### Logical Operators
| Name | Symbol | Example
| :-: | :-: | :---------------: |
| And | and | (and #t #f) => #f |
| Or  | or  | (or #t #f) => #t  |
| Not | not | (not #t) => #f    |
### Other Operators
    define , if
## Lexical Details
    Preliminary Definitions:
        letter          [a-z]
        digit           [0-9]
        separator       "\t"|"\n"|"\r"|" "

    Token Definitions:
        number          0|[1-9]{digit}*|\-[1-9]{digit}*
        variable        {letter}({letter}|{digit}|"-")*
        bool_val        #t|#f
## Grammar Overview
    startline   : program       
    program     : stmt program
                | stmt
                ;
    stmt        : exp           
                | def-stmt     
                | print-stmt    
                ;
    print-stmt  : '(' PRINT_BOOL exp ')' 
                | '(' PRINT_NUM  exp ')' 
                ;
    exp         : BOOL_VAL 
                | NUMBER
                | VARIABLE 
                | num-op
                | logical-op 
                | fun-exp 
                | fun-call
                | if-exp 
                ;
    exp-recursive   : exp exp-recursive 
                    | exp 
                    ;
    num-op      : plus-op 
                | minus-op
                | multiply-op
                | divide-op
                | modulus-op 
                | greater-op 
                | smaller-op 
                | equal-op
                ;
        plus-op     : '(' '+' exp exp-recursive ')' 
                    ;
        minus-op    : '(' '-' exp exp ')' 
                    ;
        multiply-op : '(' '*' exp exp-recursive ')' 
                    ;
        divide-op   : '(' '/' exp exp ')' 
                    ;
        modulus-op  : '(' MOD exp exp ')' 
                    ;
        greater-op  : '(' '>' exp exp ')'
                    ;
        smaller-op  : '(' '<' exp exp ')' 
                    ;
        equal-op    : '(' '=' exp exp-recursive ')' 
                    ;
    logical-op  : and-op 
                | or-op 
                | not-op 
                ;
        and-op      : '(' AND exp exp-recursive ')' 
                    ;
        or-op       : '(' OR exp exp-recursive ')' 
                    ;
        not-op      : '(' NOT exp ')' 
                    ;
    def-stmt    : '(' DEFINE variable exp ')'
                ;
        variable    : VARIABLE
                    ;
    /**********************************************************************************/
    目前只能符合文法，未能有實際作用。
    fun-exp     : '(' LAMBDA fun-ids fun-body ')' 
                ;
        fun-ids     : '(' var_recursive ')' 
                    ;
        var_recursive   : variable var_recursive 
                        | variable 
                        |
                        ;
        fun-body    : exp 
                    ;
        fun-call    : '(' fun-exp param ')'  
                    | '(' fun-exp ')' 
                    | '(' fun-name param ')' 
                    | '(' fun-name ')' 
                    ;
        param       : exp-recursive 
                    ;
        fun-name    : VARIABLE 
                    ;
    /**********************************************************************************/
    if-exp      : '(' IF test-exp then-exp else-exp ')' 
                ;
        test-exp    : exp  
                    ;
        then-exp    : exp 
                    ;
        else-exp    : exp 
                    ;
## Node
### Structure
| type | name | 基本的node | define node | if node | function node |
| :-: | :-: | :-: | :-: | :-: | :-: |
| int        | node_type   | node的型態 | | |
| int        | Number    | Number
| char *     | BoolValue | BoolValue | | |
| char *     | Variable  | Variable | | |
| char *     | name  | define的名字 | | |
| struct node *   | condition   | | | condition |
| struct node *   | left   | 左子樹 | define_name | if_statement  | arguments
| struct node *   | right   | 右子樹 | define_function | else_statement| function_body
### Type_Symbol
|+|-|*|/|M|>|<|=|&|\||
| :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: |:-: | :-: |
| sum | Minus | Multiply | Divide | Modulus | Greater | Smaller | Equal | And | Or | 
|!|C|N|B|V|R|D|F|I|
| Not | Function Call | Number | BoolValue | Variable | Recursive | Define | Function | If |
## Function
    創一個新的普通node：
        struct node *new_node (int node_type , struct node *left , struct node *right) ;
    創一個 BoolValue 的node：
        struct node *new_BOOL_node (char *value) ;
    創一個 Variable 的node：
        struct node *new_VARIABLE_node (char *name , int value) ;
    創一個 Number 的node：
        struct node *new_NUMBER_node (int value) ; 
    創一個 And , Or , Not 的node：
        struct node *new_logic_node (int node_type , struct node *left , struct node *right) ;
    創一個 Define 的node：
        struct node *new_define_node (struct node *name , struct node *function) ;
    創一個 Function 的node：
        struct node *new_function_node (struct node *arguments , struct node *function_body) ;
    創一個 If 的node：
        struct node *new_if_node (struct node *condition , struct node *if_statement , struct node *else_statement) ;
    檢查是否已經到最下面，並做type checking，且若是使用define過的東西就做替換：
        bool checkButtom (struct node *tree , int node_type , int checkError) ;
    將要印的node印出來
        void print_tree (struct node *tree) ;
    將整個AST search過一遍：
        void search_tree (struct node *tree) ;
