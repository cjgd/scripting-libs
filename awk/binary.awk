# binary.awk -- perform binary conversions
# $Id$
# Carlos Duarte, 981011

# bin2dec(binary_string), returns decimal equivalent 
# ex: bin2dec("10011001") -> 153
#
function bin2dec(b,	n,i,d) {
	n = length(b)
	d = 0
	for (i=1; i<=n; i++) {
		d += d # d = d*2
		if (substr(b, i, 1) == "1")
			d++
	}
	return d
}

# dec2bin(decimal_integer), returns the equivalent binary string
# ex: dec2bin(202) -> 11001010
function dec2bin(d,	b) {
	do {
		b = "" d%2 b
		d = int(d/2)
	} while (d); 
	return b
}

# test
BEGIN {
	for (n = 555; n--; ) {
		d = int(rand()*2828)
		if (bin2dec(dec2bin(d)) != d) {
			print "error:", d
			print dec2bin(d)
			print bin2dec(dec2bin(d))
		}
	}
	print bin2dec("10011001")
}	
