# dirname.awk -- print directory part of a path
# $Id$
# Carlos Duarte, 021114

function dirname(s,	p,p0) {
	p0 = 0
	for (;;) {
		p = index(substr(s,p0+1),"/")
		if (p == 0) break
		p0 += p
	}
	if (p0 == 0) return "."
	if (p0 == 1) return "/"
	return substr(s,1,p0-1)
}

function ok(s,t) { if (s!=t) printf("BAD: got %s expected %s\n",s,t) }
BEGIN {
	ok(dirname("xx"), 	".")
	ok(dirname("/"), 	"/")
	ok(dirname("/aa"),	"/")
	ok(dirname("/aa/"),	"/aa")
	ok(dirname("a/aa"),	"a")
	ok(dirname("1/a/aa"),	"1/a")
	ok(dirname("/1/a/aa"),	"/1/a")
}
