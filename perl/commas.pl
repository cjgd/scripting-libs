# commas.pl -- place commas on a number...
# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 990815

use strict; 

sub commas { 			# $string, [$separator]
	local $_ = shift; 
	my $s = shift; $s or $s = ".";

	$_ = join '', reverse split ''; 
	s/(...)/$1$s/g; 
	my $c = chop; 
	$c eq $s or $_ .= $c; 
	return join '', reverse split '';
}

## TEST
my $n = 1; 
while ($n<10) {
	$_ .= $n; 
	$n++; 
	printf "%12s: %12s\n", $_, commas($_);
	printf "%12s: %12s\n", $_, commas($_, ";");
}
