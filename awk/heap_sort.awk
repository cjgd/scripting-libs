# heap_sort.awk -- heap sort on awk
# $Id$
# Carlos Duarte, 981009

## works only on arrays indexed [1..n]

function heap_sort(arr, n, 	i,t) {
	make_heap(arr, n)
	for (i=n; i>1; i--) {
		t = arr[1]
		arr[1] = arr[i]
		arr[i] = t
		sift_down(arr, i-1, 1)
	}
}

function make_heap(arr, n,	i) {
	for (i=int(n/2); i>=1; i--)
		sift_down(arr, n, i)
}

function sift_down(arr, n, i,	k,j,t) {
	k = i
	do {
		j = k
		if (2*j <= n && arr[2*j]>arr[k])
			k = 2*j
		if (2*j < n && arr[2*j+1]>arr[k])
			k = 2*j+1
		t = arr[j]
		arr[j] = arr[k]
		arr[k] = t
	} while (j != k);
}

# main
{ x[++n] = $0 }
END { heap_sort(x, n); for (i=1; i<=n; i++) print x[i] }
