# ref_dump.pl -- given a ref, dump a valid perl representation of it
# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 990620

use strict; 

### args: ref_name, ref, options (hash ref)
# return a string with a valid perl representation of _ref_ structure
#
# options: {
#	indent => 1, 	# pretty print the output
# }
#
# implementation: for >= 2nd, passes (undef, ref, options, tabs)
#
sub ref_dump {
	local $_; 

	my $name = shift; 
	my $x = shift; 	# ref
	my $o = shift;  # options...

	my $ret; 
	defined $name and $ret = "\$$name = "; 

	my $tab;
	$tab = defined $_[0] ? shift : "\n"; 

	if (ref $x eq "HASH") {
		$tab .= "    "; 
		$ret .= "{ "; 
		$$o{'indent'} and $ret .= $tab; 
		for (keys %$x) {
			$ret .= "$_ => "; 
			if (ref $$x{$_}) {
				$ret .= ref_dump(undef, $$x{$_}, $o, $tab); 
			} else {
				my $y = $$x{$_}; 
				$y =~ s/'/'\\''/gs; 
				$ret .= "'$y', ";
			}
			$$o{'indent'} and $ret .= $tab; 
		}
		$ret =~ s/,\s*$//s; 
		substr($tab, -4) = ""; 
		$$o{'indent'} and $ret .= $tab;
		$ret .= "}, "; 
	} elsif (ref $x eq "ARRAY") {
		$tab .= "    ";
		$ret .= "[ ";
		$$o{'indent'} and $ret .= $tab; 
		for (my $i=0; $i<@$x; $i++) {
			if (ref $$x[$i]) {
				$ret .= ref_dump(undef, $$x[$i], $o, $tab); 
			} else {
				my $y = $$x[$i]; 
				$y =~ s/'/'\\''/gs;
				$ret .= "'$y', ";
			}
			$$o{'indent'} and $ret .= $tab; 
		}
		$ret =~ s/,\s*$//s; 
		substr($tab, -4) = "";
		$$o{'indent'} and $ret .= $tab; 
		$ret .= "], ";
	} elsif (ref $x eq "SCALAR") {
		my $y = $$x; 
		$y =~ s/'/'\\''/gs;
		$ret .= "\\'$y', "; 
		$$o{'indent'} and $ret .= $tab; 
	} else {
		my $y = $x; 
		$y =~ s/'/'\\''/gs;
		$ret .= "'$y', ";
		$$o{'indent'} and $ret .= $tab; 
	}

	defined $name and $ret =~ s/,\s*$/;\n/s; 
	return $ret; 
}

##### TEST
print ref_dump("d1", {
	a => 'b', 
	b => 'c', 
	c => [ 
		{
			ca => 'b', 
			cb => 'c', 
		}, 
		2, 
		[ 31, 32 , 33 ]
	], 
	'xpto', 
	1
}, { indent => 1 }); 

print ref_dump("d2", \'foo bar'); 
print ref_dump("d3", [1, 2, 3, "a", "b"]); 
print ref_dump("d4", [
	1, 
	2, 
	{ 'a' => { 'b' => { 'c' => 'd' } } }, 
	[ 1, 2 ], 
	[], 
	{}, 
	'xpto'
], {indent=>1}); 
