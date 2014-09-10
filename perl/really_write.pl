# really_write.pl -- write contents on a filename
# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 990628

# really_write $path, $contents
#	write contents on file specified by $path, creating initial dirs
# 	if needs to 
# 
# 	returns undef if everything was ok, else return a string describing
# 	the error (not very elegant...)
#
sub really_write {
	my $path = $_[0]; 
	my $content = $_[1]; 
	local *F; 

	open F, ">$path" and goto skip_mkdir; 

	my @pp = split('/', $path); pop @pp; 
	local($_); 
	my $dd; 
	for (@pp) {
		if (!defined($dd)) {
			($path =~ /^\//) and $dd = "/"; 
			$dd .= $_; 
		} else {
			$dd = "$dd/$_"; 
		}
		(-d $dd) or mkdir($dd,0755) or 
			return "could not mkdir $dd: $!\n"; 
	}
	open F, ">$path" or return "could not open $path for writing: $!\n"; 

skip_mkdir:
	print F $content or do {
		my $e = "can not write into $path: $!\n"; 
		close F; 
		return $e; 
	}; 
	close F or return "can not close $path: $!\n"; 
	return undef; 
}

## TEST
my $er = really_write("x/y/z", "xx"); $er and die $er; 
