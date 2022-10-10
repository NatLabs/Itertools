# Itertools

A library with utility functions and data types for creating efficient iterators in Motoko. This library is inspired by the itertools libraries in both [python](https://github.com/more-itertools/more-itertools) and [rust](https://github.com/rust-itertools/itertools).

This library is still a work in progress as there are a few [functions that have not been implemented yet](#unimplemented-methods). 

 ## Importing with vessel
Your `package-set.dhall` file should look like this:
 ```dhall
    let aviate_labs = https://github.com/aviate-labs/package-set/releases/download/v0.1.4/package-set.dhall

    let Package =
    { name : Text, version : Text, repo : Text, dependencies : List Text }

    let additions = [
        {   
            name = "itertools",
            version = "main",
            repo = "https://github.com/tomijaga/Itertools.mo",
            dependencies = ["base"] : List Text,
         }
     ] : List Package

in aviate_labs # additions

 ```
 ## Getting started

 To get started, you'll need to import the `Iter` module from both the base library and this one.

 ```motoko
     import Iter "mo:base/Iter";
     import Itertools "mo:itertools/Iter";
 ```
 
 Converting data types to iterators is the next step.
 - Array
     - `[1, 2, 3, 4, 5].vals()`
     - `Iter.fromArray([1, 2, 3, 4, 5])`


 - List
     - `Iter.fromList(list)`


 - Text
     - `"Hello, world!".chars()`
     - `Text.split("a,b,c", #char ',')`
 
 - Buffer
   - `buffer.toArray().vals()`
  

 For conversion of other data types to iterators, you can look in the [base library](https://internetcomputer.org/docs/current/references/motoko-ref/array) for the specific data type's documentation.


 Here are some examples of using the functions in this library to create simple and 
 efficient iterators for solving different problems:

 - An example, using `range` and `sum` to find the sum of values from 1 to 25:
 
 ```motoko
     let range = Itertools.range(1, 25 + 1);
     let sum = Itertools.sum(range);

     assert sum == ?325;
 ```


 - Splitting an array into chunks of size 3:

 ```motoko
     let vals = [1, 2, 3, 4, 5, 6].vals();
     let chunks = Itertools.chunks(vals, 3);

     assert Iter.toArray(chunks) == [[1, 2, 3], [4, 5, 6]];
 ```

 - Finding the difference between consecutive elements in an array:

 ```motoko
     let vals = [5, 3, 3, 7, 8, 10].vals();
     
     let tuples = Itertools.slidingTuples(vals);
     // Iter.toArray(tuples) == [(5, 3), (3, 3), (3, 7), (7, 8), (8, 10)]
     
     let diff = func (x : (Int, Int)) : Int { x.1 - x.0 };
     let iter = Iter.map(tuples, diff);
 
     assert Iter.toArray(iter) == [-2, 0, 4, 1, 2];
 ```

## Contributing
Any contributions to this library are welcome. 
Ways you can contribute:
- Fix a bug or typo
- Improve the documentation
- Implement a [function that hasn't been implemented yet](#unimplemented-methods)
- Make a function more efficient
- Suggest a new function to add to the library
  
## Documentation 
For a complete list of functions and data types, see the [Itertools documentation](https://natlabs.github.io/Itertools.mo/index.html)

Demo: https://m7sm4-2iaaa-aaaab-qabra-cai.raw.ic0.app/?tag=3946301136

### PeekableIter
| | |
|-|-|
| Iter to PeekableIter | [fromIter](https://natlabs.github.io/Itertools.mo/PeekableIter.html#fromIter) |


### Deiter - (Double-Ended Iterator)
| | |
|-|-|
| Main Methods |  [reverse](https://natlabs.github.io/Itertools.mo/Deiter.html#reverse), [range](https://natlabs.github.io/Itertools.mo/Deiter.html#range), [intRange](https://natlabs.github.io/Itertools.mo/Deiter.html#intRange), |
| Collection to DeIter | [fromArray](https://natlabs.github.io/Itertools.mo/Deiter.html#fromArray), [fromArrayMut](https://natlabs.github.io/Itertools.mo/Deiter.html#fromArrayMut), [fromDeque](https://natlabs.github.io/Itertools.mo/Deiter.html#fromDeque) |
| DeIter to Collection | [toArray](https://natlabs.github.io/Itertools.mo/Deiter.html#toArray), [toArrayMut](https://natlabs.github.io/Itertools.mo/Deiter.html#toArrayMut), [toDeque](https://natlabs.github.io/Itertools.mo/Deiter.html#toDeque) |


### Iter
| | |
|-|-|
| Augmenting | [accumulate](https://natlabs.github.io/Itertools.mo/Iter.html#accumulate), [countAll](https://natlabs.github.io/Itertools.mo/Iter.html#countAll), [enumerate](https://natlabs.github.io/Itertools.mo/Iter.html#enumerate), [flatten](https://natlabs.github.io/Itertools.mo/Iter.html#flatten), [flattenArray](https://natlabs.github.io/Itertools.mo/Iter.html#flattenArray), [intersperse](https://natlabs.github.io/Itertools.mo/Iter.html#intersperse), [mapEntries](https://natlabs.github.io/Itertools.mo/Iter.html#mapEntries), [mapWhile](https://natlabs.github.io/Itertools.mo/Iter.html#mapWhile), [pad](https://natlabs.github.io/Itertools.mo/Iter.html#pad), [padWithFn](https://natlabs.github.io/Itertools.mo/Iter.html#padWithFn), [partitionInPlace](https://natlabs.github.io/Itertools.mo/Iter.html#partitionInPlace), [prepend](https://natlabs.github.io/Itertools.mo/Iter.html#prepend), [successor](https://natlabs.github.io/Itertools.mo/Iter.html#successor), [uniqueCheck](https://natlabs.github.io/Itertools.mo/Iter.html#uniqueCheck) |
| Combining | [interleave](https://natlabs.github.io/Itertools.mo/Iter.html#interleave), [interleaveLongest](https://natlabs.github.io/Itertools.mo/Iter.html#interleaveLongest), [merge](https://natlabs.github.io/Itertools.mo/Iter.html#merge), [kmerge](https://natlabs.github.io/Itertools.mo/Iter.html#kmerge), [zip](https://natlabs.github.io/Itertools.mo/Iter.html#zip), [zip3](https://natlabs.github.io/Itertools.mo/Iter.html#zip3), [zipLongest](https://natlabs.github.io/Itertools.mo/Iter.html#zipLongest) |
| Combinatorics | [combinations](https://natlabs.github.io/Itertools.mo/Iter.html#combinations), [cartesianProduct](https://natlabs.github.io/Itertools.mo/Iter.html#cartesianProduct), [permutations](https://natlabs.github.io/Itertools.mo/Iter.html#permutations) |
| Look ahead | [peekable](https://natlabs.github.io/Itertools.mo/Iter.html#peekable), [spy](https://natlabs.github.io/Itertools.mo/Iter.html#spy) |
| Grouping | [chunks](https://natlabs.github.io/Itertools.mo/Iter.html#chunks), [chunksExact](https://natlabs.github.io/Itertools.mo/Iter.html#chunksExact), [groupBy](https://natlabs.github.io/Itertools.mo/Iter.html#groupBy), [splitAt](https://natlabs.github.io/Itertools.mo/Iter.html#splitAt), [tuples](https://natlabs.github.io/Itertools.mo/Iter.html#tuples), [triples](https://natlabs.github.io/Itertools.mo/Iter.html#triples), [unzip](https://natlabs.github.io/Itertools.mo/Iter.html#unzip), |
| Infinite | [cycle](https://natlabs.github.io/Itertools.mo/Iter.html#cycle), [repeat](https://natlabs.github.io/Itertools.mo/Iter.html#repeat),  |
| Selecting | [find](https://natlabs.github.io/Itertools.mo/Iter.html#find), [findIndex](https://natlabs.github.io/Itertools.mo/Iter.html#findIndex), [findIndices](https://natlabs.github.io/Itertools.mo/Iter.html#findIndices), [mapFilter](https://natlabs.github.io/Itertools.mo/Iter.html#mapFilter),  [max](https://natlabs.github.io/Itertools.mo/Iter.html#max), [min](https://natlabs.github.io/Itertools.mo/Iter.html#min), [minmax](https://natlabs.github.io/Itertools.mo/Iter.html#minmax), [nth](https://natlabs.github.io/Itertools.mo/Iter.html#nth), [nthOrDefault](https://natlabs.github.io/Itertools.mo/Iter.html#nthOrDefault), [skip](https://natlabs.github.io/Itertools.mo/Iter.html#skip), [skipWhile](https://natlabs.github.io/Itertools.mo/Iter.html#skipWhile),  [stepBy](https://natlabs.github.io/Itertools.mo/Iter.html#stepBy), [take](https://natlabs.github.io/Itertools.mo/Iter.html#take), [takeWhile](https://natlabs.github.io/Itertools.mo/Iter.html#takeWhile), [unique](https://natlabs.github.io/Itertools.mo/Iter.html#unique) |
| Sliding Window |[slidingTuples](https://natlabs.github.io/Itertools.mo/Iter.html#slidingTuples), [slidingTriples](https://natlabs.github.io/Itertools.mo/Iter.html#slidingTriples) |
| Summarising | [all](https://natlabs.github.io/Itertools.mo/Iter.html#all), [any](https://natlabs.github.io/Itertools.mo/Iter.html#any), [count](https://natlabs.github.io/Itertools.mo/Iter.html#count), [equal](https://natlabs.github.io/Itertools.mo/Iter.html#equal), [fold](https://natlabs.github.io/Itertools.mo/Iter.html#fold), [mapReduce]( https://natlabs.github.io/Itertools.mo/Iter.html#mapReduce), [notEqual](https://natlabs.github.io/Itertools.mo/Iter.html#notEqual), [isSorted](https://natlabs.github.io/Itertools.mo/Iter.html#isSorted), [isSortedDesc](https://natlabs.github.io/Itertools.mo/Iter.html#isSortedDesc), [isPartitioned](https://natlabs.github.io/Itertools.mo/Iter.html#isPartitioned), [isUnique](https://natlabs.github.io/Itertools.mo/Iter.html#isUnique), [product](https://natlabs.github.io/Itertools.mo/Iter.html#product), [reduce](https://natlabs.github.io/Itertools.mo/Iter.html#reduce), [sum](https://natlabs.github.io/Itertools.mo/Iter.html#sum), |
| Collection to Iter | [fromArraySlice](https://natlabs.github.io/Itertools.mo/Iter.html#fromArraySlice), [fromTrieSet](https://natlabs.github.io/Itertools.mo/Iter.html#fromTrieSet) | 
| Iter to Collection | [toBuffer](https://natlabs.github.io/Itertools.mo/Iter.html#toBuffer), [toDeque](https://natlabs.github.io/Itertools.mo/Iter.html#toDeque), [toText](https://natlabs.github.io/Itertools.mo/Iter.html#toText), [toTrieSet](https://natlabs.github.io/Itertools.mo/Iter.html#toTrieSet) |
| Others | [inspect](https://natlabs.github.io/Itertools.mo/Iter.html#inspect), [range](https://natlabs.github.io/Itertools.mo/Iter.html#range), [intRange](https://natlabs.github.io/Itertools.mo/Iter.html#intRange),  [ref](https://natlabs.github.io/Itertools.mo/Iter.html#ref), [sort](https://natlabs.github.io/Itertools.mo/Iter.html#sort), [tee](https://natlabs.github.io/Itertools.mo/Iter.html#tee),          |
  