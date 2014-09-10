# gcd.awk -- gcd, greatest common divisor
# $Id$
# Carlos Duarte, 980618

# greatest common divisor of (x,y)
function gcd(x,y,	t,r) {
	if (x<y) {
		t=x
		x=y
		y=t
	}
	for (;;) {
		r = x % y
		if (r == 0) 
			break
		x = y
		y = r
	}
	return (y);
}

# find small integers var_x and var_y such var_x/var_y = x/y
function simplify(x,y,	g) {
	g = gcd(x,y)
	var_x = x/g
	var_y = y/g
}

# main
BEGIN {
	srand(); 
	for (i=1; i<34; i++) {
		j = int(rand()*i)+1
		printf "gcd(%d, %d) = %d\n", i, j, gcd(i, j)
	}

	for (i=1; i<34; i++) {
		j = int(rand()*i)+1
		simplify(i,j)
		printf "%2d/%2d = %2d/%2d = %6.3f ", i, j, var_x, var_y, i/j
		if (var_x/var_y != i/j)
			printf "error!\n"
		else
			printf "OK\n"
	}
}
