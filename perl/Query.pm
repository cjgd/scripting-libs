# query.pm -- runs sql queries
# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 991101

use strict; 
use DBI; 

package Query; 

sub new {
	my $class = shift; 
	my $self = {}; 
	bless $self, $class;
	$self->init(@_); 	# new args
	return $self; 
}

sub DESTROY {
	my $self = shift; 
	$self->finit(); 
}

sub init { 
	my $self = shift; 

	( $self->{'db_source'}, 
	$self->{'db_user'}, 
	$self->{'db_pass'} ) = @_; 

	undef $self->{'sp_code'}; 	# holds return values
	undef $self->{'dbh'}; 		# dbi connection handle
	undef $self->{'pid'}; 		# isql pid
	undef $self->{'mode'}; 		# run mode: isql/dbi
	undef $self->{'isql'}; 		# isql path
}

# sets or gets current isql path
sub isql_path {
	my $s = shift; 
	if (@_) {
		$s->{'isql'} = $_[0]; 
	} 
	return $s->{'isql'};
}

# set/get current running mode
sub mode {
	my $s = shift; 
	if (@_) {
		$s->{'mode'} = $_[0]; 
	}
	return $s->{'mode'};
}

sub finit {
	my $s = shift; 

	$s->run_isql_query(); 
	$s->run_dbi_query(); 
}

sub quote_str {
	my $self = shift; 

	local $_ = shift; 
	$_ eq "" and return "NULL";
	s/'/''/g; 
	return "'$_'"; 
}

sub query {
	my $s = shift; 
	my $mode = $s->{'mode'}; 
	if ($mode eq "isql") {
		return $s->run_isql_query(@_); 
	} elsif ($mode eq "dbi") {
		return $s->run_dbi_query(@_); 
	} else {
		my $r;
		eval { local $SIG{'__DIE__'}; $r = $s->run_dbi_query(@_); };
		if ($@ || !$r) {
			$s->{'mode'} = "isql"; 
			return $s->query(@_); 
		}
		$s->{'mode'} = "dbi"; 
		return $r; 
	}
}

sub run_dbi_query {
	my $s = shift; 

	if ($_[0] eq "") {
		$s->{'dbh'} and $s->{'dbh'}->disconnect; 
		undef $s->{'dbh'}; 
		return undef; 
	}

        if (!$s->{'dbh'}) {
                $s->{'dbh'} = DBI->connect($s->{'db_source'}, $s->{'db_user'}, $s->{'db_pass'})
                        or die "can not connect: $DBI::errstr.";

                # show sql on errmsg
                $s->{'dbh'}->{'syb_show_sql'}++;

                # show extended info on errmsg
                $s->{'dbh'}->{'syb_show_eed'}++;

                $s->{'dbh'}->do("SET CHAINED OFF");
        }
        @_ == 0 and return undef;

	local $,=""; # concatenate args
        my $sth = $s->{'dbh'}->prepare(@_) or die "SQL prepare: $DBI::errstr.";
        $sth->execute or die "SQL exec: $DBI::errstr.";

	local $_; 
	$s->{'sp_code'} = 0; 
	my $result = []; 
	while (my @a = $sth->fetchrow_array) {
		if ($sth->{'syb_result_type'} == 4040) {
			push @$result, \@a;
		} elsif ($sth->{'syb_result_type'} == 4043) {
			$s->{'sp_code'} = $a[0]; 
		}
	}
        $sth->err and die "SQL exec'ing: $DBI::errstr.";
        return $result;
}

sub run_isql_query {
	my $s = shift; 

	local $_;
	if ($_[0] eq "") {
		if ($s->{'pid'}) {
			close R2; 
			close W1; 
			sleep 1; 
			kill 'TERM', $s->{'pid'}; 
			#kill 'KILL', $s->{'pid'}; 
			wait; 
		}
		undef $s->{'pid'}; 
		return undef; 
	}
	if (!$s->{'pid'}) {
		$_ = $s->{'db_source'}; 
		my ($server) = /server=(\w+)/; 
		my ($db) = /database=(\w+)/; 
		pipe R1, W1 or die "pipe :$!"; 
		pipe R2, W2 or die "pipe :$!"; 

		my $oldfh = select(W1); $| = 1; 
		select(W2); $| = 1;
		select($oldfh);

		$s->{'pid'} = fork; 
		defined $s->{'pid'} or die "fork: $!";
		if ($s->{'pid'} == 0) {
			open STDIN, "<&R1" or die "dup stdin: $!";
			open STDOUT, ">&W2" or die "dup stdout: $!";
			close R1; close R2; 
			close W1; close W2; 

			exec {$s->{'isql'} ? $s->{'isql'} : "isql"} "isql", 
				"-n", # do not prompt
				"-S", $server,
				"-U", $s->{'db_user'},
				"-P", $s->{'db_pass'} ;
			die "execing sql: $!"; 
		}
		# read from R2; write to W1
		close R1; close W2; 
		print W1 "use $db\ngo\n" or die "isql failed: $!"; 
		print W1 "set flushmessage on\ngo\n" or die "isql failed: $!"; 
	}
        @_ == 0 and return undef;

	## exec cmd
	print W1 join("\n",@_), "\ngo\n" or die "can't run query: $!"; 

	### HACK, isql buffers output, so, must run one command per query
	close W1; 
	### END HACK

	# get results
	my $result = []; 
	$s->{'sp_code'} = 0; 
	my @out; 
	for (;;) {
		my $rin; 
		vec($rin,fileno(R2),1) = 1;
		select($rin, undef, undef, 0.5) > 0 or last; 
		$_ = <R2>; defined $_ or last; 
		chomp; 
		push @out, $_; 
	}

	### HACK, isql buffers output, so, must run one command per query
	close R2; 
	undef $s->{'pid'}; 
	### END HACK

	my @ref; 
	while (@out) {
		shift @out while (@out && $out[0] eq ""); 

		die @out if ($out[0] =~ /^Msg/); ## error

		if ($out[0] =~ /return\s+status\s+=\s+(\d+)/) {
			$s->{'sp_code'} = $1; 
			shift @out; 
			next; 
		}

		if ($out[1] =~ /^ -+/) {
			shift @out; 
			## produce ref[0]->{offset, len}
			my ($off, $len) = (0,0); 
			while ($out[0] =~ s/^(\s+)(-+)//) {
				$off += length($1); 
				$len = length($2); 
				push @ref, { off => $off, len => $len}; 
				$off += $len; 
			}
			shift @out; 
			next; 
		}

		my $flag=0;
		while ($out[0] =~ /^ /) {
			my @a; 
			for (my $i = 0; $i < @ref; $i++) {
				my ($off, $len) = 
					($ref[$i]->{'off'}, $ref[$i]->{'len'});
				push @a, substr($out[0], $off, $len); 
			}
			push @$result, \@a;
			shift @out; 
			$flag++; 
		}
		next if $flag; 

		if ($out[0] =~ /^\(/) {
			# ingore nr of rows affected info
			shift @out; 
			next; 
		}

		print ":$out[0]:\n"; 
		die @out, ":unexpect SQL format";
	}
	return $result;
}

1; 

__END__

package main; 
my $q = new Query("dbi:Sybase:server=CGD;database=UBS", "sa", ""); 
my $r = $q->query("select * from t"); 
my $n=0;
for (@$r) {
	printf "(%2d) ", ++$n ; 
	print ":$_->[0]: :$_->[1]: :$_->[2]:\n"; 
}
