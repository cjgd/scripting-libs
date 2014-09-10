dnl caps.m4 -- capitalize things
dnl
dnl $Id$
dnl Carlos Duarte, 981012
dnl
dnl ----
dnl caps(s) 
dnl	converts first char of `s' to upper, others to lowers
dnl
define(`to_upper', `translit(`$1', 
`abcdefghijklmnopqrstuvwxyz', 
`ABCDEFGHIJKLMNOPQRSTUVWXYZ')')dnl
define(`to_lower', `translit(`$1', 
`ABCDEFGHIJKLMNOPQRSTUVWXYZ',
`abcdefghijklmnopqrstuvwxyz')')dnl
dnl
dnl
define(`caps', `to_upper(substr(`$1',0,1))`'to_lower(substr(`$1',1))')dnl
dnl
ifdef(`TEST', ``'dnl
define(xpto, foo)dnl check if next came Xpto, or Foo
caps(`xpto')
caps(`XPTO')
')dnl
