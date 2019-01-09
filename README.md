# Mini-LISP
Compiler final project.

## How to Run?
```Bash
$ ./smli < example.lsp
```
## Type Definition
    Boolean: Boolean type includes two values, #t for true and #f for false.
    Number: Signed integer from −(231) to 231 – 1, behavior out of this range is not defined.

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
        separator ::= ‘\t’(tab) | ‘\n’ | ‘\r’ | ‘ ’(space) 
        letter    ::= [a-z]
        digit     ::= [0-9]
    Token Definitions:
        number    ::= 0 | [1-9]digit* | -[1-9]digit* 
        ID        ::= letter (letter | digit | ‘-’)* 
        bool-val  ::= #t | #f
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
