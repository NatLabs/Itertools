# Time and Space Complexity
As we know calling an iterator (`text.chars()`) usually a `O(1)` operation but iterating over the elements in the iterator (`for (char in text.chars()) { ... }`) is an `O(n)` operation.

This list shows you the time and space complexity for calling each function and not for iterating over the returned iterator.

| Fn | Time | Space | Benchmarks | Comments |
|-|-|-|-|-|
| | | | | |
| `accumulate()` | `O(1)` | `O(1)` | | |
| `all()` | `O(n)` | `O(1)` | | |
| `any()` | `O(n)` | `O(1)` | | | 
| `cartesianProduct()` | `O(1)` | `O(n)` | | |
| `count()` | `O(n)` | `O(1)` | | |
| `countAll()` | `O(n log n)` <br/> `O(n²)` | `O(n)` | | |
| `count()` | `O(n)` | `O(1)` | | |
| `chain()` | `O(1)` | `O(1)` | | |
| `chunks(size)` <br/> k = size <br/> where `1 <= k <= n`| `O(k)` | `O(k)` | | |
| `chunksExact(size)` <br/> k = size <br/> where `1 <= k <= n`| `O(k)` | `O(k)` | | |
| `combinations()` | --- | --- | | |
| `cycle()` | `O(1)` | `O(n)` | | |
| `enumerate()` | `O(1)` | `O(1)` | | |
| `empty()` | `O(1)` | `O(1)` | | |
| `equal()` | `O(n)` | `O(1)` | | |
| `find()` | `O(n)` | `O(1)` | | | 
| `findIndex()` | `O(n)` | `O(1)` | | | 
| `findIndices()` | `O(n)` | `O(1)` | | | 
| `fold()` | `O(n)` | `O(1)` | | | 
| `flatten()` | `O(1)` | `O(1)` | | | 
| `flattenArray()` | `O(1)` | `O(1)` | | | 
| `groupBy()` | `O(1)` | `O(1)` | | | 
| `inspect()` | `O(1)` | `O(1)` | | | 
| `isSorted()` | `O(n)` | `O(1)` | | | 
| `isSortedDesc()` | `O(n)` | `O(1)` | | | 
| `mapReduce()` | - | - | | | 
| `max()` | `O(n)` | `O(1)` | | | 
| `min()` | `O(n)` | `O(1)` | | | 
| `minmax()` | `O(n)` | `O(1)` | | | 


| `mapFilter()` | `O(n)` | `O(1)` | | |

| Fn | Time | Space | Time (toArray) | Space (toArray) | Benchmarks | Comments |
|-|-|-|-|-|-|-|
| | | | | | | |
| `interleave()` | `O(1)` | `O(1)` | `O(n + m)` | `O(n + m)` | | 
| `interleaveLongest()` | `O(1)` | `O(1)` | `O(n + m)` | `O(n + m)` | | |
| `intersperse()` | `O(1)` | `O(1)` | `O(n)` | `O(n)` | | |
| `intersperse()` | `O(1)` | `O(1)` | `O(n)` | `O(n)` | | |
| `mapEntries()` | `O(1)` | `O(1)` | `O(n)` | `O(n)` | | |
| `mapFilter()` | `O(n)` | `O(1)` | `O(n)` | `O(n)` | | |
| `mapWhile()` | `O(1)` | `O(1)` | `O(n)` | `O(n)` | | |
| `merge(n, m)` | `O(1)` | `O(1)` | `O(n + m)` | `O(n + m)` | | |
| ~`kmerge()` where `n is the size of the array` <br/> and `m is the iterator with the max size` | `O(n log n)` | `O(n)` | `O(n * m)` | `O(n * m)` | | |









