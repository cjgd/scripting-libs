# xy_data.pl -- functions to manipulate (x,y) data
# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 990627

use strict; 

# receives (\@x, \@y), and returns (\@a, \@b, \@c)
# where, for each x[i] in c[i]..c[i+1], y[i] = a[i](x[i]-c[i])+b[i]
#
sub linear_coef {
	my $xr = shift; 
	my $yr = shift; 

	# remove repeated or undefed x's
	for (my $i = 1; $i<@$xr; ) {
		defined $$xr[$i] or goto remove; 
		defined $$yr[$i] or goto remove; 
		$$xr[$i] == $$xr[$i-1] and goto remove; 
		$i++; 
		next; 
	remove: 
		splice(@$xr, $i, 1); 
		splice(@$yr, $i, 1); 
	}

	my (@a, @b, @c); 
	# y=a(x-c)+b
	for (my $i=1; $i<@$xr; $i++) {
		push @a, ($$yr[$i]-$$yr[$i-1])/($$xr[$i]-$$xr[$i-1]); 
		push @b, $$yr[$i-1]; 
		push @c, $$xr[$i-1]; 
	}
	push @c, $$xr[$#$xr]; # max
	return (\@a, \@b, \@c); 
}

# receives (\@x, \@y, $n) and changes it to a new set of @x/@y of $n points
# 
sub linear_interp {
	my $xr = shift; 
	my $yr = shift; 
	my $n = shift; 

	my @tmp = linear_coef($xr, $yr); 
	my @a = @{$tmp[0]}; 
	my @b = @{$tmp[1]}; 
	my @c = @{$tmp[2]}; 

	my ($tmin, $tmax) = ($$xr[0], $$xr[$#$xr]); 
	splice @$xr, 0; 
	splice @$yr, 0;

	$n<2 and $n = 2; 
	my $step = ($tmax-$tmin)/($n-1); 
	#$step = int($step+.5); $step or $step++;  ## for integer Xs
	my $t=$tmin; 
	while ($n--) {
		while ($t>$c[1] && @c>2) {
			shift @a; 
			shift @b; 
			shift @c; 
		}
		push @$xr, $t; 
		push @$yr, $a[0]*($t-$c[0])+$b[0]; 
		$t += $step; 
	}
}

### test
my @x = (0, 1, 2, 3, 4, 5, 6, 7, 100, 200, 1000); 
my @y = (0, 1, 0, 1, 2, 1, 0, 0,   0,  12,   99); 
linear_interp(\@x, \@y, 30); 
for (my $i=0; $i<@x; $i++) {
	printf "%9.3f %9.3f\n", $x[$i], $y[$i]; 
}
