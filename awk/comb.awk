#! /bin/awk -f

# $Id$
# Carlos Duarte, 981009

# invoke: n=xx; r=yy; comb(1,1)
# n>=r, n: total; r: dim of each given combination
# a[1..r] permuted index: i.e. a[1..r] maps into a combination of 1..r
#
function comb(j, k,	i,top) {
        if (j <= r) {
		top = n-r+j
                for (i=k; i<= top; i++) {
                        a[j] = i
                        comb(j+1, i+1)
		}
	} else {
		for (i=1; i<=r; i++)
			printf "%d ", c[a[i]]
		printf "\n"
	}
}

BEGIN {
	r = 6
	c[++n] = 48
	c[++n] = 1
	c[++n] = 7
	c[++n] = 19
	c[++n] = 17
	c[++n] = 34
	c[++n] = 26
	c[++n] = 10

	comb(1,1)
}
