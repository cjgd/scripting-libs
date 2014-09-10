dnl fact.m4 -- compute factorial
dnl $Id$
dnl Carlos Duarte, 981012
dnl
dnl ----
dnl fact(n)
dnl	expands into n! 
dnl ex: fact(6) -> 720
dnl
define(`fact', `ifelse($1,1,1,`eval($1*fact(eval($1-1)))')')dnl
dnl
ifdef(`TEST', ``'dnl
1		fact(1) 
2		fact(2) 
6		fact(3) 
2		fact(4) 
12		fact(5) 
720		fact(6) 
5040		fact(7) 
40320		fact(8) 
362880		fact(9) 
3628800		fact(10) 
39916800	fact(11) 
479001600	fact(12)
')dnl
