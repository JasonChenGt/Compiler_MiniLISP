struct node *new_NUMBER_node (int value) ; // 生成空的新node
struct node *new_BOOL_node (char *value) ;
struct node *new_VARIABLE_node (char *name , int value) ;
struct node *new_node (int node_type , struct node *left , struct node *right) ;
struct node *new_logic_node (int node_type , struct node *left , struct node *right) ;
struct node *new_define_node (struct node *name , struct node *function) ;
struct node *new_function_node (struct node *arguments , struct node *function_body) ;
struct node *new_if_node (struct node *condition , struct node *if_statement , struct node *else_statement) ;


struct node {               // node的結構
    int node_type ;         // node的型態
    int Number ;            // int
    char *BoolValue ;       // bool
    char *Variable ;        // variable
    char *name ;            // define的名字
    struct node *condition ;// 　　　　               ｜condition
    struct node *left ;     // 左子樹｜define_name    ｜if_statement  ｜arguments
    struct node *right ;    // 右子樹｜define_function｜else_statement｜function_body
};

+
-
*
/
M
>
<
=
&
|
!
C // function call
N // Number
B // BoolValue
V // Variable
R // recursive
D // Define
F // Function
I // If


