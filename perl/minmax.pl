# minmax.pl -- functions for finding minimum and maximum 
# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 990104/990222

sub min {
	my $m = shift; 
	my $f; 
	while (defined($f = shift)) {
		($f < $m) and $m = $f; 
	}
	return $m; 
}

sub max {
	my $m = shift; 
	my $f; 
	while (defined($f = shift)) {
		($f > $m) and $m = $f; 
	}
	return $m; 
}

sub minmax {
	my $m = shift; 
	my $M = $m; 
	my $f; 
	while (defined($f = shift)) {
		($f > $M) and $M = $f; 
		($f < $m) and $m = $f; 
	}
	return ($m, $M); 
}


## test
#print min 1,2,7; print "\n"; 
#print max 1,2,7; print "\n"; 
#$, = " -- "; 
#print minmax 1, 2, 3, 4, 5, 6; print "\n"; 
