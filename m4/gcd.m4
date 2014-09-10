dnl gcd.m4 -- computes gcd(x,y): greatest common divisor
dnl $Id$
dnl Carlos Duarte, 981031
dnl 
dnl ----
dnl gcd(x,y)
dnl	returns the greatest common divisor between `x' and `y'
dnl
define(`gcd', `ifelse(eval($1%$2),0,$2,`gcd($2,eval($1%$2))')')dnl
dnl
ifdef(`TEST', ``'dnl
gcd(12, 3) = 3
gcd(12, 2) = 2
gcd(9, 6) = 3
gcd(22, 16) = 2
gcd(12, 12) = 12
gcd(2, 2) = 2
gcd(16, 6) = 2
gcd(18, 12) = 6
gcd(30, 12) = 6
gcd(20, 2) = 2
gcd(8, 2) = 2
gcd(22, 11) = 11
gcd(32, 26) = 2
gcd(21, 15) = 3
gcd(15, 3) = 3
')dnl
