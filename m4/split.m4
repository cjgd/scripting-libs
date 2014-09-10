dnl split.m4 -- split one string into a list
dnl $Id$
dnl Carlos Duarte <cgd@teleweb.pt>, 000209
dnl
dnl split(sep_string, string_to_split)
dnl ex: split(:, 0:1:2:3:4) -> 0,1,2,3,4
dnl 
divert(-1)

define(`split', `ifelse(define(`_x', index($2, $1))_x,-1,`$2', 
`substr($2,0,_x)`,'split($1, substr($2, eval(_x+len($1))))')')

divert`'dnl
ifdef(`TEST', `dnl
split(:, a:b:c)
split(`define', `ifelse define ifelse define ifelse')
split(`ifelse', `ifelse define ifelse define ifelse')
split(:, 0:1:2:3:4) 
')dnl
