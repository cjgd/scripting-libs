# join.awk -- array to string 
# Carlos Duarte, 030924

# joins A[1..n] into a SEP separated string
function join(A,n,sep,          s, i) {
        s=A[1]
        for (i=2; i<=n; i++)
                s = s sep A[i]
        return s; 
}

