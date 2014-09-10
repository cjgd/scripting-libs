#! /usr/bin/perl

# uudec.pl -- routines for uuencoding/decoding ... 
# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 990227

# pack/unpack have this hardwired, with "u" template...
# but can be done otherwise
#

use strict; 

# inp: one uuencoded line
# out: decode binary portion
sub uudec {
	my $uuline = shift; 
	my $r; 
	my $n; 

	$uuline =~ s/^(.)//; 
	return undef if (ord($1)<32 || ord($1)>96); 
	$n = (ord($1)-32)&077; 
	# print "n $n\n"; 
	return "" if ($n == 0); 
	for (;;) {
		return undef unless ($uuline =~ s/^(....)//); 
		my @x = map { (ord($_)-32)&077 } split '', $1; 
		$r .= chr(($x[0]<<2)|($x[1]>>4)); last if (--$n == 0); 
		$r .= chr(($x[1]<<4)|($x[2]>>2)); last if (--$n == 0); 
		$r .= chr(($x[2]<<6)|($x[3]   )); last if (--$n == 0); 
	}
	return $r; 
}

# inp: one [binary] portion
# out: uuencode line[s] of inp
sub uuenc {
	my $bytes = shift; 
	my $r; 

	my $rem = length($bytes)%3; 
	if ($rem > 0) {
		$rem = 3-$rem; 
		$bytes .= " " x $rem; 
	} 
	while (length($bytes)) {
		my $b = substr($bytes, 0, 45); 
		$bytes = substr($bytes, 45); 
		if (length($b)==45) {
			$r .= "M";
		} else {
			$r .= chr(length($b)-$rem+32);
		}
		my $pos = 0; 
		for (;;) {
			my $seq = substr($b, $pos, 3); 
			last if ($seq eq ""); 
			$pos += 3; 
			my @x = map { ord($_) } split '', $seq;
			$r .= chr(($x[0]>>2)+32);
			$r .= chr((($x[0]<<4&060)|($x[1]>>4))+32);
			$r .= chr((($x[1]<<2&074)|($x[2]>>6))+32);
			$r .= chr(($x[2]&077)+32); 
		}
		$r .= "\n"; 
	}
	$r .= " \n"; 
	$r =~ y/ /\`/; 
	return $r; 
}

## test
#my @a =<>; 
#my $s = join '', @a; 
#print uuenc $s; 
