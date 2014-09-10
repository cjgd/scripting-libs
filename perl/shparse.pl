# shparse.pl -- deals with sh(1) quoting mechanism (partial)
# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 990304

use strict; 

# @a = shunquote($line) 
# 	parse $line, and fill in @a all tokens 
# 	eg: sfplay 'that'\''s me', will be @a = ("sfplay", "that's me")
# 
# 	useful to exec: 
# 		exec $cmd --> exec shunquote $cmd;
# 
# "" not supported
sub shunquote {
	local($_) = @_; 

	/\\$/ && return ();

	my @ret; 
	my $t; 
	$_ .= " "; 
	for (;;) {
		s/^\s*//; 
		last unless (s/^\s*(.*?)([\s'\\])//);
		$t .= $1; 
		my $s = $2; 
		if ($s eq "'") {
			# unmatched '
			return () unless s/^(.*?)'//; 
			$t .= $1; 
		} elsif ($s eq "\\") {
			# \ escapes nothing
			return () unless s/^(.)//; 
			$t .= $1; 
		}
		next if ($s !~ /^\s/ && !/^\s/); 
		push(@ret, $t); $t = ""; 
	}
	return @ret; 
}

# @a = shquote(@a)
# 	escapes all elements of @a, in manner for them to be sh "safe"
# 	good for run system, for eg.
# 
# 	system("sfplay $music") --> fail it $music contains, for eg, spaces
# 	$" = " "; 
# 	system(shquote("sfplay", $music)) --> safer... 
# 
sub shquote {
	local($_); 

	for (@_) {
		s/'/'\\''/g; 
		$_ = "'$_'"; 
	}
	return @_; 
}


## TEST

# note the \\ means one \
my @a = &shunquote("arg1 'arg2' 'ar'\\''g3' 'arg4''' 'ar''''g5'"); 
for (@a) { print ":$_:\n"; }
print "\n"; 
@a = &shquote(@a); 
for (@a) { print ":$_:\n"; }
