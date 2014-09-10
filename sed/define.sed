#! /bin/sed -f

# define.sed -- a m4 subset
# Carlos Duarte <cgd@mail.teleweb.pt>, 980611

# this is a subset of m4, i.e. accepts only the define primitive: 
# 
# define(foo, bike)
# define(bar, walk)
# if this is my foo, i'd rather bar.
# 

/^define/{
	H
	x
	s/\(\n\)define(\([^,]*\),[ ]*\([^)]*\))/\1\2:\3:/
	x
	d
}
G
ta
:a
s/\(.*\)\(.*\n\)\1:\([^:]*\):/\3\2\1:\3/g
ta
P
d

