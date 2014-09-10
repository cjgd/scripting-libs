# bubble_sort.awk  -- bubble sort in awk
# $Id$
# Carlos Duarte, 981008


function bubble_sort(arr, a, b, 	i,done,t) {
	i = a
	done = 1
	for (;;) {
		if (i == b) {
			if (done)
				break
			i = a
			done = 1
		}
		if (arr[i] > arr[i+1]) {
			t = arr[i]
			arr[i] = arr[i+1]
			arr[i+1] = t
			done = 0
		}
		i = i+1
	}
}


# main
{ x[++n] = $0 }
END { bubble_sort(x, 1, n); for (i=1; i<=n; i++) print x[i] }
