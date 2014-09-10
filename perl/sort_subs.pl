# sort_subs.pl -- sort subs for use in the SORT builtin
# $Id$
# Carlos Duarte <cgd@teleweb.pt>, 000212

use strict; 

## on a "find dir ! -type d" kind of output, sorts alphabetical, BUT with
## files appearing first, and directories later
##
my $sort_dir = sub { 
	my ($aa,$bb) = ($a, $b); 
	$aa =~ s#[^/]*$##; 
	return -1 if (substr($bb,0,length($aa)) eq $aa && 
		      $aa =~ tr#/#/# < $bb =~ tr#/#/#); 

	($bb,$aa) = ($a, $b); 
	$aa =~ s#[^/]*$##; 
	return 1 if (substr($bb,0,length($aa)) eq $aa && 
		     $aa =~ tr#/#/# < $bb =~ tr#/#/#); 
	return $a cmp $b; 
}; 

## sorts dates like: 1-jan-99 or 1-jan-2000
my $sort_months = 'jan feb mar apr may jun jul aug sep oct nov dec';
my $sort_date = sub {
	my @a = reverse split /[-:\/ ]/, $a; 
	my @b = reverse split /[-:\/ ]/, $b; 

	$a[0] <=> $b[0] or 
	index($sort_months,lc($a[1]))<=>index($sort_months,lc($b[1])) or
	$a[2] <=> $b[2]
}; 

### TEST
$, = " ";
print sort $sort_dir qw( z zz b/b c/c/c a/9 a/8 a/7/6 aa ); print "\n";  
print sort $sort_date qw( 
	22-Feb-2000  1-Jan-2001 22-Jan-2001  1-Feb-2000
	22-Jan-1999  1-Jan-1999  1-Feb-1999 22-Feb-1999
); print "\n";

