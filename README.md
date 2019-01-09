# Mini-LISP
Compiler final project.

# Type Definition
    Boolean: Boolean type includes two values, #t for true and #f for false.
    Number: Signed integer from −(231) to 231 – 1, behavior out of this range is not defined.

# Operation Overview
## Numerical 
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
## Logical Operators
| Name | Symbol | Example
| :-: | :-: | :---------------: |
| And | and | (and #t #f) => #f |
| Or  | or  | (or #t #f) => #t  |
| Not | not | (not #t) => #f    |
