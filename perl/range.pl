# range.pl -- expand symbolic ranges into a list
# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 990815

use strict; 

# in: range string 1-3,4,6
# out: range list (1, 3, 4, 6)
#
sub range {	# $symbolic_range
	local $_ = shift; 
	my @out; 

	for (split /,/) {
		my @rr = split /-/;
		if (@rr == 1) {
			push(@out, $rr[0]+0); 
		} elsif (@rr == 2) {
			my $from = $rr[0]; 
			my $to = $rr[1]; 
			$from == 0 and $from++; 
			while ($from <= $to) {
				push(@out, $from); 
				$from++; 
			}
		} else { # error
			return undef; 
		} 
	}
	return @out; 
}

## TEST
for (range("1-3,10,15,30-33")) {
	print "$_ "; 
}
print "\n"; 
