# html_escape.pl -- escape html text
# $Id$
# Carlos Duarte, 990207/990222

use strict; 

# args: t1, t2, ...
# ret: escaped t1, escaped t2, ... 
sub html_escape {
	my $hh; 
	my @out; 
	while (defined($hh = shift)) {
		$hh =~ s/&/&amp;/g;
		$hh =~ s/\"/&quot;/g;
		$hh =~ s/</&lt;/g;
		$hh =~ s/>/&gt;/g;
		push(@out, $hh);
	}
	return @out; 
}

# test
print &html_escape(<<'EOF'),"\n"; 
<html>
<body>
<h1> 1 </h1>
<p> par ""##$$%%&&
<br>
<p> par2
</body>
</html>
EOF
