# arrays.pl -- arrays and hashes
# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 991101

use strict; 

sub arr_shuffle {
	local $_ = shift; 
	for (my $i = 0; $i < @{$_}; $i++) {
		my $j = int(rand(@$_ - $i)) + $i; 
		($_->[$i], $_->[$j]) = ($_->[$j], $_->[$i]); 
	}
}

sub arr_to_hash {
	local $_ = shift; 
	my %h; 
	for (my $i = 0; $i < @{$_}; $i++) {
		$h{$_->[$i]} = 1; 
	}
	return \%h; 
}

# transform hash{key} = value -> hash{value} = key
sub hash_reverse {
	my $h = shift; 
	my $new_h;
	my ($k,$v); 
	while (($k,$v) = each %$h) {
		$new_h->{$v} = $k; 
	}
	return $new_h; 
}

# transform hash{key} = value -> hash{value} = [key1 key2...]
sub hash_reverse_dup {
	my $h = shift; 
	my $new_h;
	my ($k,$v); 
	while (($k,$v) = each %$h) {
		push @{ $new_h->{$v} }, $k; 
	}
	return $new_h; 
}

### TEST
my @a = qw( a b c d e f g h i j k l ); 
arr_shuffle(\@a); for (@a) { print $_, " "; } print "\n"; 
my $h = arr_to_hash(\@a); for (keys %$h) { print $_, " "; } print "\n"; 
$h = hash_reverse_dup($h); 
for (keys %$h) { 
	print "$_: "; 
	for my $v (@{ $h->{$_} }) {
		print $v, " "; 
	} 
	print "\n"; 
}
