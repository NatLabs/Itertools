# Itertools

A library with utility functions and data types for creating efficient iterators in Motoko. This library is inspired by the itertools libraries in both [python](https://github.com/more-itertools/more-itertools) and [rust](https://github.com/rust-itertools/itertools).

## Documentation 
For a complete list of functions and data types, see the [Itertools documentation](https://mops.one/itertools/docs/Iter)

Demo: https://m7sm4-2iaaa-aaaab-qabra-cai.raw.ic0.app/?tag=1138180896

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
   - `Buffer.toArray(buffer).vals()`
  

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
- Reversing a list of integers and chunking them
```motoko
    import Itertools "mo:itertools/Iter";
    import RevIter "mo:itertools/RevIter";

    let arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    // create a Reversible Iterator from an array
    let iter = RevIter.fromArray(arr);

    // reverse iterator
    let rev_iter = iter.rev();

    // Reversible Iterator gets typecasted to an Iter type
    let chunks = Itertools.chunks(rev_iter, 3);

    assert Iter.toArray(chunks) == [
        [10, 9, 8], [7, 6, 5], [4, 3, 2], [1]
    ];

```
## Contributing
Any contributions to this library are welcome. 
Ways you can contribute:
- Fix a bug or typo
- Improve the documentation
- Make a function more efficient
- Suggest a new function to add to the library

## Tests
- Download and Install [vessel](https://github.com/dfinity/vessel) 
- Run `make test` 

## Modules and Functions
### PeekableIter
| | |
|-|-|
| Iter to PeekableIter | [fromIter](https://mops.one/itertools/docs/PeekableIter#fromIter) |


### RevIter (Reversible Iterators)
| | |
|-|-|
| Main Methods | [new](https://mops.one/itertools/docs/RevIter#new), [map](https://mops.one/itertools/docs/RevIter#map), [range](https://mops.one/itertools/docs/RevIter#range), [intRange](https://mops.one/itertools/docs/RevIter#intRange), |
| Collection to RevIter | [fromArray](https://mops.one/itertools/docs/RevIter#fromArray), [fromVarArray](https://mops.one/itertools/docs/RevIter#fromVarArray), [fromDeque](https://mops.one/itertools/docs/RevIter#fromDeque) |
| RevIter to Collection | [toArray](https://mops.one/itertools/docs/RevIter#toArray), [toVarArray](https://mops.one/itertools/docs/RevIter#toVarArray), [toDeque](https://mops.one/itertools/docs/RevIter#toDeque) |


### Iter
| | |
|-|-|
| Augmenting | [accumulate](https://mops.one/itertools/docs/Iter#accumulate),  [add](https://mops.one/itertools/docs/Iter#add), [countAll](https://mops.one/itertools/docs/Iter#countAll), [enumerate](https://mops.one/itertools/docs/Iter#enumerate), [flatten](https://mops.one/itertools/docs/Iter#flatten), [flattenArray](https://mops.one/itertools/docs/Iter#flattenArray), [intersperse](https://mops.one/itertools/docs/Iter#intersperse), [mapEntries](https://mops.one/itertools/docs/Iter#mapEntries), [mapWhile](https://mops.one/itertools/docs/Iter#mapWhile),[runLength](https://mops.one/itertools/docs/Iter#runLength),[pad](https://mops.one/itertools/docs/Iter#pad), [padWithFn](https://mops.one/itertools/docs/Iter#padWithFn), [partitionInPlace](https://mops.one/itertools/docs/Iter#partitionInPlace), [prepend](https://mops.one/itertools/docs/Iter#prepend), [successor](https://mops.one/itertools/docs/Iter#successor), [uniqueCheck](https://mops.one/itertools/docs/Iter#uniqueCheck) |
| Combining | [interleave](https://mops.one/itertools/docs/Iter#interleave), [interleaveLongest](https://mops.one/itertools/docs/Iter#interleaveLongest), [merge](https://mops.one/itertools/docs/Iter#merge), [kmerge](https://mops.one/itertools/docs/Iter#kmerge), [zip](https://mops.one/itertools/docs/Iter#zip), [zip3](https://mops.one/itertools/docs/Iter#zip3), [zipLongest](https://mops.one/itertools/docs/Iter#zipLongest) |
| Combinatorics | [combinations](https://mops.one/itertools/docs/Iter#combinations), [cartesianProduct](https://mops.one/itertools/docs/Iter#cartesianProduct), [permutations](https://mops.one/itertools/docs/Iter#permutations) |
| Look ahead | [peekable](https://mops.one/itertools/docs/Iter#peekable), [spy](https://mops.one/itertools/docs/Iter#spy) |
| Grouping | [chunks](https://mops.one/itertools/docs/Iter#chunks), [chunksExact](https://mops.one/itertools/docs/Iter#chunksExact), [groupBy](https://mops.one/itertools/docs/Iter#groupBy), [splitAt](https://mops.one/itertools/docs/Iter#splitAt), [tuples](https://mops.one/itertools/docs/Iter#tuples), [triples](https://mops.one/itertools/docs/Iter#triples), [unzip](https://mops.one/itertools/docs/Iter#unzip), |
| Repeating | [cycle](https://mops.one/itertools/docs/Iter#cycle), [repeat](https://mops.one/itertools/docs/Iter#repeat),  |
| Selecting | [find](https://mops.one/itertools/docs/Iter#find), [findIndex](https://mops.one/itertools/docs/Iter#findIndex), [findIndices](https://mops.one/itertools/docs/Iter#findIndices), [mapFilter](https://mops.one/itertools/docs/Iter#mapFilter),  [max](https://mops.one/itertools/docs/Iter#max), [min](https://mops.one/itertools/docs/Iter#min), [minmax](https://mops.one/itertools/docs/Iter#minmax), [nth](https://mops.one/itertools/docs/Iter#nth), [nthOrDefault](https://mops.one/itertools/docs/Iter#nthOrDefault), [skip](https://mops.one/itertools/docs/Iter#skip), [skipWhile](https://mops.one/itertools/docs/Iter#skipWhile),  [stepBy](https://mops.one/itertools/docs/Iter#stepBy), [take](https://mops.one/itertools/docs/Iter#take), [takeWhile](https://mops.one/itertools/docs/Iter#takeWhile), [unique](https://mops.one/itertools/docs/Iter#unique) |
| Sliding Window |[slidingTuples](https://mops.one/itertools/docs/Iter#slidingTuples), [slidingTriples](https://mops.one/itertools/docs/Iter#slidingTriples) |
| Summarising | [all](https://mops.one/itertools/docs/Iter#all), [any](https://mops.one/itertools/docs/Iter#any), [count](https://mops.one/itertools/docs/Iter#count), [equal](https://mops.one/itertools/docs/Iter#equal), [fold](https://mops.one/itertools/docs/Iter#fold), [mapReduce]( https://mops.one/itertools/docs/Iter#mapReduce), [notEqual](https://mops.one/itertools/docs/Iter#notEqual), [isSorted](https://mops.one/itertools/docs/Iter#isSorted), [isSortedDesc](https://mops.one/itertools/docs/Iter#isSortedDesc), [isPartitioned](https://mops.one/itertools/docs/Iter#isPartitioned), [isUnique](https://mops.one/itertools/docs/Iter#isUnique), [product](https://mops.one/itertools/docs/Iter#product), [reduce](https://mops.one/itertools/docs/Iter#reduce), [sum](https://mops.one/itertools/docs/Iter#sum), |
| Collection to Iter | [fromArraySlice](https://mops.one/itertools/docs/Iter#fromArraySlice), [fromTrieSet](https://mops.one/itertools/docs/Iter#fromTrieSet) | 
| Iter to Collection | [toBuffer](https://mops.one/itertools/docs/Iter#toBuffer), [toDeque](https://mops.one/itertools/docs/Iter#toDeque), [toText](https://mops.one/itertools/docs/Iter#toText), [toTrieSet](https://mops.one/itertools/docs/Iter#toTrieSet) |
| Others | [inspect](https://mops.one/itertools/docs/Iter#inspect), [range](https://mops.one/itertools/docs/Iter#range), [intRange](https://mops.one/itertools/docs/Iter#intRange),  [ref](https://mops.one/itertools/docs/Iter#ref), [sort](https://mops.one/itertools/docs/Iter#sort), [tee](https://mops.one/itertools/docs/Iter#tee),          |
