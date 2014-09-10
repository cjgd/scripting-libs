# sendmail.pm -- send mail to someone using system tools
# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 990621/990815

use strict; 
package Mail;

my @mailers = split /\s+/,<<'EOF'; 
	/usr/bin/mailx 
	/usr/bin/mail
	/usr/ucb/Mail
	/bin/mail
	/usr/sbin/sendmail
	/usr/lib/sendmail
EOF

sub new {
	my $proto = shift; 
	my $class = ref($proto) || $proto; 
	my $self = {}; 
	bless($self, $class); 

	$self->init() or return undef; 
	return $self; 
}

sub init {
	my $self = shift; 

	$ENV{'MAILER'} and unshift @mailers, $ENV{'MAILER'}; 
	local ($_) = grep {-x} @mailers; 
	$_ eq "" and return 0;

	## flags to set:
	#$self->{'f_subj_s'}	--> accepts -s 'subject' on command line
	#$self->{'f_subj_h'}	--> accepts 'Subject: subject' on body
	#$self->{'f_tildes'}	--> expands ~<char> if the first char of line

	/\/Mail$/ and do {
		$self->{'f_subj_s'}++; 
		$self->{'f_tildes'}++; 
		goto done; 
	}; 
	/\/mailx$/ and do {
		$self->{'f_subj_s'}++;
		$self->{'f_tildes'}++;
		goto done; 
	}; 
	/\/mail$/ and do {
		$self->{'f_tildes'}++;
		`uname` =~ /^linux/i and $self->{'f_subj_s'}++;
		goto done; 
	}; 
	/\/sendmail$/ and do {
		$self->{'f_subj_h'}++; 
	}; 
done: 
	$self->{'mailer'} = $_; 
	return 1; 
}

sub send { 			# $subject, $msg, @to
	my $self = shift; 
	my $subject = shift; 
	local $_ = shift; 		# msg
	my $guys = join ' ', @_; 	# to

	my $cmd = "|" . $self->{'mailer'}; 
	if ($self->{'f_subj_s'}) {
		$subject =~ s/'/'\\''/g; 
		$cmd .= " -s '$subject'"; 
	}
	$cmd .= " " . $guys; 

	local *SM; 
	open(SM, $cmd) or return 0; 
	if ($self->{'f_subj_h'}) {
		print SM "Subject: $subject\n\n" or return 0; 
	}
	if ($self->{'f_tildes'}) {
		$_ = "\n" . $_; 
		s/\n~/$&~/gs; 
		$_ = substr($_, 1); 
	}
	chomp; $_ .= "\n"; 	# add a trailing \n to msg, if not there
	print SM or return 0; 
	close SM; 
	return 1; 
}

1; 

__END__

package main; 

my $sm = new Mail; 
$sm->send("my subject", "my message
qwerty
uiop
asdfg
hjkl
zxcvbnm", 'abc@teleweb.pt', 'bcd@teleweb.pt'); 

print $sm->{'f_tildes'}; print "\n"; 
print $sm->{'f_subj_s'}; print "\n"; 
print $sm->{'mailer'}; print "\n"; 
