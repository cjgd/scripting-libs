# quick_sort.awk -- quick sort algorithm
# $Id$
# Carlos Duarte, 981008


function quick_sort(arr, a, b, 		pivot,i,j,t) {

	if (a >= b)
		return 

	if (a+1 == b) {
		if (arr[a] > arr[b]) {
			t = arr[a]
			arr[a] = arr[b]
			arr[b] = t
		}
		return 
	}

	pivot = median(arr[a], arr[b], arr[int((a+b)/2)])
	i = a-1; 
	j = b+1; 
	for (;;) {
		while (arr[++i] < pivot)
			; 
		while (arr[--j] > pivot)
			; 

		if (i>=j)
			break

		t = arr[i]
		arr[i] = arr[j]
		arr[j] = t
	}
	quick_sort(arr, a, i-1)
	quick_sort(arr, i, b)
}

function median(a, b, c) {
	if (a<b) {
		if (b<c)
			return c
		if (a<c)
			return c
		return a
	}
	if (a<c)
		return c
	if (b<c)
		return c
	return b
}

# main
{ x[++n] = $0 }
END { quick_sort(x, 1, n); for (i=1; i<=n; i++) print x[i] }
