# quote.pl -- quote perl data, for later eval
# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 990815

use strict; 

# returns SCALAR with all metacharacters conveniently escaped in order a 
# later "$xx" will work ...
#
{my @squote_a; {
	local $_; 
	for (0..31, 127..256) {
		$squote_a[$_] = sprintf "\\%03o", $_; 
	} 
	for (32..126) {
		$squote_a[$_] = chr $_ 
	} 
	for ("\$", "\@", "\\", "\"") { 
		$squote_a[ord $_] = "\\".$_ 
	}
	$squote_a[ord("\n")] = "\\n"; 
	$squote_a[ord("\t")] = "\\t"; 
	$squote_a[ord("\r")] = "\\r"; 
}

sub squote {
	local $_ = shift;
	s/./$squote_a[ord $&]/sg; 
	return $_;
}}

sub squote2 {
	local $_ = shift;
	s/./ord($&)<32 ||
	    ord($&)>=127 ||
	    $& eq '$' ||
	    $& eq '@' ||
	    $& eq "\\" ||
	    $& eq "\"" ? sprintf "\\%03o", ord($&) : $&/seg;
        return $_;
}

## TEST
my $n = 9999; 
my $s; 
$s .= chr(int(rand()*256)) while ($n--); 
my $t = squote($s); 
print "\$t = \"$t\";\n";
eval "\$t = \"$t\"; "; 
print $s eq $t ? "ok" : "bad"; 
print "\n"; 
