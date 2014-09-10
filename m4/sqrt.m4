dnl sqrt.m4 -- computes squate root
dnl $Id$
dnl Carlos Duarte, 981011
dnl
dnl ----
dnl sqrt(number)
dnl	replaces by numbers truncated square root
dnl ex: sqrt(4) -> 2, sqrt(5) -> 2
dnl
dnl
divert(-1)
# 
# uses Newton algorithm: 
#	zero function f(x) = x^2 - a; f(x)=0 -> x=sqrt(a)
#	recurrence: x1 = (x0+a/x0)/2
#	first try: x0 = (a+2)/3
#
define(`sqrt', `sqrt_aux($1, eval(($1+2)/3), $1)')dnl
define(`sqrt_aux', `ifelse($2,$3,$2,
	`sqrt_aux($1, eval(($2+$1/$2)/2), $2)')')dnl

divert`'dnl
ifdef(`TEST', ``'dnl
1	sqrt(1)
2	sqrt(4)
3	sqrt(9)
4	sqrt(16)
5	sqrt(25)
6	sqrt(36)
7	sqrt(49)
8	sqrt(64)
9	sqrt(81)
10	sqrt(100)
11	sqrt(121)
12	sqrt(144)
13	sqrt(169)
14	sqrt(196)
15	sqrt(225)
16	sqrt(256)
')dnl
