# CGI_PARAM.pm -- cgi parameters grabber
# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 990808/991218

use strict; 
package CGI_PARAM;

#### how to use: 
# 
# my $c = new CGI_PARAM; 
# my @names = $c->param();  	names of all parameters
# my $val = $c->param("name1"); 	value of name1
# 
# same for cookies ($c->cookie())
# 
# if a file is uploaded, a temp dir must be set first, and then
# the value of that var, will be the pathname of the stored file: 
# 
# html:
# <form method=post action="foo.cgi" enctype="multipart/form-data">
# <input type=file name=my_file>
# <input type=submit value="go">
# </form>
# 
# cgi: 
# my $c = new CGI_PARAM;
# $c->temp_dir("/tmp"); 		# set temp dir
# my $filepath = $c->param("my_file"); 	# /tmp/...
# open FF, $filepath or die "$filepath: $!":
# print "Content-type: text/plain\n\nYour file: ", <FF>; 
# close FF;
# 

## self hash contains: 
#	params/cookies
#		$s->{'p'}->{name_a} = [value_a_1, value_a_2, ...]
#		$s->{'c'}->{name_a} = [value_a_1, value_a_2, ...]
#	temp directory to upload files into
#		$s->{'temp_dir'}
#

sub new {
	my $class = shift; 
	my $self = {}; 
	bless $self, $class; 
	$self->init(@_); 
	return $self; 
}

sub DESTROY {}
sub init {}

# minor compat with real CGI.pm
#
sub script_name {
	return $ENV{'SCRIPT_NAME'}; 
}

sub header {
	return "Content-type: text/html\n\n"; 
}

# utils
#

sub html_quote {
	my $s = shift; 
	local $_ = shift;
	s/\&/&amp;/sg;
	s/\</&lt;/sg;
	s/\>/&gt;/sg;
	return $_; 
}

sub value_quote {
	my $s = shift; 
	local $_ = shift;
	s/[&<>"#%\n\r]/"&#".ord($&).";"/seg; 
	return $_; 
}

sub url_quote {
	my $s = shift; 
	local $_ = shift; 
	s/[^a-zA-Z0-9\/.-]/sprintf("%%%02X", ord($&))/seg; 
	return $_; 
}

sub url_unquote {
	my $s = shift; 
	local $_ = shift; 
	y/+/ /; 
	s/%([0-9a-fA-F]{2})/chr(hex($1))/seg; 
	return $_; 
}

sub _multi_part {
	my $s = shift; 
	local $_ = $ENV{'CONTENT_TYPE'}; 
	return 0 unless (m#multipart/form-data#);

	my $bound; 
	s/^.*boundary=// or die "can't find boundary"; 
	if (s/^"//) {
		s/".*$//; 
		$bound = $_; 
	} else {
		$_ .= "; "; 	## add a fake separator
		($bound) = /^(.*?);\s+/; 
	}
	$bound eq "" and die "empty boundary ($bound)"; 
	$bound = "--".$bound; 
	my $nleft = $ENV{'CONTENT_LENGTH'}; 
	my $state=0; 
	my ($name, $filename, $value, $file_opened); 
	local (*F, $.); 
	for (;;) {
		$nleft or last; 
		$_ = <STDIN>; $nleft -= length; $nleft>=0 or die "invalid read";
		defined $_ or die "should have more to read"; 
		$nleft == 0 and s/--\r\n$/\r\n/; # last bound in suffixed by --

		$state==0 and do {	# get boundary
			s/\r\n$// or die "invalid header"; 
			$_ eq $bound or die "input data has no boundary"; 
			$state=1; next; 
		}; 
		$state==1 and do {	# get name=xx; filename=yy
			s/\r\n$// or die "invalid header"; 
			if ($_ eq "") {
				# end of header
				$name eq "" and 
					die "couldn't find valid header"; 
				$state=2; next; 
			}
			my @a = split /;\s+/; 
			for (@a) {
				my @b = split /=/; 
				$b[0] eq "name" and $name = $b[1]; 
				$b[0] eq "filename" and $filename = $b[1]; 
			}
			$name =~ s/^"// and $name =~ s/"$//; 
			$filename =~ s/^"// and $filename =~ s/"$//; 
			next; 
		}; 
		$state==2 and do {	# get data 
			my $b = $bound . "\r\n"; 
			if ($b eq $_) {
				$state = 1; 
				push @{ $s->{'p'}->{$name} }, $value; 
				if ($file_opened) {
					# F will contain an extra \r\n on end
					my $len = tell F; 
					$len -= 2; 
					$len >= 0 and truncate F, $len; 
					close F; 
				};
				undef $name; undef $filename; 
				undef $value; undef $file_opened; 
				next ; 
			}
			if ($filename eq "") {
				s/\r\n$//; 
				$value .= $_;
				next; 
			} 
			# uploading a filename
			if (!$file_opened) {
				$s->{'temp_dir'} eq "" and
					die "no temporary dir defined"; 
				$filename =~ s#^.*/##; 
				$filename eq "" and die "bad filename"; 
				$filename = $s->{'temp_dir'}."/".$filename;
				open F, ">$filename" or 
					die "can't open file for write: $!"; 
				$file_opened++; 
			}
			$value eq "" and $value = $filename; 
			print F; next; 
		}; 
		die "bad state machine value: $state"; 
	}
	return 1; 
}

sub _param_init {
	my $s = shift; 
	my $mode = shift; 

	$s->{$mode} = {}; 
	my $data = ""; 
	my $delim = "x"; 
	if ($mode eq "c") { 	## cookies mode
		$delim = ";\\s+"; 
		$data = $ENV{"HTTP_COOKIE"};
	} else {		## param mode
		$delim = "&"; 
		if ($ENV{'REQUEST_METHOD'} eq "POST") {
			return if ($s->_multi_part()); 

			read STDIN, $data, $ENV{'CONTENT_LENGTH'} 
				or die "can't read POST data: $!"; 
			length($data) != $ENV{'CONTENT_LENGTH'}+0 
				or die "incomplete read from POST data: $!"; 
		} else {
			$data = $ENV{'QUERY_STRING'}; 
		}
	}

	my @pairs = split /$delim/, $data;
	for (@pairs) {
		my @p = split /=/, $_, 2;
		next if (@p==0); 
		$p[1] = "" if (@p==1); 

		for my $p (@p) {
			$p =~ y/+/ /;
			$p =~ s/%(..)/chr(hex($1))/seg;
		}
		push @{ $s->{$mode}->{$p[0]} }, $p[1]; 
	}
}

sub _param {
	my $s = shift; 

	my $mode = shift; # p/c -- param or cookie
	exists $s->{$mode} or $s->_param_init($mode); 

	if (@_ == 0) {
		## no args: return all param names
		return keys %{ $s->{$mode} }; 
	}
	local $_ = shift; 
	return wantarray ? $s->{$mode}->{$_} : $s->{$mode}->{$_}->[0]; 
}

sub param  { my $s = shift; return $s->_param("p", @_) }
sub cookie { my $s = shift; return $s->_param("c", @_) }

sub temp_dir {
	my $s = shift;
	if (@_ == 0) {
		return $s->{'temp_dir'}; 
	}
	$s->{'temp_dir'} = $_[0]; 
}

## debug function
#sub ddd {local *F; open F, ">>/tmp/x1" and print F "*", @_,"\n" and close F;}

1; 

__END__

package main; 

my $c = new CGI_PARAM; 
my $x = $c->param('x'); print ":$x:\n"; 
my @a = $c->param(); print join(' ', @a), "\n"; 
print ":", join ' ', $c->cookie(), ":\n"; 

