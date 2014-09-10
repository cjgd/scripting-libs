# cvs.awk -- awk functions related with cvs 
# Carlos Duarte, 030924

#@include join.awk
# or awk -f join.awk -f cvs.awk ... 

# receive a revision and returns the previous revision
function prev_rev(s,        A, n) {
        n= split(s, A, /\./)
        if (A[n]> 1) {
                A[n] -- 
                return join(A, n, ".")
        }
        return join(A, n-2, ".")
}

BEGIN {
	s = "1.5.6.1"; printf "%s <- %s\n", s, prev_rev(s)
	s = "1.7"; printf "%s <- %s\n", s, prev_rev(s)
}
