# hex.awk -- hexadecimal <-> decimal conversions 
# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 990219


# returns decimal value of hex string S, or -1 on invalid input 
# 
function hex2dec(s,	n,i,j,h) {
	s = tolower(s)
	n = length(s)
	for (i=1; i<=n; i++) {
		j = index("0123456789abcdef", substr(s, i, 1))
		if (j == 0)
			return -1; 
		h = h*16 + j-1
	}
	return h
}

# returns hexstring representation of decimal N
#
function dec2hex(n,	hex) {
	do {
		#hex = substr("0123456789abcdef", n%16+1, 1) hex
		hex = substr("0123456789ABCDEF", n%16+1, 1) hex
		n = int(n/16)
	} while (n)
	return hex
}

## test
BEGIN {
	print hex2dec("FF"), 255
	print hex2dec("AB"), 171
	print hex2dec("abcdef"), 11259375

	print dec2hex(255), "FF"
	print dec2hex(11259375), "ABCDEF"
	print dec2hex(171), "AB"
}

