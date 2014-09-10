# expand.awk -- expand tabs into spaces
# Carlos Duarte, 011119

function expandN(cur, M, 	a,n,i,s) {
	n = split(cur,a,"")
	for (i=1;i<=n;i++) {
		if (a[i] == "\t") {
			s = s "" sprintf("%*s", M-(length(s)%M), "")
		} else {
			s = s "" a[i]
		}
	}
	return s
}

function expand(cur) { return expandN(cur,8) }

function ok(s,t) { if (s!=t) printf("BAD: got '%s' expected '%s'\n",s,t) }
BEGIN {
	ok(expand("\t\tx"), "                x")
	ok(expandN("\tx",4), "    x")
}
