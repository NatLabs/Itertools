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
         { name = "itertools",
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


- [HashMap](https://internetcomputer.org/docs/current/references/motoko-ref/hashmap#hashmap-1)
    - `map.entries()`

 For conversion of other data types to iterators, you can look in the [base library](https://internetcomputer.org/docs/current/references/motoko-ref/array) for the specific data type's documentation.


 Here are some examples of using the functions in this library to create simple and 
 efficient iterators for solving different problems:

 - An example, using `range` and `sum` to find the sum of values from 1 to 25:
 
 ```motoko
     let range = Itertools.range(1, 25 + 1);
     let sum = Itertools.sum(range);

     assert sum == ?325;
 ```


 - An example, using multiple functions to retrieve the indices of all even numbers in an array:

 ```motoko
     let vals = [1, 2, 3, 4, 5, 6].vals();
     let iterWithIndices = Itertools.enumerate(vals);

     let isEven = func ( x : (Int, Int)) : Bool { x.1 % 2 == 0 };
     let mapIndex = func (x : (Int, Int)) : Int { x.0 };
     let evenIndices = Itertools.filterMap(iterWithIndices, isEven, mapIndex);

     assert Iter.toArray(evenIndices) == [1, 3, 5];
 ```


 - An example to find the difference between consecutive elements in an array:

 ```motoko
     let vals = [5, 3, 3, 7, 8, 10].vals();
     
     let tuples = Itertools.slidingTuples(vals);
     // Iter.toArray(tuples) == [(5, 3), (3, 7), (3, 8), (7, 10)]
     
     let diff = func (x : (Int, Int)) : Int { x.1 - x.0 };
     let iter = Iter.map(tuples, diff);
 
     assert Iter.toArray(iter) == [-2, 0, 4, 1, 2];
 ```

## Contributing
Any contributions to this library are welcome. 
Ways you can contribute:
- Fix a bug
- Implement a [function that hasn't been implemented yet](#unimplemented-methods)
- Make a function more efficient
- Suggest a new function to add to the library

For adding functions create an issue so we can discuss it.

## Documentation 
For a complete lists of functions and data types, see the [Itertools documentation](https://tomijaga.github.io/Itertools.mo/index.html)


### PeekableIter

- [x] [fromIter](https://tomijaga.github.io/Itertools.mo/PeekableIter.html#fromIter)
  
### Deiter - (Double-Ended Iterator)

- [x] [rev](https://tomijaga.github.io/Itertools.mo/Deiter.html#rev), [range](https://tomijaga.github.io/Itertools.mo/Deiter.html#range), [intRange](https://tomijaga.github.io/Itertools.mo/Deiter.html#intRange), [fromArray](https://tomijaga.github.io/Itertools.mo/Deiter.html#fromArray), [toArray](https://tomijaga.github.io/Itertools.mo/Deiter.html#toArray), [fromArrayMut](https://tomijaga.github.io/Itertools.mo/Deiter.html#fromArrayMut), [toArrayMut](https://tomijaga.github.io/Itertools.mo/Deiter.html#toArrayMut), [fromDeque](https://tomijaga.github.io/Itertools.mo/Deiter.html#fromDeque), [toDeque](https://tomijaga.github.io/Itertools.mo/Deiter.html#toDeque)

### Iter

#### Integer Iterator Methods

- [x] [sum](https://tomijaga.github.io/Itertools.mo/Iter.html#sum)

- [x] [product](https://tomijaga.github.io/Itertools.mo/Iter.html#product)

#### Generic Iterator Methods

- [x] [accumulate](https://tomijaga.github.io/Itertools.mo/Iter.html#accumulate)

- [x] [all](https://tomijaga.github.io/Itertools.mo/Iter.html#all)

- [x] [any](https://tomijaga.github.io/Itertools.mo/Iter.html#any)

- [x] [chain](https://tomijaga.github.io/Itertools.mo/Iter.html#chain)

- [x] [chunk](https://tomijaga.github.io/Itertools.mo/Iter.html#chunk)

- [x] [cycle](https://tomijaga.github.io/Itertools.mo/Iter.html#cycle)

- [x] [enumerate](https://tomijaga.github.io/Itertools.mo/Iter.html#enumerate)

- [x] [find](https://tomijaga.github.io/Itertools.mo/Iter.html#find)

- [x] [findIndex](https://tomijaga.github.io/Itertools.mo/Iter.html#findIndex)

- [x] [filterMap](https://tomijaga.github.io/Itertools.mo/Iter.html#filterMap)

- [x] [max](https://tomijaga.github.io/Itertools.mo/Iter.html#max)

- [x] [min](https://tomijaga.github.io/Itertools.mo/Iter.html#min)

- [x] [minmax](https://tomijaga.github.io/Itertools.mo/Iter.html#minmax)

- [x] [nth](https://tomijaga.github.io/Itertools.mo/Iter.html#nth)

- [x] [nthOrDefault](https://tomijaga.github.io/Itertools.mo/Iter.html#nthOrDefault)

- [x] [peekable](https://tomijaga.github.io/Itertools.mo/Iter.html#peekable)

- [x] [range](https://tomijaga.github.io/Itertools.mo/Iter.html#range)

- [x] [intRange](https://tomijaga.github.io/Itertools.mo/Iter.html#intRange)

- [x] [ref](https://tomijaga.github.io/Itertools.mo/Iter.html#ref)

- [x] [repeat](https://tomijaga.github.io/Itertools.mo/Iter.html#repeat)

- [x] [skip](https://tomijaga.github.io/Itertools.mo/Iter.html#skip)
  
- [x] [slidingTuples](https://tomijaga.github.io/Itertools.mo/Iter.html#slidingTuples)
  
- [x] [slidingTriples](https://tomijaga.github.io/Itertools.mo/Iter.html#slidingTriples)

- [x] [splitAt](https://tomijaga.github.io/Itertools.mo/Iter.html#splitAt)

- [x] [spy](https://tomijaga.github.io/Itertools.mo/Iter.html#spy)

- [x] [stepBy](https://tomijaga.github.io/Itertools.mo/Iter.html#stepBy)

- [x] [take](https://tomijaga.github.io/Itertools.mo/Iter.html#take)

- [x] [takeWhile](https://tomijaga.github.io/Itertools.mo/Iter.html#takeWhile)

- [x] [tee](https://tomijaga.github.io/Itertools.mo/Iter.html#tee)

- [x] [tuples](https://tomijaga.github.io/Itertools.mo/Iter.html#tuples)

- [x] [triples](https://tomijaga.github.io/Itertools.mo/Iter.html#triples)

- [x] [unzip](https://tomijaga.github.io/Itertools.mo/Iter.html#unzip)

- [x] [zip](https://tomijaga.github.io/Itertools.mo/Iter.html#zip)

- [x] [zip3](https://tomijaga.github.io/Itertools.mo/Iter.html#zip3)

#### Unimplemented Methods

- [ ] advanceBy
  
- [ ] combinations
  
- [ ] cartesianProduct

- [ ] fold

- [ ] inspect

- [ ] isSorted

- [ ] isParititioned

- [ ] intersperse

- [ ] interleave

- [ ] mapWhile

- [ ] merge

- [ ] kmerge

- [ ] reduce

- [ ] sortedMerge

- [ ] partition

- [ ] partitionInPlace

- [ ] permutations

- [ ] skipWhile

- [ ] successor/unfold

- [ ] zipLongest
