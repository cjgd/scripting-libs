# form.pl -- another way to fetch form passed variables
# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 990616

use strict; 

# returns a ref to an hash structure: 
# $data{'name'} = \$value; if name appears just once
# $data{'name'} = [ $val1, $val2, ... ]; if name appears more than once
#
sub form_parse {
	local $_; 
	my %data; 

	if ($ENV{'CONTENT_LENGTH'} != 0) {
		read STDIN, $_, $ENV{'CONTENT_LENGTH'} 
			or return undef; 
	}
	if ($ENV{QUERY_STRING}) {
		length and $_ .= "&"; 
		$_ .= $ENV{QUERY_STRING}; 
	}
	my @pairs = split /&/; 
	for (@pairs) {
		my @f = split /=/; 
		for (@f) {
			y/+/ /; 
			s/%([a-fA-F0-9][A-F0-9])/chr(hex($1))/ge; 
		}
		# here -- f0: name; f1: value
		if (exists $data{$f[0]}) {
			if (ref $data{$f[0]} eq "SCALAR") {
				# second time this name appears
				$data{$f[0]} = [ ${$data{$f[0]}}, $f[1] ]; 
			} else {
				# >= 3rd time
				push @{$data{$f[0]}}, $f[1]; 
			}
		} else {
			# first time this name appears
			$data{$f[0]} = \$f[1]; 
		}
	}
	return \%data; 
}

# form_var $data_ref, 'name'
# 	returns first element, or all if in scalar
# 	or list context 
#
sub form_var {
	my $d = shift; 
	my $name = shift; 
	my @a; 
	exists ${$d}{$name} or return undef; 
	if (ref ${$d}{$name} eq "SCALAR") {
		@a = (${${$d}{$name}}); 
	} else {
		@a = @{${$d}{$name}}; 
	}
	return wantarray ? @a : $a[0]; 
}

### test
$ENV{'QUERY_STRING'} = "A=a1&A=a2&A=a3&A=a4&B=b1&B=b2&C=c1"; 
my $q = form_parse(); 
$, = " "; 
print form_var($q, 'A'), "\n"; 
print form_var($q, 'B'), "\n";  
print form_var($q, 'C'), "\n";  
