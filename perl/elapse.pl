# elapse.pl -- elapsed time, within resolution in 1/tick secs.
# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 990228

use strict;

# $fsec = &ftime(); 
# 	elapsed time, in seconds, but with fractional part
#
sub ftime {
	my @s = times(); 
	return $s[0] + $s[1]; 
}

# &elased("timer_a"); 
# ... 
# $delta = &elapsed("timer_a"); 
#	elapsed time, since the last call with "timer_a"
#
{my %elapse_hash; 
sub elapse {
	my $h = shift; 

	if (!defined($elapse_hash{$h})) {
		$elapse_hash{$h} = ftime; 
		return 0; 
	}
	my $o = $elapse_hash{$h}; 
	$elapse_hash{$h} = ftime; 
	return $elapse_hash{$h} - $o; 
}}

## test
my @keys = qw(a); 
elapse("a"); 
my $i; 
for ($i=1; $i<=500000; $i++) {
	if ($i % 50000 == 0) {
		my $key = chr(ord("a")+int($i/50000)); 
		elapse($key); 
		push @keys, $key; 
	}
	$i += 0; 
}
for (@keys) {
	print "$_: ", elapse($_), "\n"; 
}
