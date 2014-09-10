dnl bin.m4 -- binary to decimal conversion
dnl $Id$
dnl Carlos Duarte, 981011
dnl
dnl ----
dnl bin(binary_string)
dnl	convert a binary_string to a decimal value
dnl ex: bin(10101010) -> 170
dnl
divert(-1)
define(`bin', `bin_aux($1, 0)')
define(`bin_aux', `ifelse($1,,$2,
	`bin_aux(substr($1,1), eval($2+$2+substr($1,0,1)))')')
divert`'dnl
dnl
ifdef(`TEST', ``'dnl
0	bin(0)
1	bin(1)
3	bin(11)
8	bin(1000)
76	bin(1001100)
101	bin(1100101)
112	bin(1110000)
238	bin(11101110)
1695    bin(11010011111)
2168    bin(100001111000)
3717    bin(111010000101)
4969    bin(1001101101001)
5635    bin(1011000000011)
6281    bin(1100010001001)
7695    bin(1111000001111)
')dnl
