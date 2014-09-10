dnl hex.m4 -- hexadecimal to decimal conversion
dnl $Id$
dnl Carlos Duarte, 981011
dnl
dnl ----
dnl hex(hex_value)
dnl	replaces by decimal equivalent
dnl ex: hex(ff) -> 255
dnl
divert(-1)
define(hex_0, 0)
define(hex_1, 1)
define(hex_2, 2)
define(hex_3, 3)
define(hex_4, 4)
define(hex_5, 5)
define(hex_6, 6)
define(hex_7, 7)
define(hex_8, 8)
define(hex_9, 9)
define(hex_a, 10)
define(hex_b, 11)
define(hex_c, 12)
define(hex_d, 13)
define(hex_e, 14)
define(hex_f, 15)
define(`hex', `hex_aux(translit(`$1', `ABCDEF',`abcdef'), 0)')
define(`hex_aux', `ifelse(`$1',,$2,
	`hex_aux(substr(`$1',1), eval($2*16+'hex_`'substr(`$1',0,1)`))')')
divert`'dnl
dnl
ifdef(`TEST', ``'dnl
0	hex(0)
1	hex(1)
3	hex(3)
8	hex(8)
76	hex(4C)
101	hex(65)
112	hex(70)
238	hex(EE)
1695	hex(69F)
2168	hex(878)
3717	hex(E85)
4969	hex(1369)
5635	hex(1603)
6281	hex(1889)
7695	hex(1E0F)
')dnl
