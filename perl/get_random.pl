# get_random.pl -- string composed of N random chars 
# $Id$
# Carlos Duarte <cgd@teleweb.pt>, 000410

use strict; 

sub get_random {        # N
	my $n = shift; 
	my $subset = @_ ? shift : "abcdefghijklmnopqrstuvwxyz0123456789"; 
	my $r; 
	$r .= substr($subset,int(rand()*length($subset)),1) while ($n--); 
	return $r; 
}

__END__
print get_random(15), "\n"; 
print get_random(3, "1234567890"), "\n"; 
print get_random(15), "\n"; 
print get_random(3, "1234567890"), "\n"; 
print get_random(15), "\n"; 
print get_random(3, "1234567890"), "\n"; 
