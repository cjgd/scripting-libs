# basename.awk -- print basename of a path
# $Id$
# Carlos Duarte, 021114

function basename(s,	p) {
	while ((p=index(s,"/")) != 0) 
		s = substr(s, p+1)
	return s
}

function ok(s,t) { if (s!=t) printf("BAD: got %s expected %s\n",s,t) }
BEGIN {
	ok(basename("xx"), 	"xx")
	ok(basename("/"), 	"")
	ok(basename("/aa"),	"aa")
	ok(basename("/aa/"),	"")
	ok(basename("a/aa"),	"aa")
	ok(basename("1/a/aa"),	"aa")
	ok(basename("/1/a/aa"),	"aa")
	ok(basename("/1/fo.x"),	"fo.x")
}
