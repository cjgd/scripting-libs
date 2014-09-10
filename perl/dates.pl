# dates.pl -- routines to deal with dates and times
# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 990522/991101

use strict; 

## return date in format dd-mm-yyyy
sub get_dmy {
	my $t = shift; 
	my ($dd,$mm,$yy); 

	(undef,undef,undef,$dd,$mm,$yy) = 
		defined $t ? localtime $t : localtime; 
	length($dd)==1 and $dd = "0$dd";
	length(++$mm)==1 and $mm = "0$mm";
	$yy += 1900; 
	
	return ($dd, $mm, $yy); 
}

# converts an amount of secs to HH:MM:SS format
sub secs_to_fmt {
	my $secs = shift; 
	my $min = int($secs / 60); 
	$secs = $secs % 60; 
	my $hour = int($min / 60); 
	$min = $min % 60; 
	return $hour ? 
		sprintf "%02d:%02d:%02d", $hour, $min, $secs : 
		sprintf "%02d:%02d", $min, $secs; 
}

my @a; 
@a = get_dmy(433333333); print "$a[0] $a[1] $a[2]\n"; 
@a = get_dmy(); print "$a[0] $a[1] $a[2]\n"; 
@a = (9, 99, 999, 9999); 
for (@a) { printf "${_}s = %s\n", secs_to_fmt($_) }
