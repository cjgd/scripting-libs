# insert_sort.awk -- insertion sort algorithm
# $Id$
# Carlos Duarte, 981007

# sorts array ARR[A..B]
function insert_sort(arr, a, b,		i,j,t) {
	for (i=a+1; i<=b; i++) {
		if (arr[i] > arr[i-1])
			continue
		t = arr[i]
		j=i-1
		do 
			arr[j+1] = arr[j]; 
		while (--j>0 && t < arr[j]);
		arr[j+1] = t
	}
}

# main
{ x[++n] = $0 }
END { insert_sort(x, 1, n); for (i=1; i<=n; i++) print x[i] }
