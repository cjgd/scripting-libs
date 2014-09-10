dnl fibo.m4 -- fibonnaci numbers
dnl
dnl $Id$
dnl Carlos Duarte, 981011
dnl
dnl ----
dnl fibo(n) : gets replaced by nth fibonnaci number
dnl
define(fibo, `ifelse($1, 0, 0, $1, 1, 1, 
	`eval(fibo(decr($1))+fibo(decr(decr($1))))')')dnl
dnl
ifdef(`TEST', ``'dnl
0 fibo(0)
1 fibo(1)
1 fibo(2)
2 fibo(3)
3 fibo(4)
5 fibo(5)
8 fibo(6)
13 fibo(7)
')dnl
