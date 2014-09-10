# trim.awk -- remove whitespace from start of a string
# Carlos Duarte, 030121

function ltrim(s) {
	sub(/^ */, "", s);
	return s
}

function rtrim(s) {
	sub(/ *$/, "", s);
	return s
}

function trim(s) {
	return rtrim(ltrim(s));
}

function ok(s,t) { if (s!=t) printf("BAD: got :%s: expected :%s:\n",s,t) }
BEGIN {
	ok(trim("  xx   "), "xx")
	ok(trim("xx   "), "xx")
	ok(trim("   xx"), "xx")
	ok(trim("xx"), "xx")
	ok(ltrim("  xx  "), "xx  ")
	ok(rtrim("  xx  "), "  xx")
}
