# enconding.pl -- several used encoding/decoding subroutines
# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 990616

use strict; 

# escape some chars to %HH representation
sub url_encode {
	local $_ = shift; 
	s/[^a-zA-Z0-9_\-.]/sprintf "%%%02X", ord($&)/ge; 
	return $_; 
}

# convert %HH to its proper 8 bit value character
sub url_decode {
	local $_ = shift; 
	s/%(..)/chr(hex($1))/ge; 
	return $_; 
}

# escape abc... to AABBCC... where AA is the hex reprensentation of 'a'
sub simple_quoter {
	local $_ = shift; 
	s/./sprintf("%02x",ord($&))/seg; 
	return $_; 
}

# escape AABBCC... to abc...
sub simple_unquoter {
	local $_ = shift; 
	s/../chr(hex($&))/seg; 
	return $_; 
}

## test 
my $u = url_encode("http://www.teleweb.pt:8080/"); 
print $u, " -> ", url_decode($u), "\n"; 
my $t = simple_quoter("<>zxcvbnm,;.:-_"); 
print $t, " -> ", simple_unquoter($t), "\n"; 
