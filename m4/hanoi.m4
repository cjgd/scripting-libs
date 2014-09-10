dnl hanoi.m4 -- solves hanoi towers
dnl $Id$
dnl Carlos Duarte, 981011
dnl
dnl ----
dnl hanoi(n)
dnl	prints the moves to be made, in format: 'move from 1 to 2'
dnl	on a n towers game
dnl
divert(-1)
define(`hanoi', 
`n = $1
hanoi_aux($1, 1, 2, 3)')
define(`hanoi_aux', `ifelse($1,0,, 
`hanoi_aux(decr($1),$2,$4,$3)dnl
move from $2 to $4
hanoi_aux(decr($1),$3,$2,$4)')')

divert`'dnl
ifdef(`TEST', ``'dnl
hanoi(5)
')dnl
