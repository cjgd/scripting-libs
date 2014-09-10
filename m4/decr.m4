dnl decr.m4 -- handles decr, if not available
dnl 
dnl $Id$
dnl Carlos Duarte, 981011
dnl 
dnl ----
dnl decr(n) : replaced by n-1
dnl 
ifdef(`decr', , `define(decr, `eval($1-1)')')dnl
dnl
ifdef(`TEST', ``'dnl
-1 decr(0)
10 decr(11)
21 decr(22)
32 decr(33)
43 decr(44)
54 decr(55)
65 decr(66)
76 decr(77)
87 decr(88)
98 decr(99)
164 decr(165)
263 decr(264)
411 decr(412)
633 decr(634)
966 decr(967)
1466 decr(1467)
')dnl
