# str_to_argv.pl -- converts a string to an array, with sh(1) like quotes
# Carlos Duarte, 010914

sub str_to_argv {
        local $_ = shift;
	# fast way
	not /['"\\]/ and return split ' '; 
	my @a; 
	while (length) {
		s/^\s*//s; 
		s/^''// and next;
		s/^""// and next;
		if (/^['"]/) {
			# find until next non-backslashed ' or "" 
			s/^(.)(.*?[^\\])\1//s; 
			push @a, $2; 
		} else {
			# find until next space
			s/^\S+//s; 
			push @a, $&; 
		}
	}
	for (@a) {
		s/\\(.)/$1/sg; 
	}
	return @a; 
}

sub t {
	local $_ = shift;
	my @a = str_to_argv($_); 
	print "===> $_\n"; 
	for (@a) {
		print $_, "\n"; 
	}
}

t 'abc 123  ';
t "-d 'abc xpto' -x \"asdasd \\\" xpto \\ \""; 
t "''"; 
