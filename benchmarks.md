# Time and Space Complexity
This list shows the time and space complexity for calling functions that summarise an iterator and return one or more values. Most of these run longer than constant time as they have to iterate over the values of the iter before returning the result.

### Functions
| Fn | Time | Space | Benchmarks | Comments |
|-|-|-|-|-|
| | | | | |
| `all()` | `O(n)` | `O(1)` | | |
| `any()` | `O(n)` | `O(1)` | | | 
| `count()` | `O(n)` | `O(1)` | | |
| `countAll()` | `O(n log n)` <br/> `O(n²)` | `O(n)` | | |
| `equal()` | `O(n)` | `O(1)` | | |
| `find()` | `O(n)` | `O(1)` | | | 
| `findIndex()` | `O(n)` | `O(1)` | | | 
| `fold()` | `O(n)` | `O(1)` | | | 
| `flattenArray()` | `O(1)` | `O(1)` | | | 
| `isPartitioned()` | `O(n)` | `O(1)` | | | 
| `isSorted()` | `O(n)` | `O(1)` | | | 
| `isSortedDesc()` | `O(n)` | `O(1)` | | | 
| `isUnique()` | `O(n log n)` <br/> `O(n²)` | `O(n)` | | | 
| `mapFilter()` | `O(n)` | `O(1)` | | |
| `mapReduce()` | - | - | | | 
| `max()` | `O(n)` | `O(1)` | | | 
| `min()` | `O(n)` | `O(1)` | | | 
| `minmax()` | `O(n)` | `O(1)` | | | 
| `nth()` | `O(n)` | `O(1)` | | | 
| `nthOrDefault()` | `O(n)` | `O(1)` | | | 
| `nth()` | `O(n)` | `O(1)` | | | 
| `partition()` | `O(n)` | `O(n)` | | | 
| `product()` | `O(n)` | `O(1)` | | | 
| `reduce()` | `O(n)` | `O(1)` | | | 
| `sum()` | `O(n)` | `O(1)` | | | 
| `unzip()` | `O(n)` | `O(n)` | | | 
| `toBuffer()` | `O(n)` | `O(n)` | | | 
| `toDeque()` | `O(n)` | `O(n)` | | | 
| `toList()` | `O(n)` | `O(n)` | | | 
| `toText()` | `O(n)` | `O(n)` | | | 
| `toTrieSet()` | `O(n log n)` | `O(n)` | | | 

### Iterator Adaptors

As we know calling an iterator (`text.chars()`) usually a `O(1)` operation but iterating over the elements in the iterator (`for (char in text.chars()) { ... }`) is an `O(n)` operation.

This list contains the time and space complexity for calling each function and for iterating over the returned iterator (eg. `toArray(text.chars())`).

| Fn | Time | Space | Time (toArray) | Space (toArray) | Benchmarks | Comments |
|-|-|-|-|-|-|-|
| | | | | | | |
| `accumulate()` | `O(1)` | `O(1)` | `O(n)` | `O(n)` | | | 
| `cartesianProduct(n, m)` where `n = first param` and `m = 2nd param`  | `O(1)` | `O(m)` | `O(n * m)` | `O(n * m)` | | |
| `chain()` | `O(1)` | `O(1)` | `O(n + m)` | O(n + m) | | |
| `chunks(size)` <br/> k = size <br/> where `1 <= k <= n`| `O(k)` | `O(k)` | `O(n)` | `O(n * k)` | | |
| `chunksExact(size)` <br/> k = size <br/> where `1 <= k <= n`| `O(k)` | `O(k)` | `O(n)` | `O(n * k)` | | |
| `combinations(n, m)` | `~O(1)` <br/> `O(k)` | `O(n)` | `O(n * k)` | O(n * k) | | |
| `cycle()` | `O(1)` | `O(n)` | `O(n * m)` | `O(m * n)` | | |
| `enumerate()` | `O(1)` | `O(1)` | `O(n)` | `O(n)` | | |
| `empty()` | `O(1)` | `O(1)` | `O(1)` | `O(1)` | | |
| `findIndices()` | `O(n)` | `O(1)` | `O(n)` | `O(n)` | | | 
| `flatten()` | `O(1)` | `O(1)` | `O(n * m)` | `O(n * m)` | | | 
| `flattenArray()` | `O(1)` | `O(1)` | `O(n * m)` | `O(n * m)` | | | 
| `groupBy()` | `O(n)` | `O(n)` | `O(n)` | `O(n)` | | 
| `inspect()` | `O(1)` | `O(1)` | `O(n)` | `O(n)` | | | 
| `interleave()` | `O(1)` | `O(1)` | `O(n + m)` | `O(n + m)` | | 
| `interleaveLongest()` | `O(1)` | `O(1)` | `O(n + m)` | `O(n + m)` | | |
| `intersperse()` | `O(1)` | `O(1)` | `O(n)` | `O(n)` | | |
| `intersperse()` | `O(1)` | `O(1)` | `O(n)` | `O(n)` | | |
| `mapEntries()` | `O(1)` | `O(1)` | `O(n)` | `O(n)` | | |
| `mapFilter()` | `O(n)` | `O(1)` | `O(n)` | `O(n)` | | |
| `mapWhile()` | `O(1)` | `O(1)` | `O(n)` | `O(n)` | | |
| `merge(n, m)` | `O(1)` | `O(1)` | `O(n + m)` | `O(n + m)` | | |
| ~`kmerge()` where `n is the size of the array` <br/> and `m is the iterator with the max size` | `O(n log n)` | `O(n)` | `O(m * n log n)` | `O(n)` | | |
| `pad()` | `O(1)` | `O(1)` | `O(max(n, m))` | `O(max(n, m))` | | |
| `padWithFn()` | `O(1)` | `O(1)` | `O(max(n, m))` | `O(max(n, m))` | | |
| `partitionInPlace()` | `~O(1)` | `O(n)` | `O(n)` | `O(n)` | | |
| `peekable()` | `O(1)` | `O(1)` | `O(n)` | `O(n)` | | |
| `permutations()` | `O(n)` | `O(n)` | `O(n! * n)` | `O(n! * n)` | | |
| `peekable()` | `O(1)` | `O(1)` | `O(n)` | `O(n)` | | |
| `range()` | `O(1)` | `O(1)` | `O(n)` | `O(n)` | | |
| `intRange()` | `O(1)` | `O(1)` | `O(n)` | `O(n)` | | |
| `repeat()` | `O(1)` | `O(1)` | `O(n)` | `O(n)` | | |
| `skip()` | `O(n)` | `O(1)` | `O(n)` | `O(n)` | | |
| `skipWhile()` | `O(n)` | `O(1)` | `O(n)` | `O(n)` | | |
| `slidingTuples()` | `O(1)` | `O(1)` | `O(n)` | `O(n)` | | |
| `slidingTuples()` | `O(1)` | `O(1)` | `O(n)` | `O(n)` | | |
| `sort()` | `O(n log n)` | `O(n)` | `O(n² log n)` | `O(n)` | | |
| `splitAt()` | `O(n)` | `O(n)` | `O(n)` | `O(n)` | | |
| `spy()` | `O(n)` | `O(n)` | `O(n)` | `O(n)` | | |
| `stepBy()` | `O(n)` | `O(1)` | `O(n)` | `O(n)` | | |
| `successor()` | `O(1)` | `O(1)` | `O(n)` | `O(n)` | | |
| `take()` | `O(1)` | `O(1)` | `O(n)` | `O(n)` | | |
| `takeWhile()` | `O(1)` | `O(1)` | `O(n)` | `O(n)` | | |
| `tee()` | `O(n)` | `O(n)` | `O(n)` | `O(n)` | | |
| `tuples()` | `O(1)` | `O(1)` | `O(n)` | `O(n)` | | |
| `triples()` | `O(1)` | `O(1)` | `O(n)` | `O(n)` | | |
| `unique()` | `O(n log n)` <br/> `O(n²)` | `O(n)` | `O(n² log n)` | `O(n)` | | |
| `uniqueCheck()` | `O(log n)` <br/> `O(n)` | `O(n)` | `O(n log n)` | `O(n)` | | |
| `zip()` | `O(1)` | `O(1)` | `O(n)` | `O(n)` | | |
| `zip3()` | `O(1)` | `O(1)` | `O(n)` | `O(n)` | | |
| `zipLongest()` | `O(1)` | `O(1)` | `O(n)` | `O(n)` | | |
| `fromArraySlice()` | `O(1)` | `O(1)` | `O(n)` | `O(n)` | | |
| `fromTrieSet()` | `O(1)` | `O(1)` | `O(n)` | `O(n)` | | |





























