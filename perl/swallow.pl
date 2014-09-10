#! /usr/bin/perl

# swallow.pl -- swallow files into scalar buffer
# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 990221/031212

use strict; 

# &swallow($filename...)  -> scalar with all data
# 
sub swallow {
	my $data; 
	my $pos = 0; 

	for my $fn (@_) {
		local *F;
		open F, $fn or return undef; 
		for (;;) {
			my $inc = read(F, $data, 4096, $pos); 
			return undef if (!defined($inc)); 
			last if ($inc == 0); 
			$pos += $inc; 
		}
		close F;  # hope it works :)
	}
	return $data; 
}

sub swallow2 {
	my $data; 
	local $/; 

	undef $/; 
	for my $fn (@_) {
		local *F; 
		open F, $fn or return undef;
		$data .= <F>; 
		close F; 
	}
	return $data; 
}

# as above, for one file only
sub file_swallow {
	local ($/, $., $_); 
	local *F; 
	undef $/; 

	my $filename = shift; 
	open F, $filename or die "$filename: $!"; 
	$_ = <F>; 
	close F; 
	return $_; 
}

## test
#print &swallow($0, "fortune|"); 
#print &swallow2($0, "fortune|"); 
print file_swallow("fortune|"); 
