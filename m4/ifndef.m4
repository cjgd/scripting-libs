dnl ifndef.m4 -- demo for a ifdef-like macro
dnl $Id$
dnl Carlos Duarte, 981011
dnl
dnl ----
dnl ifndef(a, false, true) 
dnl	if `a' is defined gets replaced by `true', else `false'
dnl
define(isdef, `ifelse(`$1',$1,`not defined', `defined')')dnl
dnl
ifdef(`TEST', ``'dnl
not defined 	isdef(`foo') 
not defined	isdef(`bar') 
define(`foo', `bar') 
defined		isdef(`foo') 
not defined	isdef(`bar')
')dnl
