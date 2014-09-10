# factorial.awk -- compute factorial of a number
# $Id$
# Carlos Duarte, 981009

function factorial(n,	i, f) {
	f = n
	while (--n > 1)
		f *= n
	return f
}

BEGIN { for (i=1; i<20; i++) print i, factorial(i) }
