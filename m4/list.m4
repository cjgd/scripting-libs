dnl list.m4 -- macros that deal with lists in M4
dnl $Id$
dnl Carlos Duarte <cgd@teleweb.pt>, 000209/001216
dnl 
dnl grep(x, list)
dnl 	return x if x is on list, else empty
dnl 
dnl grepv(x,list)
dnl 	return all elements of list, except x
dnl 	(if x not there,return list)
dnl 
dnl map(expr, list)
dnl 	for each element of list, evaluates expr.
dnl 	_D_ at expr, will be replaced by each
dnl 	element of list
dnl
dnl join(SEP, LIST)
dnl	produces a string with all elements of LIST separated by SEP
dnl
divert(-1)

define(`grep', `ifelse(`$2',`',,``$1'', ``$2'', ``$1'', 
`grep(`$1', shift(shift($@)))')')

define(`grepv', `ifelse(`$2',`',,``$1'', ``$2'',
`grepv(`$1', shift(shift($@)))',
``$2'`'grepv(`$1', shift(shift($@)))')')

define(`map', `ifelse(`$2',`',,
`define(`_D_', ``$2'')$1`'map(`$1', shift(shift($@)))')')

define(`join', `ifelse(`$2',`',, 
  `ifelse(`$3',`', ``$2'', 
		   ``$2$1'`'join(`$1',shift(shift($@)))')')')

dnl 

divert`'dnl
dnl
ifdef(`TEST', ``'dnl
define(f, __x__)
define(t,``$1' :$1:')
t(`grep(a, a,b,c,d,e,`f')')
t(`grep(`f', a,b,c,d,e,`f')')
t(`grep(b, a,b,c,d,e,`f')')
t(`grep(z, a,b,c,d,e,`f')')
t(`grepv(a, a,b,c,d,e,`f')')
t(`grepv(b, a,b,c,d,e,`f')')
t(`grepv(z, a,b,c,d,e,`f')')
t(`map(`(_D_) ', a,b,c,d,e,`f')')
t(`join(|, a,b,c,d,e,`f')')
t(`join(|, map(`"_D_",', a,b,c,e))')
')dnl

