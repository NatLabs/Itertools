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
For a complete list of functions and data types, see the [Itertools documentation](https://tomijaga.github.io/Itertools.mo/index.html)


### PeekableIter
|  |  |
| ---- | ------------------ |
| Iter to PeekableIter | [fromIter](https://tomijaga.github.io/Itertools.mo/PeekableIter.html#fromIter) |


### Deiter - (Double-Ended Iterator)
|  |  |
| ---- | ------------------ |
| Main Methods |  [reverse](https://tomijaga.github.io/Itertools.mo/Deiter.html#reverse), [range](https://tomijaga.github.io/Itertools.mo/Deiter.html#range), [intRange](https://tomijaga.github.io/Itertools.mo/Deiter.html#intRange), |
| Collection to DeIter | [fromArray](https://tomijaga.github.io/Itertools.mo/Deiter.html#fromArray), [fromArrayMut](https://tomijaga.github.io/Itertools.mo/Deiter.html#fromArrayMut), [fromDeque](https://tomijaga.github.io/Itertools.mo/Deiter.html#fromDeque) |
| DeIter to Collection | [toArray](https://tomijaga.github.io/Itertools.mo/Deiter.html#toArray), [toArrayMut](https://tomijaga.github.io/Itertools.mo/Deiter.html#toArrayMut), [toDeque](https://tomijaga.github.io/Itertools.mo/Deiter.html#toDeque) |


### Iter

|  |  |
| ---- | ------------------ |
| Augmenting | [accumulate](https://tomijaga.github.io/Itertools.mo/Iter.html#accumulate), [countAll](https://tomijaga.github.io/Itertools.mo/Iter.html#countAll), [enumerate](https://tomijaga.github.io/Itertools.mo/Iter.html#enumerate), [flatten](https://tomijaga.github.io/Itertools.mo/Iter.html#flatten), [flattenArray](https://tomijaga.github.io/Itertools.mo/Iter.html#flattenArray), [intersperse](https://tomijaga.github.io/Itertools.mo/Iter.html#intersperse), [mapEntries](https://tomijaga.github.io/Itertools.mo/Iter.html#mapEntries), [mapWhile](https://tomijaga.github.io/Itertools.mo/Iter.html#mapWhile), [pad](https://tomijaga.github.io/Itertools.mo/Iter.html#pad), [padWithFn](https://tomijaga.github.io/Itertools.mo/Iter.html#padWithFn), [partitionInPlace](https://tomijaga.github.io/Itertools.mo/Iter.html#partitionInPlace), [prepend](https://tomijaga.github.io/Itertools.mo/Iter.html#prepend), [successor](https://tomijaga.github.io/Itertools.mo/Iter.html#successor), [uniqueCheck](https://tomijaga.github.io/Itertools.mo/Iter.html#uniqueCheck) |
| Combining | [interleave](https://tomijaga.github.io/Itertools.mo/Iter.html#interleave), [interleaveLongest](https://tomijaga.github.io/Itertools.mo/Iter.html#interleaveLongest), [merge](https://tomijaga.github.io/Itertools.mo/Iter.html#merge), [kmerge](https://tomijaga.github.io/Itertools.mo/Iter.html#kmerge), [zip](https://tomijaga.github.io/Itertools.mo/Iter.html#zip), [zip3](https://tomijaga.github.io/Itertools.mo/Iter.html#zip3), [zipLongest](https://tomijaga.github.io/Itertools.mo/Iter.html#zipLongest) |
| Combinatorics | [combinations](https://tomijaga.github.io/Itertools.mo/Iter.html#combinations), [cartesianProduct](https://tomijaga.github.io/Itertools.mo/Iter.html#cartesianProduct), [permutations](https://tomijaga.github.io/Itertools.mo/Iter.html#permutations) |
| Look ahead | [peekable](https://tomijaga.github.io/Itertools.mo/Iter.html#peekable), [spy](https://tomijaga.github.io/Itertools.mo/Iter.html#spy) |
| Grouping | [chunks](https://tomijaga.github.io/Itertools.mo/Iter.html#chunks), [chunksExact](https://tomijaga.github.io/Itertools.mo/Iter.html#chunksExact), [groupBy](https://tomijaga.github.io/Itertools.mo/Iter.html#groupBy), [splitAt](https://tomijaga.github.io/Itertools.mo/Iter.html#splitAt), [tuples](https://tomijaga.github.io/Itertools.mo/Iter.html#tuples), [triples](https://tomijaga.github.io/Itertools.mo/Iter.html#triples), [unzip](https://tomijaga.github.io/Itertools.mo/Iter.html#unzip), |
| Infinite | [cycle](https://tomijaga.github.io/Itertools.mo/Iter.html#cycle), [repeat](https://tomijaga.github.io/Itertools.mo/Iter.html#repeat),  |
| Selecting | [find](https://tomijaga.github.io/Itertools.mo/Iter.html#find), [findIndex](https://tomijaga.github.io/Itertools.mo/Iter.html#findIndex), [findIndices](https://tomijaga.github.io/Itertools.mo/Iter.html#findIndices), [mapFilter](https://tomijaga.github.io/Itertools.mo/Iter.html#mapFilter),  [max](https://tomijaga.github.io/Itertools.mo/Iter.html#max), [min](https://tomijaga.github.io/Itertools.mo/Iter.html#min), [minmax](https://tomijaga.github.io/Itertools.mo/Iter.html#minmax), [nth](https://tomijaga.github.io/Itertools.mo/Iter.html#nth), [nthOrDefault](https://tomijaga.github.io/Itertools.mo/Iter.html#nthOrDefault), [skip](https://tomijaga.github.io/Itertools.mo/Iter.html#skip), [skipWhile](https://tomijaga.github.io/Itertools.mo/Iter.html#skipWhile),  [stepBy](https://tomijaga.github.io/Itertools.mo/Iter.html#stepBy), [take](https://tomijaga.github.io/Itertools.mo/Iter.html#take), [takeWhile](https://tomijaga.github.io/Itertools.mo/Iter.html#takeWhile), [unique](https://tomijaga.github.io/Itertools.mo/Iter.html#unique) |
| Sliding Window |[slidingTuples](https://tomijaga.github.io/Itertools.mo/Iter.html#slidingTuples), [slidingTriples](https://tomijaga.github.io/Itertools.mo/Iter.html#slidingTriples) |
| Summarising | [all](https://tomijaga.github.io/Itertools.mo/Iter.html#all), [any](https://tomijaga.github.io/Itertools.mo/Iter.html#any), [count](https://tomijaga.github.io/Itertools.mo/Iter.html#count), [equal](https://tomijaga.github.io/Itertools.mo/Iter.html#equal), [fold](https://tomijaga.github.io/Itertools.mo/Iter.html#fold), [mapReduce]( https://tomijaga.github.io/Itertools.mo/Iter.html#mapReduce), [notEqual](https://tomijaga.github.io/Itertools.mo/Iter.html#notEqual), [isPartitioned](https://tomijaga.github.io/Itertools.mo/Iter.html#isPartitioned), [isUnique](https://tomijaga.github.io/Itertools.mo/Iter.html#isUnique), [product](https://tomijaga.github.io/Itertools.mo/Iter.html#product), [reduce](https://tomijaga.github.io/Itertools.mo/Iter.html#reduce), [sum](https://tomijaga.github.io/Itertools.mo/Iter.html#sum), |
| Collection to Iter | [fromTrieSet](https://tomijaga.github.io/Itertools.mo/Iter.html#fromTrieSet) | 
| Iter to Collection | [toBuffer](https://tomijaga.github.io/Itertools.mo/Iter.html#toBuffer), [toDeque](https://tomijaga.github.io/Itertools.mo/Iter.html#toDeque), [toText](https://tomijaga.github.io/Itertools.mo/Iter.html#toText), [toTrieSet](https://tomijaga.github.io/Itertools.mo/Iter.html#toTrieSet) |
| Others | [inspect](https://tomijaga.github.io/Itertools.mo/Iter.html#inspect), [range](https://tomijaga.github.io/Itertools.mo/Iter.html#range), [intRange](https://tomijaga.github.io/Itertools.mo/Iter.html#intRange),  [ref](https://tomijaga.github.io/Itertools.mo/Iter.html#ref), [sort](https://tomijaga.github.io/Itertools.mo/Iter.html#sort), [tee](https://tomijaga.github.io/Itertools.mo/Iter.html#tee),          |


#### Unimplemented Methods

- [ ] isSorted
  
Demo: https://m7sm4-2iaaa-aaaab-qabra-cai.raw.ic0.app/?tag=3946301136