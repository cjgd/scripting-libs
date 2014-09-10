# merge_sort.awk -- implements merge sort 
# $Id$ 
# Carlos Duarte, 981007

function merge_sort(arr, a, b, 		k) {
	if (a<b) {
		k = int((a+b)/2)
		merge_sort(arr, a, k)
		merge_sort(arr, k+1, b)
		merge(arr,a,k,b)
	}
}

function merge(arr, a, k, b, 	i,j,p,c) {
	j = i = a
	p = k+1
	while (a <= k && p <= b) {
		if (arr[a] <= arr[p]) {
			c[i++] = arr[a++]
		} else {
			c[i++] = arr[p++]
		}
	}
	while (a <= k) c[i++] = arr[a++]
	while (p <= b) c[i++] = arr[p++]

	while (j<=b) {
		arr[j] = c[j]
		j++
	}
}

## main
function pr(arr,i,j) { while (i<=j) print arr[i++] }
{ x[++i] = $0 }
END { merge_sort(x, 1, i); pr(x, 1, i); }
