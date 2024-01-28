# Iter
Main module with utility functions for working efficiently with iterators.

See the [`Iter`](https://internetcomputer.org/docs/current/references/motoko-ref/iter#iter-1) module from the base lib for more information on the `Iter` type.


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

- [HashMap](https://internetcomputer.org/docs/current/references/motoko-ref/hashmap#hashmap-1)
       - `map.entries()`

For conversion of other data types to iterators, you can look in the [base library](https://internetcomputer.org/docs/current/references/motoko-ref/array) for the specific data type's documentation.


Here are some examples of using the functions in this library to create simple and
efficient iterators for solving different problems:

- An example, using `range` and `sum` to find the sum of values from 1 to 25:

```motoko
    let range = Itertools.range(1, 25 + 1);
    let sum = Itertools.sum(range, Nat.add);

    assert sum == ?325;
```


- An example, using multiple functions to retrieve the indices of all even numbers in an array:

```motoko
    let vals = [1, 2, 3, 4, 5, 6].vals();
    let iterWithIndices = Itertools.enumerate(vals);

    let isEven = func ( x : (Int, Int)) : Bool { x.1 % 2 == 0 };
    let mapIndex = func (x : (Int, Int)) : Int { x.0 };
    let evenIndices = Itertools.mapFilter(iterWithIndices, isEven, mapIndex);

    assert Iter.toArray(evenIndices) == [1, 3, 5];
```


- An example to find the difference between consecutive elements in an array:

```motoko
    let vals = [5, 3, 3, 7, 8, 10].vals();

    let tuples = Itertools.slidingTuples(vals);
    // Iter.toArray(tuples) == [(5, 3), (3, 3), (3, 7), (7, 8), (8, 10)]

    let diff = func (x : (Int, Int)) : Int { x.1 - x.0 };
    let iter = Iter.map(tuples, diff);

    assert Iter.toArray(iter) == [-2, 0, 4, 1, 2];
```

## Function `accumulate`
``` motoko no-repl
func accumulate<A>(iter : Iter.Iter<A>, predicate : (A, A) -> A) : Iter.Iter<A>
```

Returns a reference to a modified iterator that returns the accumulated values based on the given predicate.

### Example
- An example calculating the running sum of a iterator:

```motoko

    let vals = [1, 2, 3, 4].vals();
    let it = Itertools.accumulate(vals, func(a, b) { a + b });

    assert it.next() == ?1;
    assert it.next() == ?3;
    assert it.next() == ?6;
    assert it.next() == ?10;
    assert it.next() == ?null;
```

## Function `all`
``` motoko no-repl
func all<A>(iter : Iter.Iter<A>, predicate : (A) -> Bool) : Bool
```

Checks if all elements in the iterable satisfy the predicate.

### Example
- An example checking if all elements in a iterator of integers are even:

```motoko

    let a = [1, 2, 3, 4].vals();
    let b = [2, 4, 6, 8].vals();

    let isEven = func(a: Int): Bool { a % 2 == 0 };

    assert Itertools.all(a, isEven) == false;
    assert Itertools.all(b, isEven) == true;
```

## Function `any`
``` motoko no-repl
func any<A>(iter : Iter.Iter<A>, predicate : (A) -> Bool) : Bool
```

Checks if at least one element in the iterator satisfies the predicate.

### Example
- An example checking if any element in a iterator of integers is even:

```motoko

    let a = [1, 2, 3, 4].vals();
    let b = [1, 3, 5, 7].vals();

    let isEven = func(a: Nat) : Bool { a % 2 == 0 };

    assert Itertools.any(a, isEven) == true;
    assert Itertools.any(b, isEven) == false;
```

## Function `add`
``` motoko no-repl
func add<A>(iter : Iter.Iter<A>, elem : A) : Iter.Iter<A>
```

Adds an element to the end of an iterator.

### Example

```motoko

    let iter = [1, 2, 3, 4].vals();
    let new_iter = Itertools.add(iter, 5);

    assert Iter.toArray(new_iter) == [1, 2, 3, 4, 5]


## Function `cartesianProduct`
``` motoko no-repl
func cartesianProduct<A, B>(iterA : Iter.Iter<A>, iterB : Iter.Iter<B>) : Iter.Iter<(A, B)>
```

Returns the cartesian product of the given iterables as an iterator of tuples.

The resulting iterator contains all the combinations between elements in the two given iterators.

### Example

```motoko

    let a = [1, 2, 3].vals();
    let b = "abc".chars();

    let it = Itertools.cartesianProduct(a, b);

    assert Iter.toArray(it) == [
        (1, 'a'), (1, 'b'), (1, 'c'),
        (2, 'a'), (2, 'b'), (2, 'c'),
        (3, 'a'), (3, 'b'), (3, 'c')
    ];

```

## Function `count`
``` motoko no-repl
func count<A>(iter : Iter.Iter<A>, element : A, isEq : (A, A) -> Bool) : Nat
```

Counts the frequency of an element in the iterator.

### Example

```motoko

    let a = [1, 2, 3, 1, 2, 3].vals();

    let freq = Itertools.count(a, 1, Nat.equal);

    assert freq == 2;
```

## Function `countAll`
``` motoko no-repl
func countAll<A>(iter : Iter.Iter<A>, hashFn : (A) -> Hash.Hash, isEq : (A, A) -> Bool) : TrieMap.TrieMap<A, Nat>
```

Returns a TrieMap where the elements in the iterator are stored
as keys and the frequency of the elements are values

### Example

```motoko

    let a = "motoko".chars();

    let freqMap = Itertools.countAll(a, Char.hash, Char.equal);
    let res = Iter.toArray(freqMap.entries());

    assert res == [('k', 1), ('m', 1), ('o', 3), ('t', 1)];
```

## Function `chain`
``` motoko no-repl
func chain<A>(a : Iter.Iter<A>, b : Iter.Iter<A>) : Iter.Iter<A>
```

Chains two iterators of the same type together, so that all the
elements in the first iterator come before the second one.

### Example
```motoko

   let iter1 = [1, 2].vals();
   let iter2 = [3, 4].vals();
   let chained = Itertools.chain(iter1, iter2);

    assert chained.next() == ?1
    assert chained.next() == ?2
    assert chained.next() == ?3
    assert chained.next() == ?4
    assert chained.next() == null
```

## Function `chunks`
``` motoko no-repl
func chunks<A>(iter : Iter.Iter<A>, size : Nat) : Iter.Iter<[A]>
```

Returns an iterator that accumulates elements into arrays with a size less that or equal to the given `size`.

### Example
- An example grouping a iterator of integers into arrays of size `3`:

```motoko

    let vals = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].vals();
    let it = Itertools.chunks(vals, 3);

    assert it.next() == ?[1, 2, 3];
    assert it.next() == ?[4, 5, 6];
    assert it.next() == ?[7, 8, 9];
    assert it.next() == ?[10];
    assert it.next() == null;
```

## Function `chunksExact`
``` motoko no-repl
func chunksExact<A>(iter : Iter.Iter<A>, size : Nat) : Iter.Iter<[A]>
```

Returns an iterator that accumulates elements into arrays with sizes exactly equal to the given one.
If the iterator is shorter than `n` elements, `null` is returned.

### Example
- An example grouping a iterator of integers into arrays of size `3`:

```motoko

    let vals = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].vals();
    let it = Itertools.chunksExact(vals, 3);

    assert it.next() == ?[1, 2, 3];
    assert it.next() == ?[4, 5, 6];
    assert it.next() == ?[7, 8, 9];
    assert it.next() == null;
```

## Function `combinations`
``` motoko no-repl
func combinations(iter : Iter.Iter<Nat>, size : Nat) : Iter.Iter<[Nat]>
```

Returns all the combinations of a given iterator.

### Example
- An example grouping a iterator of integers into arrays of size `3`:

```motoko

    let vals = [1, 2, 3, 4].vals();
    let it = Itertools.combinations(vals, 3);

    assert it.next() == ?[1, 2, 3];
    assert it.next() == ?[1, 2, 4];
    assert it.next() == ?[1, 3, 4];
    assert it.next() == ?[2, 3, 4];
    assert it.next() == null;
```

- An example grouping a iterator of integers into arrays of size `2`:

```motoko

    let vals = [1, 2, 3, 4].vals();
    let it = Itertools.combinations(vals, 2);

    assert it.next() == ?[1, 2];
    assert it.next() == ?[1, 3];
    assert it.next() == ?[1, 4];
    assert it.next() == ?[2, 3];
    assert it.next() == ?[2, 4];
    assert it.next() == ?[3, 4];
    assert it.next() == null;
```

## Function `cycle`
``` motoko no-repl
func cycle<A>(iter : Iter.Iter<A>, n : Nat) : Iter.Iter<A>
```

Creates an iterator that loops over the values of a
given iterator `n` times.

### Example

```motoko

    let chars = "abc".chars();
    let it = Itertools.cycle(chars, 3);

    assert it.next() == ?'a';
    assert it.next() == ?'b';
    assert it.next() == ?'c';

    assert it.next() == ?'a';
    assert it.next() == ?'b';
    assert it.next() == ?'c';

    assert it.next() == ?'a';
    assert it.next() == ?'b';
    assert it.next() == ?'c';

    assert it.next() == null;
```

## Function `enumerate`
``` motoko no-repl
func enumerate<A>(iter : Iter.Iter<A>) : Iter.Iter<(Nat, A)>
```

Returns an iterator that returns tuples with the index of the element
and the element.

The index starts at 0 and is the first item in the tuple.

```motoko

    let chars = "abc".chars();
    let iter = Itertools.enumerate(chars);

    for ((i, c) in iter){
        Debug.print((i, c));
    };

    // (0, 'a')
    // (1, 'b')
    // (2, 'c')
```

## Function `empty`
``` motoko no-repl
func empty<A>() : Iter.Iter<A>
```

Creates an empty iterator.

### Example

```motoko

    let it = Itertools.empty();
    assert it.next() == null;

```

## Function `equal`
``` motoko no-repl
func equal<A>(iter1 : Iter.Iter<A>, iter2 : Iter.Iter<A>, isEq : (A, A) -> Bool) : Bool
```

Checks if two iterators are equal.

### Example

```motoko

    let it1 = Itertools.range(1, 10);
    let it2 = Itertools.range(1, 10);

    assert Itertools.equal(it1, it2, Nat.equal);

    let it3 = Itertools.range(1, 5);
    let it4 = Itertools.range(1, 10);

    assert not Itertools.equal(it3, it4, Nat.equal);
```

## Function `find`
``` motoko no-repl
func find<A>(iter : Iter.Iter<A>, predicate : (A) -> Bool) : ?A
```

Looks for an element in an iterator that matches a predicate.

### Example
- An example finding the first even number in an iterator:

```motoko

    let vals = [1, 2, 3, 4, 5].vals();

    let isEven = func( x : Int ) : Bool {x % 2 == 0};
    let res = Itertools.find(vals, isEven);

    assert res == ?2
```

## Function `findIndex`
``` motoko no-repl
func findIndex<A>(iter : Iter.Iter<A>, predicate : (A) -> Bool) : ?Nat
```

Return the index of an element in an iterator that matches a predicate.

### Example

```motoko

    let vals = [1, 2, 3, 4, 5].vals();

    let isEven = func( x : Int ) : Bool {x % 2 == 0};
    let res = Itertools.findIndex(vals, isEven);

    assert res == ?1;
```

## Function `findIndices`
``` motoko no-repl
func findIndices<A>(iter : Iter.Iter<A>, predicate : (A) -> Bool) : Iter.Iter<Nat>
```

Returns an iterator with the indices of all the elements that match the predicate.

### Example

```motoko

    let vals = [1, 2, 3, 4, 5, 6].vals();

    let isEven = func( x : Int ) : Bool {x % 2 == 0};
    let res = Itertools.findIndices(vals, isEven);

    assert Iter.toArray(res) == [1, 3, 5];

```

## Function `fold`
``` motoko no-repl
func fold<A, B>(iter : Iter.Iter<A>, initial : B, f : (B, A) -> B) : B
```

Returns the accumulated result of applying of the given
function to each element and the previous result starting with
the initial value.

This method is similar to [reduce](#reduce) but it takes an initial
value and does not return an optional value.

### Example

```motoko
    import Nat8 "mo:base/Nat8";

    let arr : [Nat8] = [1, 2, 3, 4, 5];
    let sumToNat = func(acc: Nat, n: Nat8): Nat {
        acc + Nat8.toNat(n)
    };

    let sum = Itertools.fold<Nat8, Nat>(
        arr.vals(),
        200,
        sumToNat
    );

    assertTrue(sum == 215)
```

You can easily fold from the right to left using a
[`RevIter`](RevIter.html) to reverse the iterator before folding.

## Function `flatten`
``` motoko no-repl
func flatten<A>(nestedIter : Iter.Iter<Iter.Iter<A>>) : Iter.Iter<A>
```

Flattens nested iterators into a single iterator.

### Example

```motoko

    let nestedIter = [
        [1].vals(),
        [2, 3].vals(),
        [4, 5, 6].vals()
    ].vals();

    let flattened = Itertools.flatten(nestedIter);
    assert Iter.toArray(flattened) == [1, 2, 3, 4, 5, 6];
```

## Function `flattenArray`
``` motoko no-repl
func flattenArray<A>(nestedArray : [[A]]) : Iter.Iter<A>
```

Returns an flattened iterator with all the values in a nested array

### Example

```motoko

    let arr = [[1], [2, 3], [4, 5, 6]];
    let flattened = Itertools.flatten(arr);

    assert Iter.toArray(flattened) == [1, 2, 3, 4, 5, 6];
```

## Function `groupBy`
``` motoko no-repl
func groupBy<A, B>(iter : Iter.Iter<A>, pred : (A) -> Bool) : Iter.Iter<([A], Bool)>
```

Groups nearby elements into arrays based on result from the given function and returns them along with the result of elements in that group.

### Example

```motoko

    let vals = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].vals();

    let isFactorOf30 = func( x : Int ) : Bool {x % 30 == 0};
    let groups = Itertools.groupBy(vals, isFactorOf30);

    assert Iter.toArray(groups) == [
        ([1, 2, 3], true),
        ([4], false),
        ([5, 6], true),
        ([7, 8, 9], false),
        ([10], true)
    ];

```

## Function `inspect`
``` motoko no-repl
func inspect<A>(iter : Iter.Iter<A>, callback : (A) -> ()) : Iter.Iter<A>
```

Pass in a callback function to the iterator that performs a task every time the iterator is advanced.

### Example

```motoko
    import Debug "mo:base/Debug";

    let vals = [1, 2, 3, 4, 5].vals();

    let printIfEven = func(n: Int) {
        if (n % 2 == 0){
            Debug.print("This value [ " # debug_show n # " ] is even.");
        }
    };

    let iter = Itertools.inspect(vals, printIfEven);

    assert Iter.toArray(iter) == [1, 2, 3, 4, 5];
```

- console:
```bash
    This value [ +2 ] is even.
    This value [ +4 ] is even.
```

## Function `interleave`
``` motoko no-repl
func interleave<A>(_iter1 : Iter.Iter<A>, _iter2 : Iter.Iter<A>) : Iter.Iter<A>
```

Alternates between two iterators of the same type until one is exhausted.

### Example

```motoko

    let vals = [1, 2, 3, 4].vals();
    let vals2 = [10, 20].vals();

    let iter = Itertools.interleave(vals, vals2);

    assert iter.next() == ?1
    assert iter.next() == ?10
    assert iter.next() == ?2
    assert iter.next() == ?20
    assert iter.next() == null
```

## Function `interleaveLongest`
``` motoko no-repl
func interleaveLongest<A>(_iter1 : Iter.Iter<A>, _iter2 : Iter.Iter<A>) : Iter.Iter<A>
```

Alternates between two iterators of the same type until both are exhausted.

### Example

```motoko

    let vals = [1, 2, 3, 4].vals();
    let vals2 = [10, 20].vals();

    let iter = Itertools.interleave(vals, vals2);

    assert iter.next() == ?1
    assert iter.next() == ?10
    assert iter.next() == ?2
    assert iter.next() == ?20
    assert iter.next() == ?3
    assert iter.next() == ?4
    assert iter.next() == null
```

## Function `intersperse`
``` motoko no-repl
func intersperse<A>(_iter : Iter.Iter<A>, val : A) : Iter.Iter<A>
```

Returns an iterator that inserts a value between each pair
of values in an iterator.

### Example

```motoko

    let vals = [1, 2, 3].vals();
    let iter = Itertools.intersperse(vals, 10);

    assert Iter.toArray(iter) == [1, 10, 2, 10, 3];

```

## Function `isSorted`
``` motoko no-repl
func isSorted<A>(iter : Iter.Iter<A>, cmp : (A, A) -> Order.Order) : Bool
```

Checks if all the elements in an iterator are sorted in ascending order
that for every element `a` ans its proceding element `b`, `a <= b`.

Returns true if iterator is empty

#Example

```motoko
import Nat "mo:base/Nat";

    let a = [1, 2, 3, 4];
    let b = [1, 4, 2, 3];
    let c = [4, 3, 2, 1];

assert Itertools.isSorted(a.vals(), Nat.compare) == true;
assert Itertools.isSorted(b.vals(), Nat.compare) == false;
assert Itertools.isSorted(c.vals(), Nat.compare) == false;

```

## Function `isSortedDesc`
``` motoko no-repl
func isSortedDesc<A>(iter : Iter.Iter<A>, cmp : (A, A) -> Order.Order) : Bool
```

Checks if all the elements in an iterator are sorted in descending order

Returns true if iterator is empty

#Example

```motoko
import Nat "mo:base/Nat";

    let a = [1, 2, 3, 4];
    let b = [1, 4, 2, 3];
    let c = [4, 3, 2, 1];

assert Itertools.isSortedDesc(a.vals(), Nat.compare) == false;
assert Itertools.isSortedDesc(b.vals(), Nat.compare) == false;
assert Itertools.isSortedDesc(c.vals(), Nat.compare) == true;

```

## Function `mapEntries`
``` motoko no-repl
func mapEntries<A, B>(iter : Iter.Iter<A>, f : (Nat, A) -> B) : Iter.Iter<B>
```

Returns an iterator adaptor that mutates elements of an iterator by applying the given function to each entry.
Each entry consists of the index of the element and the element itself.

### Example

```motoko

    let vals = [2, 2, 2, 2, 2].vals();
    let mulWithIndex = func(i: Nat, val: Nat) {
        i * val;
    };

    let iter = Itertools.mapEntries(vals, mulWithIndex);

    assert Iter.toArray(iter) == [0, 2, 4, 6, 8];

```

## Function `mapFilter`
``` motoko no-repl
func mapFilter<A, B>(iter : Iter.Iter<A>, optMapFn : (A) -> ?B) : Iter.Iter<B>
```

Returns an iterator that filters elements based on a predicate and
maps them to a new value based on the second argument.

### Example
- An example filtering odd numbers and squaring them:

```motoko

    let vals = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].vals();

    let filterOddSquareEven = func( x : Nat ) : Nat {
        if (x % 2 == 1){
            null
        }else{
            ?(x * x)
        }
     };

    let it = Itertools.mapFilter(vals, filterOddSquareEven);

    assert it.next() == ?4
    assert it.next() == ?16
    assert it.next() == ?36
    assert it.next() == ?64
    assert it.next() == ?100
    assert it.next() == null
```

## Function `mapReduce`
``` motoko no-repl
func mapReduce<A, B>(iter : Iter.Iter<A>, f : (A) -> B, accFn : (B, B) -> B) : ?B
```

Maps the elements of an iterator and accumulates them into a single value.

### Example

- decode numeric representation of characters into a string
```motoko

    let vals = [13, 15, 20, 15, 11, 15].vals();

    let natToChar = func (x : Nat) : Text {
        Char.toText(
            Char.fromNat32(
                Nat32.fromNat(x) + 96
            )
        )
    };

    let concat = func (a : Text, b : Text) : Text {
        a # b
    };

    let res = Itertools.mapReduce(vals, natToChar, concat);

    assert res == ?"motoko";

```

## Function `mapWhile`
``` motoko no-repl
func mapWhile<A, B>(iter : Iter.Iter<A>, pred : (A) -> ?B) : Iter.Iter<B>
```

Returns an iterator that maps and yields elements while the
predicate is true.
The predicate is true if it returns an optional value and
false if it
returns null.

### Example

```motoko

    let vals = [1, 2, 3, 4, 5].vals();

    let squareIntLessThan4 = func( x : Int ) : ?Int {
        if (x < 4){
            return ?(x * x);
        }else{
            return null;
        };
    };

    let it = Itertools.mapWhile(vals, squareIntLessThan4);

    assert it.next() == ?1;
    assert it.next() == ?4;
    assert it.next() == ?9;
    assert it.next() == null;
    assert it.next() == null;

```

## Function `max`
``` motoko no-repl
func max<A>(iter : Iter.Iter<A>, cmp : (A, A) -> Order.Order) : ?A
```

Returns the maximum value in an iterator.
A null value is returned if the iterator is empty.

### Example

```motoko

    let vals = [1, 2, 3, 4, 5].vals();
    let max = Itertools.max(vals, Nat.compare);

    assert max == ?5;
```

- max on an empty iterator

```motoko

    let vals = [].vals();
    let max = Itertools.max(vals, Nat.compare);

    assert max == null;
```

## Function `min`
``` motoko no-repl
func min<A>(iter : Iter.Iter<A>, cmp : (A, A) -> Order.Order) : ?A
```

Returns the minimum value in an iterator.
A null value is returned if the iterator is empty.

### Example

```motoko

    let vals = [8, 4, 6, 9].vals();
    let min = Itertools.min(vals, Nat.compare);

    assert min == ?4;
```

- min on an empty iterator

```motoko

    let vals: [Nat] = [].vals();
    let min = Itertools.min(vals, Nat.compare);

    assert min == null;
```

## Function `minmax`
``` motoko no-repl
func minmax<A>(iter : Iter.Iter<A>, cmp : (A, A) -> Order.Order) : ?(A, A)
```

Returns a tuple of the minimum and maximum value in an iterator.
The first element is the minimum, the second the maximum.

A null value is returned if the iterator is empty.

If the iterator contains only one element, then it is returned as both
the minimum and the maximum.

### Example

```motoko

    let vals = [8, 4, 6, 9].vals();
    let minmax = Itertools.minmax(vals);

    assert minmax == ?(4, 9);
```

- minmax on an empty iterator

```motoko

    let vals = [].vals();
    let minmax = Itertools.minmax(vals);

    assert minmax == null;
```
- minmax on an iterator with one element

```motoko

    let vals = [8].vals();
    let minmax = Itertools.minmax(vals);

    assert minmax == ?(8, 8);
```

## Function `merge`
``` motoko no-repl
func merge<A>(iter1 : Iter.Iter<A>, iter2 : Iter.Iter<A>, cmp : (A, A) -> Order.Order) : Iter.Iter<A>
```

Returns an iterator that merges two iterators in order.

The two iterators must have be of the same type

### Example

- merge two sorted lists

```motoko

    let vals1 = [5, 6, 7].vals();
    let vals2 = [1, 3, 4].vals();
    let merged = Itertools.merge(vals1, vals2, Nat.compare);

    assert Iter.toArray(merged) == [1, 3, 4, 5, 6, 7];
```

- merge two unsorted lists

```motoko

    let vals1 = [5, 2, 3].vals();
    let vals2 = [8, 4, 1].vals();
    let merged = Itertools.merge(vals1, vals2, Nat.compare);

    assert Iter.toArray(merged) == [5, 2, 3, 8, 4, 1];
```

## Function `kmerge`
``` motoko no-repl
func kmerge<A>(iters : [Iter.Iter<A>], cmp : (A, A) -> Order.Order) : Iter.Iter<A>
```

Returns an iterator that merges `k` iterators in order based on the `cmp` function.

> Note: The iterators must have be of the same type

### Example

```motoko

    let vals1 = [5, 6, 7].vals();
    let vals2 = [1, 3, 4].vals();
    let vals3 = [8, 4, 1].vals();
    let merged = Itertools.kmerge([vals1, vals2, vals3], Nat.compare);

    assert Iter.toArray(merged) == [1, 3, 4, 5, 6, 7, 8, 4, 1];
```

## Function `runLength`
``` motoko no-repl
func runLength<A>(iter : Iter.Iter<A>, isEqual : (A, A) -> Bool) : Iter.Iter<(A, Nat)>
```

Returns the run-length encoding of an Iterator

### Example

```motoko

    let chars = "aaaabbbccd".chars();

    let iter = Itertools.runLength(text.chars(), Char.equal);
    let res = Iter.toArray(iter);

    assert res == [('a', 4), ('b', 3), ('c', 2), ('d', 1)]

```

## Function `notEqual`
``` motoko no-repl
func notEqual<A>(iter1 : Iter.Iter<A>, iter2 : Iter.Iter<A>, isEq : (A, A) -> Bool) : Bool
```

Checks if two iterators are not equal.

### Example

```motoko

    let vals1 = [5, 6, 7].vals();
    let vals2 = [1, 3, 4].vals();

    assert Itertools.notEqual(vals1, vals2, Nat.equal);

    let vals3 = [1, 3, 4].vals();
    let vals4 = [1, 3, 4].vals();

    assert not Itertools.notEqual(vals3, vals4, Nat.equal));
```

## Function `nth`
``` motoko no-repl
func nth<A>(iter : Iter.Iter<A>, n : Nat) : ?A
```

Returns the nth element of an iterator.
Consumes the first n elements of the iterator.

### Example

```motoko

    let vals = [0, 1, 2, 3, 4, 5].vals();
    let nth = Itertools.nth(vals, 3);

    assert nth == ?3;
```


## Function `nthOrDefault`
``` motoko no-repl
func nthOrDefault<A>(iter : Iter.Iter<A>, n : Nat, defaultValue : A) : A
```

Returns the nth elements of an iterator or a given default value.

### Example

```motoko

    let vals = [0, 1, 2, 3, 4, 5].vals();

    assert Itertools.nthOrDefault(vals, 3, -1) == ?3;
    assert Itertools.nthOrDefault(vals, 3, -1) == ?-1;
```

## Function `pad`
``` motoko no-repl
func pad<A>(iter : Iter.Iter<A>, length : Nat, value : A) : Iter.Iter<A>
```

Pads an iterator with a given value until it is of a certain length.

### Example

```motoko

    let vals = [1, 2, 3].vals();
    let padded = Itertools.pad(vals, 6, 0);

    assert Iter.toArray(padded) == [1, 2, 3, 0, 0, 0];
```

## Function `padWithFn`
``` motoko no-repl
func padWithFn<A>(iter : Iter.Iter<A>, length : Nat, f : (Nat) -> A) : Iter.Iter<A>
```

Pads an iterator with the result of a given function until it is of a certain length.

### Example

```motoko


    let vals = [1, 2, 3].vals();
    let incrementIndex = func (i: Nat) { i + 1 };

    let padded = Itertools.padWithFn(vals, 6, incrementIndex);
```

## Function `partition`
``` motoko no-repl
func partition<A>(iter : Iter.Iter<A>, f : (A) -> Bool) : ([A], [A])
```

Takes a partition function that returns `true` or `false`
for each element in the iterator.
The iterator is partitioned into a tuple of two arrays.
The first array contains the elements all elements that
returned `true` and the second array contains the elements
that returned `false`.

If the iterator is empty, it returns a tuple of two empty arrays.
### Example

```motoko

    let vals = [0, 1, 2, 3, 4, 5].vals();
    let isEven = func (n: Nat) : Bool { n % 2 == 0 };

    let (even, odd) = Itertools.partition(vals, isEven);

    assert even == [0, 2, 4];
    assert odd == [1, 3, 5];

```

## Function `partitionInPlace`
``` motoko no-repl
func partitionInPlace<A>(iter : Iter.Iter<A>, f : (A) -> Bool) : Iter.Iter<A>
```

Partitions an iterator in place so that the values that
return `true` from the `predicate` are on the left and the
values that return `false` are on the right.

### Example

```motoko

    let vals = [0, 1, 2, 3, 4, 5].vals();
    let isEven = func (n: Nat) : Bool { n % 2 == 0 };

    let iter = Itertools.partitionInPlace(vals, isEven);

    assert Iter.toArray(iter) == [0, 2, 4, 1, 3, 5];

```

## Function `isPartitioned`
``` motoko no-repl
func isPartitioned<A>(iter : Iter.Iter<A>, f : (A) -> Bool) : Bool
```

Checks if an iterator is partitioned by a predicate into
two consecutive groups.
The first n elements of the iterator return `true` when
passed to the predicate, and the rest return `false`.

### Example

```motoko

    let vals = [0, 2, 4, 1, 3, 5].vals();
    let isEven = func (n: Nat) : Bool { n % 2 == 0 };

    let res = Itertools.isPartitioned(vals, isEven);

    assert res == true;
```

## Function `peekable`
``` motoko no-repl
func peekable<T>(iter : Iter.Iter<T>) : PeekableIter.PeekableIter<T>
```

Returns a peekable iterator.
The iterator has a `peek` method that returns the next value
without consuming the iterator.

### Example
```motoko

    let vals = Iter.fromArray([1, 2]);
    let peekIter = Itertools.peekable(vals);

    assert peekIter.peek() == ?1;
    assert peekIter.next() == ?1;

    assert peekIter.peek() == ?2;
    assert peekIter.peek() == ?2;
    assert peekIter.next() == ?2;

    assert peekIter.peek() == null;
    assert peekIter.next() == null;
```

## Function `permutations`
``` motoko no-repl
func permutations<A>(iter : Iter.Iter<A>, cmp : (A, A) -> Order.Order) : Iter.Iter<[A]>
```

Returns an iterator that yeilds all the permutations of the
elements of the iterator.

### Example

```motoko

    let vals = [1, 2, 3].vals();
    let perms = Itertools.permutations(vals, Nat.compare);

    assert Iter.toArray(perms) == [
        [1, 2, 3], [1, 3, 2],
        [2, 1, 3], [2, 3, 1],
        [3, 1, 2], [3, 2, 1]
    ];
```

## Function `prepend`
``` motoko no-repl
func prepend<A>(value : A, iter : Iter.Iter<A>) : Iter.Iter<A>
```

Add a value to the front of an iterator.

### Example

```motoko

    let vals = [2, 3].vals();
    let iter = Itertools.prepend(1, vals);

    assert Iter.toArray(iter) == [1, 2, 3];
```

## Function `product`
``` motoko no-repl
func product<A>(iter : Iter.Iter<A>, mul : (A, A) -> A) : ?A
```

Consumes an iterator of integers and returns the product of all values.
An empty iterator returns null.

### Example
```motoko

    let vals = [1, 2, 3, 4].vals();
    let prod = Itertools.product(vals, Nat.mul);

    assert prod == ?24;
```

## Function `range`
``` motoko no-repl
func range(start : Nat, end : Nat) : Iter.Iter<Nat>
```

Returns a `Nat` iterator that yields numbers in range [start, end).
The base library provides a `range` function that returns an iterator from with start and end both inclusive.

### Example

```motoko

    let iter = Itertools.range(1, 5);

    assert iter.next() == ?1;
    assert iter.next() == ?2;
    assert iter.next() == ?3;
    assert iter.next() == ?4;
    assert iter.next() == null;
```

## Function `intRange`
``` motoko no-repl
func intRange(start : Int, end : Int) : Iter.Iter<Int>
```

Returns a `Int` iterator that yields numbers in range [start, end).

### Example

```motoko

    let iter = Itertools.intRange(1, 4);

    assert iter.next() == ?1;
    assert iter.next() == ?2;
    assert iter.next() == ?3;
    assert iter.next() == null;
```

## Function `reduce`
``` motoko no-repl
func reduce<A>(iter : Iter.Iter<A>, f : (A, A) -> A) : ?A
```

Returns an optional value representing the application of the given
function to each element and the accumulated result.

### Example

```motoko

    let vals = [1, 2, 3, 4, 5].vals();
    let add = func (a: Int, b: Int) : Int { a + b };

    let sum = Itertools.reduce(vals, add);

    assert sum == ?15;
```

## Function `repeat`
``` motoko no-repl
func repeat<A>(item : A, n : Nat) : Iter.Iter<A>
```

Returns an iterator that repeats a given value `n` times.
To repeat a value infinitely, use `Iter.make` from the base library.

### Example
```motoko

    let iter = Itertools.repeat(1, 3);

    assert iter.next() == ?1;
    assert iter.next() == ?1;
    assert iter.next() == ?1;
    assert iter.next() == null;
```

## Function `skip`
``` motoko no-repl
func skip<A>(iter : Iter.Iter<A>, n : Nat) : Iter.Iter<A>
```

Skips the first n elements of the iter

### Example
```motoko

    let iter = [1, 2, 3, 4, 5].vals();
    Itertools.skip(iter, 2);

    assert iter.next() == ?3;
    assert iter.next() == ?4;
    assert iter.next() == ?5;
    assert iter.next() == null;
```

## Function `skipWhile`
``` motoko no-repl
func skipWhile<A>(iter : Iter.Iter<A>, pred : (A) -> Bool) : Iter.Iter<A>
```

Skips elements continuously while the predicate is true.

Note: Use the returned iterator instead of the original one. 
The original iterator will have advanced one element further than the skipped elements.
### Example
```motoko

    let iter = [1, 2, 3, 4, 5].vals();
    let lessThan3 = func (a: Int) : Bool { a < 3 };

    let skipped = Itertools.skipWhile(iter, lessThan3);

    assert Iter.toArray(skipped) == [3, 4, 5];

```

## Function `slidingTuples`
``` motoko no-repl
func slidingTuples<A>(iter : Iter.Iter<A>) : Iter.Iter<(A, A)>
```

Returns overlapping tuple pairs from the given iterator.
The first element of the iterator is paired with the second element, and the
second is paired with the third element, and so on.
?(a, b), ?(b, c), ?(c, d), ...

If the iterator has fewer than two elements, an null value is returned.

### Example

```motoko

    let vals = [1, 2, 3, 4, 5].vals();
    let pairs = Itertools.slidingTuples(vals);

    assert pairs.next() == ?(1, 2);
    assert pairs.next() == ?(2, 3);
    assert pairs.next() == ?(3, 4);
    assert pairs.next() == ?(4, 5);
    assert pairs.next() == null;
```

## Function `slidingTriples`
``` motoko no-repl
func slidingTriples<A>(iter : Iter.Iter<A>) : Iter.Iter<(A, A, A)>
```

Returns consecutive, overlapping triplets from the given iterator.
The iterator returns a tuple of three elements, which include the current element and the two proceeding ones.
?(a, b, c), ?(b, c, d), ?(c, d, e), ...

If the iterator has fewer than three elements, an null value is returned.

### Example

```motoko

    let vals = [1, 2, 3, 4, 5].vals();
    let triples = Itertools.slidingTriples(vals);

    assert triples.next() == ?(1, 2, 3);
    assert triples.next() == ?(2, 3, 4);
    assert triples.next() == ?(3, 4, 5);
    assert triples.next() == null;
```

## Function `sort`
``` motoko no-repl
func sort<A>(iter : Iter.Iter<A>, cmp : (A, A) -> Order.Order) : Iter.Iter<A>
```

Returns an iterator where all the elements are sorted in ascending order.

### Example
```motoko

    let vals = [8, 3, 5, 4, 1].vals();
    let sorted = Itertools.sort(vals);

    assert Iter.toArray(sorted) == [1, 3, 4, 5, 8];
```

## Function `splitAt`
``` motoko no-repl
func splitAt<A>(iter : Iter.Iter<A>, n : Nat) : (Iter.Iter<A>, Iter.Iter<A>)
```

Returns a tuple of iterators where the first element is the first n elements of the iterator, and the second element is the remaining elements.

### Example
```motoko

    let iter = [1, 2, 3, 4, 5].vals();
    let (left, right) = Itertools.splitAt(iter, 3);

    assert left.next() == ?1;
    assert right.next() == ?4;

    assert left.next() == ?2;
    assert right.next() == ?5;

    assert left.next() == ?3;

    assert left.next() == null;
    assert right.next() == null;
```

## Function `spy`
``` motoko no-repl
func spy<A>(iter : Iter.Iter<A>, n : Nat) : (Iter.Iter<A>, Iter.Iter<A>)
```

Returns a tuple of iterators where the first element is an iterator with a copy of
the first n elements of the iterator, and the second element is the original iterator
with all the elements

### Example
```motoko

    let vals = [1, 2, 3, 4, 5].vals();
    let (copy, iter) = Itertools.spy(vals, 3);

    assert copy.next() == ?1;
    assert copy.next() == ?2;
    assert copy.next() == ?3;
    assert copy.next() == null;

    assert vals.next() == ?1;
    assert vals.next() == ?2;
    assert vals.next() == ?3;
    assert vals.next() == ?4;
    assert vals.next() == ?5;
    assert vals.next() == null;
```

## Function `stepBy`
``` motoko no-repl
func stepBy<A>(iter : Iter.Iter<A>, n : Nat) : Iter.Iter<A>
```

Returns every nth element of the iterator.
n must be greater than zero.

### Example
```motoko

    let vals = [1, 2, 3, 4, 5].vals();
    let iter = Itertools.stepBy(vals, 2);

    assert iter.next() == ?1;
    assert iter.next() == ?3;
    assert iter.next() == ?5;
    assert iter.next() == null;
```

## Function `successor`
``` motoko no-repl
func successor<A>(start : A, f : (A) -> ?A) : Iter.Iter<A>
```

Creates an iterator from the given value a where the next
elements are the results of the given function applied to
the previous element.

The function takes the previous value and returns an Optional
value.  If the function returns null when the function
returns null.

### Example
```motoko
    import Nat "mo:base/Nat";

    let optionSquaresOfSquares = func(n: Nat) : ?Nat{
        let square = n * n;

        if (square <= Nat.pow(2, 64)) {
            return ?square;
        };

        return null;
    };

    let succIter = Itertools.successor(
         2,
         optionSquaresOfSquares
    );

    let res = Iter.toArray(succIter);

    assert res == [
        2, 4, 16, 256, 65_536, 4_294_967_296,
    ];

```

## Function `sum`
``` motoko no-repl
func sum<A>(iter : Iter.Iter<A>, add : (A, A) -> A) : ?A
```

Consumes an iterator of integers and returns the sum of all values.
An empty iterator returns `null`.

### Example
```motoko

    let vals = [1, 2, 3, 4].vals();
    let sum = Itertools.sum(vals, Nat.add);

    assert sum == ?10;
```

## Function `take`
``` motoko no-repl
func take<A>(iter : Iter.Iter<A>, n : Nat) : Iter.Iter<A>
```

Returns an iterator with the first n elements of the given iter
> Be aware that this returns a reference to the original iterator so
> using it will cause the original iterator to be skipped.

If you want to keep the original iterator, use `spy` instead.

Note that using the returned iterator and the given iterator at the same time will cause the values in both iterators to be skipped.

### Example
```motoko

    let iter = Iter.fromArray([1, 2, 3, 4, 5]);
    let it = Itertools.take(iter, 3);

    assert it.next() == ?1;
    assert it.next() == ?2;
    assert it.next() == ?3;
    assert it.next() == null;

    // the first n elements of the original iterator are skipped
    assert iter.next() == ?4;
    assert iter.next() == ?5;
    assert iter.next() == null;
```

## Function `takeWhile`
``` motoko no-repl
func takeWhile<A>(iter : Iter.Iter<A>, predicate : A -> Bool) : Iter.Iter<A>
```

Creates an iterator that returns returns elements from the given iter while the predicate is true.

### Example
```motoko

    let vals = Iter.fromArray([1, 2, 3, 4, 5]);

    let lessThan3 = func (x: Int) : Bool { x < 3 };
    let it = Itertools.takeWhile(vals, lessThan3);

    assert it.next() == ?1;
    assert it.next() == ?2;
    assert it.next() == null;
```

> Warning: That a side-effect occurs where the given iterator is advanced passes the first element that returns false.
> If you want the iterator to start from the first element that returns false, use the `takeWhile` function in the `PeekableIter` module.

## Function `tee`
``` motoko no-repl
func tee<A>(iter : Iter.Iter<A>) : (Iter.Iter<A>, Iter.Iter<A>)
```

Consumes an iterator and returns a tuple of cloned iterators.

### Example
```motoko

    let iter = [1, 2, 3].vals();
    let (iter1, iter2) = Itertools.tee(iter);

    assert iter1.next() == ?1;
    assert iter1.next() == ?2;
    assert iter1.next() == ?3;
    assert iter1.next() == null;

    assert iter2.next() == ?1;
    assert iter2.next() == ?2;
    assert iter2.next() == ?3;
    assert iter2.next() == null;
```

## Function `tuples`
``` motoko no-repl
func tuples<A>(iter : Iter.Iter<A>) : Iter.Iter<(A, A)>
```

Returns an iterator of consecutive, non-overlapping tuple pairs of elements from a single iter.
The first element is paired with the second element, the third element with the fourth, and so on.
?(a, b), ?(c, d), ?(e, f) ...

If the iterator has less than two elements, it will return a null.
> For overlappping pairs use slidingTuples.

### Example
```motoko

    let vals = [1, 2, 3, 4, 5].vals();
    let it = Itertools.tuples(vals);

    assert it.next() == ?(1, 2);
    assert it.next() == ?(3, 4);
    assert it.next() == null;

```

## Function `triples`
``` motoko no-repl
func triples<A>(iter : Iter.Iter<A>) : Iter.Iter<(A, A, A)>
```

Returns an iterator of consecutive, non-overlapping triplets of elements from a single iter.
?(a, b, c), ?(d, e, f) ...

If the iterator has less than three elements, it will return a null.

### Example
```motoko

    let vals = [1, 2, 3, 4, 5, 6, 7].vals();
    let it = Itertools.triples(vals);

    assert it.next() == ?(1, 2, 3);
    assert it.next() == ?(4, 5, 6);
    assert it.next() == null;

```

## Function `unique`
``` motoko no-repl
func unique<A>(iter : Iter.Iter<A>, hashFn : (A) -> Hash.Hash, isEq : (A, A) -> Bool) : Iter.Iter<A>
```

Returns an iterator with unique elements from the given iter.

### Example
```motoko
    import Nat "mo:base/Nat";
    import Hash "mo:base/Hash";

    let vals = [1, 2, 3, 1, 2, 3].vals();
    let it = Itertools.unique(vals, Hash.hash, Nat.equal);

    assert it.next() == ?1;
    assert it.next() == ?2;
    assert it.next() == ?3;
    assert it.next() == null;

```

## Function `uniqueCheck`
``` motoko no-repl
func uniqueCheck<A>(iter : Iter.Iter<A>, hashFn : (A) -> Hash.Hash, isEq : (A, A) -> Bool) : Iter.Iter<(A, Bool)>
```

Returns an iterator with the elements of the given iter and a boolean
indicating if the element is unique.

### Example
```motoko
    import Nat "mo:base/Nat";
    import Hash "mo:base/Hash";

    let vals = [1, 2, 3, 1, 2, 3].vals();
    let it = Itertools.uniqueCheck(vals, Hash.hash, Nat.equal);

    assert Iter.toArray(it) == [
        (1, true), (2, true), (3, true),
        (1, false), (2, false), (3, false)
    ];

```

## Function `isUnique`
``` motoko no-repl
func isUnique<A>(iter : Iter.Iter<A>, hashFn : (A) -> Hash.Hash, isEq : (A, A) -> Bool) : Bool
```

Returns `true` if all the elements in the given iter are unique.
The hash function and equality function are used to compare elements.

> Note: If the iterator is empty, it will return `true`.
### Example

```motoko
    import Nat "mo:base/Nat";
    import Hash "mo:base/Hash";

    let vals = [1, 2, 3, 1, 2, 3].vals();
    let res = Itertools.isUnique(vals, Hash.hash, Nat.equal);

    assert res == false;

```

## Function `unzip`
``` motoko no-repl
func unzip<A>(iter : Iter.Iter<(A, A)>) : ([A], [A])
```

Unzips an iterator of tuples into a tuple of arrays.

### Example
```motoko

    let iter = [(1, 'a'), (2, 'b'), (3, 'c')].vals();
    let (arr1, arr2) = Itertools.unzip(iter);

    assert arr1 == [1, 2, 3];
    assert arr2 == ['a', 'b', 'c'];
```

## Function `zip`
``` motoko no-repl
func zip<A, B>(a : Iter.Iter<A>, b : Iter.Iter<B>) : Iter.Iter<(A, B)>
```

Zips two iterators into one iterator of tuples
The length of the zipped iterator is equal to the length
of the shorter iterator

### Example
```motoko

    let iter1 = [1, 2, 3, 4, 5].vals();
    let iter2 = "abc".chars();
    let zipped = Itertools.zip(iter1, iter2);

    assert zipped.next() == ?(1, 'a');
    assert zipped.next() == ?(2, 'b');
    assert zipped.next() == ?(3, 'c');
    assert zipped.next() == null;
```

## Function `zip3`
``` motoko no-repl
func zip3<A, B, C>(a : Iter.Iter<A>, b : Iter.Iter<B>, c : Iter.Iter<C>) : Iter.Iter<(A, B, C)>
```

Zips three iterators into one iterator of tuples
The length of the zipped iterator is equal to the length
of the shorter iterator

### Example
```motoko

    let iter1 = [1, 2, 3, 4, 5].vals();
    let iter2 = "abc".chars();
    let iter3 = [1.35, 2.92, 3.74, 4.12, 5.93].vals();

    let zipped = Itertools.zip3(iter1, iter2, iter3);

    assert zipped.next() == ?(1, 'a', 1.35);
    assert zipped.next() == ?(2, 'b', 2.92);
    assert zipped.next() == ?(3, 'c', 3.74);
    assert zipped.next() == null;
```

## Type `Either`
``` motoko no-repl
type Either<A, B> = {#left : A; #right : B}
```


## Type `EitherOr`
``` motoko no-repl
type EitherOr<A, B> = Either<A, B> or {#both : (A, B)}
```


## Function `zipLongest`
``` motoko no-repl
func zipLongest<A, B>(iterA : Iter.Iter<A>, iterB : Iter.Iter<B>) : Iter.Iter<EitherOr<A, B>>
```

Zips two iterators until both iterators are exhausted.
The length of the zipped iterator is equal to the length
of the longest iterator.

The iterator returns a [`EitherOr`](#EitherOr) type of the two iterators.

### Example
```motoko

    let iter1 = [1, 2, 3, 4, 5].vals();
    let iter2 = "abc".chars();
    let zipped = Itertools.zipLongest(iter1, iter2);

    assert zipped.next() == ?#both(1, 'a');
    assert zipped.next() == ?#both(2, 'b');
    assert zipped.next() == ?#both(3, 'c');
    assert zipped.next() == ?#left(4);
    assert zipped.next() == ?#left(5);
    assert zipped.next() == null;
```

## Function `fromArraySlice`
``` motoko no-repl
func fromArraySlice<A>(arr : [A], start : Nat, end : Nat) : Iter.Iter<A>
```

Transforms a slice of an array into an iterator

### Example
```motoko

    let arr = [1, 2, 3, 4, 5];
    let slicedIter = Itertools.fromArraySlice(arr, 2, arr.size());

    assert Iter.toArray(slicedIter) == [3, 4, 5];
```

## Function `toBuffer`
``` motoko no-repl
func toBuffer<A>(iter : Iter.Iter<A>) : Buffer.Buffer<A>
```

Collects an iterator of any type into a buffer

### Example
```motoko

    let vals = [1, 2, 3, 4, 5].vals();
    let buf = Itertools.toBuffer(vals);

    assert buf.toArray() == [1, 2, 3, 4, 5];
```

## Function `toDeque`
``` motoko no-repl
func toDeque<T>(iter : Iter.Iter<T>) : Deque.Deque<T>
```

Converts an iterator to a deque.

## Function `toList`
``` motoko no-repl
func toList<A>(iter : Iter.Iter<A>) : List.List<A>
```

Converts an Iter into a List

## Function `toText`
``` motoko no-repl
func toText(charIter : Iter.Iter<Char>) : Text
```

Collects an iterator of characters into a text

### Example
```motoko

    let chars = "abc".chars();
    let text = Itertools.toText(chars);

    assert text == "abc";
```

## Function `fromTrieSet`
``` motoko no-repl
func fromTrieSet<A>(set : TrieSet.Set<A>) : Iter.Iter<A>
```

Converts a TrieSet into an Iter

## Function `toTrieSet`
``` motoko no-repl
func toTrieSet<A>(iter : Iter.Iter<A>, hashFn : (A) -> Hash.Hash, isEq : (A, A) -> Bool) : TrieSet.Set<A>
```

Collects an iterator into a TrieSet

### Example
```motoko
    import Hash "mo:base/Hash";
    import TrieSet "mo:base/TrieSet";

    let vals = [1, 1, 2, 3, 4, 4, 5].vals();
    let set = Itertools.toTrieSet(vals, Hash.hash, Nat.equal);

    let setIter = Itertools.fromTrieSet(set);
    assert Iter.toArray(setIter) == [1, 2, 3, 4, 5];

```
