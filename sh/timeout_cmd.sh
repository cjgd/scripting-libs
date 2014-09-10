# timeout_cmd.sh -- executes a cmd for no more than N seconds
# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 990610

# timeout_cmd nr_secs cmd args....
# 	run cmd, for no more than N nr_seconds
#	elapsed time will be MIN(nr_secs, cmd normal end time)
#
timeout_cmd() {
	secs=$1
	shift
	"$@" &
	pid=$!
	sleep $secs && kill $pid >/dev/null 2>&1 &
	pid2=$!
	wait $pid
	kill $pid2 >/dev/null 2>&1
}

## TEST
date
timeout_cmd 5 ping 127.0.0.1
date
timeout_cmd 5 sleep 2
date

