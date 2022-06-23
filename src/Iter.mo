/// Main module with utility functions for working efficiently with iterators.
/// 
/// See the [`Iter`](https://internetcomputer.org/docs/current/references/motoko-ref/iter#iter-1) module from the base lib for more information on the `Iter` type.
///
///
/// ## Getting started
///
/// To get started, you'll need to import the `Iter` module from both the base library and this one.
///
/// ```motoko
///     import Iter "mo:base/Iter";
///     import Itertools "mo:itertools/Iter";
/// ```
/// 
/// Converting data types to iterators is the next step.
/// - Array
///     - `[1, 2, 3, 4, 5].vals()`
///     - `Iter.fromArray([1, 2, 3, 4, 5])`
///
///
/// - List
///     - `Iter.fromList(list)`
///
///
/// - Text
///     - `"Hello, world!".chars()`
///     - `Text.split("a,b,c", #char ',')`
///
///
/// - [HashMap](https://internetcomputer.org/docs/current/references/motoko-ref/hashmap#hashmap-1)
///        - `map.entries()`
///
/// For conversion of other data types to iterators, you can look in the [base library](https://internetcomputer.org/docs/current/references/motoko-ref/array) for the specific data type's documentation.
///
///
/// Here are some examples of using the functions in this library to create simple and 
/// efficient iterators for solving different problems:
///
/// - An example, using `range` and `sum` to find the sum of values from 1 to 25:
/// 
/// ```motoko
///     let range = Itertools.range(1, 25 + 1);
///     let sum = Itertools.sum(range);
///
///     assert sum == ?325;
/// ```
///
///
/// - An example, using multiple functions to retrieve the indices of all even numbers in an array:
///
/// ```motoko
///     let vals = [1, 2, 3, 4, 5, 6].vals();
///     let iterWithIndices = Itertools.enumerate(vals);
///
///     let isEven = func ( x : (Int, Int)) : Bool { x.1 % 2 == 0 };
///     let mapIndex = func (x : (Int, Int)) : Int { x.0 };
///     let evenIndices = Itertools.filterMap(iterWithIndices, isEven, mapIndex);
///
///     assert Iter.toArray(evenIndices) == [1, 3, 5];
/// ```
///
///
/// - An example to find the difference between consecutive elements in an array:
///
/// ```motoko
///     let vals = [5, 3, 3, 7, 8, 10].vals();
///     
///     let tuples = Itertools.slidingTuples(vals);
///     // Iter.toArray(tuples) == [(5, 3), (3, 3), (3, 7), (7, 8), (8, 10)]
///     
///     let diff = func (x : (Int, Int)) : Int { x.1 - x.0 };
///     let iter = Iter.map(tuples, diff);
/// 
///     assert Iter.toArray(iter) == [-2, 0, 4, 1, 2];
/// ```

import Order "mo:base/Order";
import Buffer "mo:base/Buffer";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Char "mo:base/Char";
import Text "mo:base/Text";
import Prelude "mo:base/Prelude";

import PeekableIter "PeekableIter";

module {

    /// Consumes an iterator of integers and returns the sum of all values.
    /// An empty iterator returns `null`.
    ///
    /// ### Example
    /// ```motoko
    ///
    ///     let vals = [1, 2, 3, 4].vals();
    ///     let sum = Itertools.sum(vals);
    ///
    ///     assert sum == ?10;
    /// ```
    public func sum(iter: Iter.Iter<Int>): ?Int{
        var acc : Int = 0;
        var i = 0;
        for(n in iter){
            acc := acc + n;
            if (i==0){
                i+=1;
            }
        };

        if (i > 0){
            ?acc
        }else{
            null
        }
    };

    /// Consumes an iterator of integers and returns the product of all values.
    /// An empty iterator returns null.
    ///
    /// ### Example
    /// ```motoko
    ///
    ///     let vals = [1, 2, 3, 4].vals();
    ///     let prod = Itertools.product(vals);
    ///
    ///     assert prod == ?24;
    /// ```
    public func product(iter: Iter.Iter<Int>): ?Int{
        var acc : Int = 1;
        var i = 0;
        for(n in iter){
            acc := acc * n;
            if (i==0){
                i+=1;
            }
        };

        if (i > 0){
            ?acc
        }else{
            null
        }
    };

    /// Returns a reference to a modified iterator that returns the accumulated values based on the given predicate.
    ///  
    /// ### Example
    /// - An example calculating the running sum of a iterator:
    ///
    /// ```motoko
    ///    
    ///     let vals = [1, 2, 3, 4].vals();
    ///     let it = Itertools.accumulate(vals, func(a, b) { a + b });
    ///
    ///     assert it.next() == ?1;
    ///     assert it.next() == ?3;
    ///     assert it.next() == ?6;
    ///     assert it.next() == ?10;
    ///     assert it.next() == ?null;
    /// ```
    ///
    /// - An example calculating the running product of a iterator:
    ///
    /// ```motoko
    ///
    ///     let vals = [1, 2, 3, 4].vals();
    ///     let it = Itertools.accumulate(vals, func(a, b) { a * b });
    ///
    ///     assert it.next() == ?1;
    ///     assert it.next() == ?2;
    ///     assert it.next() == ?6;
    ///     assert it.next() == ?24;
    ///     assert it.next() == ?null;
    /// ```
    ///
    /// - An example with a record type:
    ///
    /// ```motoko
    ///
    ///     type Point = { x: Int, y: Int };
    ///
    ///     let vals: [Point] = [{ x = 1, y = 2 }, { x = 3, y = 4 }].vals();
    ///     
    ///     let it = Itertools.accumulate<Point>(vals, func(a, b) { 
    ///         return { x = a.x + b.x, y = a.y + b.y };
    ///     });
    ///
    ///     assert it.next() == ?{ x = 1, y = 2 };
    ///     assert it.next() == ?{ x = 4, y = 6 };
    ///     assert it.next() == null;
    /// ```
    public func accumulate<A>(iter: Iter.Iter<A>, predicate: (A, A) -> A): Iter.Iter<A>{
        var acc = iter.next();

        return object{
            public func next(): ?A{
                switch(acc, iter.next()){
                    case (?_acc, ?n){
                        let tmp = acc;
                        acc := ?predicate(_acc, n);
                        return tmp;  
                    };
                    case (?_acc, null) { 
                        acc := null;
                        return ?_acc;
                    };
                    case(_, _){
                        return null;
                    };
                }
            }
        };
    };

    /// Checks if all elements in the iterable satisfy the predicate.
    ///
    /// ### Example
    /// - An example checking if all elements in a iterator of integers are even:
    ///
    /// ```motoko
    ///
    ///     let a = [1, 2, 3, 4].vals();
    ///     let b = [2, 4, 6, 8].vals();
    ///
    ///     let isEven = func(a: Int): Bool { a % 2 == 0 };
    ///
    ///     assert Itertools.all(a, isEven) == false;
    ///     assert Itertools.all(b, isEven) == true;
    /// ```

    public func all<A>(iter: Iter.Iter<A>, predicate: (A) -> Bool): Bool{
        for ( item in iter ){
            if(not predicate(item)){
                return false;
            };
        };
        return true;
    };

    /// Checks if any element in the iterator satisfies the predicate.
    ///
    /// ### Example
    /// - An example checking if any element in a iterator of integers is even:
    ///
    /// ```motoko
    ///
    ///     let a = [1, 2, 3, 4].vals();
    ///     let b = [1, 3, 5, 7].vals();
    ///
    ///     let isEven = func(a: Nat) : Bool { a % 2 == 0 };
    ///
    ///     assert Itertools.any(a, isEven) == true;
    ///     assert Itertools.any(b, isEven) == false;
    /// ```
    public func any<A>(iter: Iter.Iter<A>, predicate: (A) -> Bool): Bool{
        for ( item in iter ){
            if(predicate(item)){
                return true;
            };
        };
        return false;
    };

    /// Chains two iterators of the same type together, so that the elements produced by the 
    /// second come after the elements produced by the first.
    /// 
    /// ### Example
    /// ```motoko
    /// 
    ///    let iter1 = [1, 2].vals();
    ///    let iter2 = [3, 4].vals();
    ///    let chained = Itertools.chain(iter1, iter2);
    ///
    ///     assert chained.next() == ?1
    ///     assert chained.next() == ?2
    ///     assert chained.next() == ?3
    ///     assert chained.next() == ?4
    ///     assert chained.next() == null
    /// ```
    public func chain<A>(a: Iter.Iter<A>, b: Iter.Iter<A>): Iter.Iter<A>{
        return object{
            public func next(): ?A{
                switch(a.next()){
                    case (?x){
                        ?x
                    };
                    case (null) {
                        b.next()
                    };
                };
            }
        };
    };

    /// Returns an iterator that accumulates elements into an arrays of `n` elements.
    ///
    /// ### Example
    /// - An example grouping a iterator of integers into arrays of size `3`:
    ///
    /// ```motoko
    ///
    ///     let vals = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].vals();
    ///     let it = Itertools.chunks(vals, 3);
    ///
    ///     assert it.next() == ?[1, 2, 3];
    ///     assert it.next() == ?[4, 5, 6];
    ///     assert it.next() == ?[7, 8, 9];
    ///     assert it.next() == ?[10];
    ///     assert it.next() == null;
    /// ```
    public func chunks<A>(iter: Iter.Iter<A>, size: Nat): Iter.Iter<[A]>{
        assert size > 0;

        object{
            public func next(): ?[A]{
                var i = 0;
                var buf = Buffer.Buffer<A>(size);

                label l while (i < size){
                    switch(iter.next()){
                        case (?val){
                            buf.add(val);
                            i:= i + 1;
                        };
                        case (_){
                            break l;
                        };
                    };
                };

                if (buf.size() == 0){
                    null
                }else{
                    ?buf.toArray()
                }
            }
        }
    };

    /// Returns an iterator that accumulates elements into an arrays with exactly `n` elements.
    /// If the iterator is shorter than `n` elements, `None` is returned.
    ///
    /// ### Example
    /// - An example grouping a iterator of integers into arrays of size `3`:
    ///
    /// ```motoko
    ///
    ///     let vals = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].vals();
    ///     let it = Itertools.chunksExact(vals, 3);
    ///
    ///     assert it.next() == ?[1, 2, 3];
    ///     assert it.next() == ?[4, 5, 6];
    ///     assert it.next() == ?[7, 8, 9];
    ///     assert it.next() == null;
    /// ```
    public func chunksExact<A>(iter: Iter.Iter<A>, size: Nat): Iter.Iter<[A]>{
        assert size > 0;

        let chunksIter = chunks(iter, size);

        object{
            public func next(): ?[A]{
                switch(chunksIter.next()){
                    case (?chunk){
                        if (chunk.size() == size){
                            ?chunk
                        }else{
                            null
                        };
                    };
                    case (null){
                        null
                    };
                };
            }
        }
    };

    /// Creates an iterator that loops infinitely over the values of a
    /// given iterator.
    /// 
    /// ### Example
    ///
    /// ```motoko
    ///
    ///     let chars = "abc".chars();
    ///     let it = Itertools.cycle(chars);
    ///
    ///     assert it.next() == ?'a';
    ///     assert it.next() == ?'b';
    ///     assert it.next() == ?'c';
    ///
    ///     assert it.next() == ?'a';
    ///     assert it.next() == ?'b';
    ///     assert it.next() == ?'c';
    ///
    ///     assert it.next() == ?'a';
    ///     // ...
    /// ```
    public func cycle<A>(iter: Iter.Iter<A>): Iter.Iter<A>{
        var buf = Buffer.Buffer<A>(1);
        var i = 0;

        return object{
            public func next(): ?A{
                switch(iter.next()){
                    case (?x){
                        buf.add(x);
                        ?x
                    };
                    case (null) {
                        if(buf.size() == 0){
                            null
                        }else{
                            if (i < buf.size()){
                                i+=1;
                                ?buf.get(i - 1)
                            }else{
                                i:=1;
                                ?buf.get(i - 1)
                            };
                        }
                    };
                };
            }
        }
    };


    /// Returns an iterator that returns tuples with the index of the element
    /// and the element.
    ///
    /// The index starts at 0 and is the first item in the tuple.
    /// 
    /// ```motoko
    /// 
    ///     let chars = "abc".chars();
    ///     let iter = Itertools.enumerate(chars);
    ///
    ///     for ((i, c) in iter){
    ///         Debug.print((i, c)); 
    ///     };
    ///     
    ///     // (0, 'a')
    ///     // (1, 'b')
    ///     // (2, 'c')
    /// ```
    public func enumerate<A>(iter: Iter.Iter<A> ): Iter.Iter<(Nat, A)> {
        var i =0;
        return object{
            public func next ():?(Nat, A) {
                let nextVal = iter.next();

                switch nextVal {
                    case (?v) {
                        let val = ?(i, v);
                        i+= 1;

                        return val;
                    };
                    case (_) null;
                };
            };
        };
    };

    /// Returns an iterator that filters elements based on a predicate and 
    /// maps them to a new value based on the second argument.
    ///
    /// ### Example
    /// - An example filtering odd numbers and squaring them:
    ///
    /// ```motoko
    ///
    ///     let vals = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].vals();
    ///     
    ///     let isEven = func( x : Nat ) : Bool { x % 2 == 0};
    ///     let square = func( x : Nat ) : Nat {x * x};
    ///     let it = Itertools.filterMap(vals, isEven, square);
    ///
    ///     assert it.next() == ?4
    ///     assert it.next() == ?16
    ///     assert it.next() == ?36
    ///     assert it.next() == ?64
    ///     assert it.next() == ?100
    ///     assert it.next() == null
    /// ```
    public func filterMap<A, B>(iter: Iter.Iter<A>, filter: (A) -> Bool, map: (A) -> B): Iter.Iter<B>{

        let filteredIter = Iter.filter(iter, filter);
        let mappedIter = Iter.map(filteredIter, map);
        return mappedIter;
    };

    /// Looks for an element in an iterator that matches a predicate.
    ///
    /// ### Example
    /// - An example finding the first even number in an iterator:
    ///
    /// ```motoko
    ///
    ///     let vals = [1, 2, 3, 4, 5].vals();
    ///
    ///     let isEven = func( x : Int ) : Bool {x % 2 == 0};
    ///     let res = Itertools.find(vals, isEven);
    ///
    ///     assert res == ?2
    /// ```
    public func find<A>(iter: Iter.Iter<A>, predicate: (A) -> Bool): ?A{
        for (val in iter){
            if (predicate(val)){
                return ?val
            };
        };
        return null;
    };

    /// Return the index of an element in an iterator that matches a predicate.
    ///
    /// ### Example
    ///
    /// ```motoko
    ///
    ///     let vals = [1, 2, 3, 4, 5].vals();
    ///
    ///     let isEven = func( x : Int ) : Bool {x % 2 == 0};
    ///     let res = Itertools.findIndex(vals, isEven);
    ///
    ///     assert res == ?1
    /// ```
    public func findIndex<A>(iter: Iter.Iter<A>, predicate: (A) -> Bool): ?Nat{
        var i = 0;
        for (val in iter){
            if (predicate(val)){
                return ?i
            };
            i+=1;
        };
        return null;
    };

    /// Returns the maximum value in an iterator.
    /// A null value is returned if the iterator is empty.
    ///
    /// ### Example
    ///
    /// ```motoko
    ///
    ///     let vals = [1, 2, 3, 4, 5].vals();
    ///     let max = Itertools.max(vals, Nat.compare);
    ///
    ///     assert max == ?5;
    /// ```
    ///
    /// - max on an empty iterator
    ///
    /// ```motoko
    ///
    ///     let vals = [].vals();
    ///     let max = Itertools.max(vals, Nat.compare);
    ///
    ///     assert max == null;
    /// ```
    public func max<A>(iter: Iter.Iter<A>, cmp: (A, A)-> Order.Order ): ?A{
        var max: ?A = null;

        for (val in iter){
            switch(max){
                case (?m) {
                    if (cmp(val, m) == #greater){
                        max := ?val;
                    }
                };
                case (null){
                    max := ?val;
                }
            }
        };

        return max;
    };

    /// Returns the minimum value in an iterator.
    /// A null value is returned if the iterator is empty.
    ///
    /// ### Example
    ///
    /// ```motoko
    ///
    ///     let vals = [8, 4, 6, 9].vals();
    ///     let min = Itertools.min(vals, Nat.compare);
    ///
    ///     assert min == ?4;
    /// ```
    ///
    /// - min on an empty iterator
    ///
    /// ```motoko
    ///
    ///     let vals: [Nat] = [].vals();
    ///     let min = Itertools.min(vals, Nat.compare);
    ///
    ///     assert min == null;
    /// ```
    public func min<A>(iter: Iter.Iter<A>, cmp: (A, A)-> Order.Order ): ?A{
        var min: ?A = null;

        for (val in iter){
            switch(min){
                case (?m) {
                    if (cmp(val, m) ==  #less ){
                        min := ?val;
                    }
                };
                case (null){
                    min := ?val;
                }
            }
        };

        return min;
    };

    /// Returns a tuple of the minimum and maximum value in an iterator.
    /// The first element is the minimum, the second the maximum.
    ///
    /// A null value is returned if the iterator is empty.
    ///
    /// If the iterator contains only one element, then it is returned as both
    /// the minimum and the maximum.
    ///
    /// ### Example
    ///
    /// ```motoko
    ///
    ///     let vals = [8, 4, 6, 9].vals();
    ///     let minmax = Itertools.minmax(vals);
    ///
    ///     assert minmax == ?(4, 9);
    /// ```
    ///
    /// - minmax on an empty iterator
    ///
    /// ```motoko
    ///
    ///     let vals = [].vals();
    ///     let minmax = Itertools.minmax(vals);
    ///
    ///     assert minmax == null;
    /// ```
    /// - minmax on an iterator with one element
    ///
    /// ```motoko
    ///
    ///     let vals = [8].vals();
    ///     let minmax = Itertools.minmax(vals);
    ///
    ///     assert minmax == ?(8, 8);
    /// ```
    public func minmax<A>(iter: Iter.Iter<A>, cmp: (A, A) -> Order.Order): ?(A, A){
        let (_min, _max) = switch(iter.next()){
            case (?a) {
                switch (iter.next()){
                    case (?b) {
                        switch(cmp(a, b)){
                            case (#less) {
                                (a, b)
                            };
                            case (_){
                                (b, a)
                            };
                        }
                    };
                    case (_) {
                        (a, a)
                    };
                };
            };
            case (_) {
                return null;
            };
        };

        var min = _min;
        var max = _max;

        for (val in iter){
            let order = cmp(val, min);
            if (order == #less){
                min := val;
            }else if (order == #greater){
                max := val;
            }
        };

        ?(min, max)

    };

    /// Returns the nth element of an iterator.
    /// Consumes the first n elements of the iterator.
    ///
    /// ### Example
    ///
    /// ```motoko
    ///
    ///     let vals = [0, 1, 2, 3, 4, 5].vals();
    ///     let nth = Itertools.nth(vals, 3);
    ///
    ///     assert nth == ?3;
    /// ```
    ///
    public func nth<A>(iter: Iter.Iter<A>, n: Nat): ?A{
        skip<A>(iter, n);
        return iter.next();
    };

    /// Returns the nth elements of an iterator or a given default value.
    ///
    /// ### Example
    ///
    /// ```motoko
    ///
    ///     let vals = [0, 1, 2, 3, 4, 5].vals();
    ///
    ///     assert Itertools.nthOrDefault(vals, 3, -1) == ?3;
    ///     assert Itertools.nthOrDefault(vals, 3, -1) == ?-1;
    /// ```
    public func nthOrDefault<A>(iter: Iter.Iter<A>, n: Nat, defaultValue: A): A{
        switch(nth<A>(iter, n)){
            case (?a) {
                return a;
            };
            case (_) {
                return defaultValue;
            };
        };
    };

    /// Returns a peekable iterator.
    /// The iterator has a `peek` method that returns the next value 
    /// without consuming the iterator.
    ///
    /// ### Example
    /// ```motoko
    ///     
    ///     let vals = Iter.fromArray([1, 2]);
    ///     let peekIter = Itertools.peekable(vals);
    ///     
    ///     assert peekIter.peek() == ?1;
    ///     assert peekIter.next() == ?1;
    ///
    ///     assert peekIter.peek() == ?2;
    ///     assert peekIter.peek() == ?2;
    ///     assert peekIter.next() == ?2;
    ///
    ///     assert peekIter.peek() == null;
    ///     assert peekIter.next() == null;
    /// ```
    public func peekable<T>(iter: Iter.Iter<T>) : PeekableIter.PeekableIter<T> {
        PeekableIter.fromIter<T>(iter)
    };

    /// Returns a `Nat` iterator that yields numbers in range [start, end).
    /// The base library provides a `range` function that returns an iterator from with start and end both inclusive.
    ///
    /// ### Example
    ///
    /// ```motoko
    ///
    ///     let iter = Itertools.range(1, 5);
    ///
    ///     assert iter.next() == ?1;
    ///     assert iter.next() == ?2;
    ///     assert iter.next() == ?3;
    ///     assert iter.next() == ?4;
    ///     assert iter.next() == null;
    /// ```
    public func range(start: Nat, end: Nat): Iter.Iter<Nat>{
        var i: Int = start;

        return object {
            public func next(): ?Nat {
                if (i < end ) {
                    i += 1;
                    return ?Int.abs(i - 1);
                } else {
                    return null;
                }
            };
        };
    };

    /// Returns a `Int` iterator that yields numbers in range [start, end).
    ///
    /// ### Example
    ///
    /// ```motoko
    ///
    ///     let iter = Itertools.intRange(1, 4);
    ///
    ///     assert iter.next() == ?1;
    ///     assert iter.next() == ?2;
    ///     assert iter.next() == ?3;
    ///     assert iter.next() == null;
    /// ```
    public func intRange(start: Int, end: Int): Iter.Iter<Int>{
        var i: Int = start;

        return object {
            public func next(): ?Int {
                if (i < end ) {
                    i += 1;
                    return ?i;
                } else {
                    return null;
                }
            };
        };
    };

    /// Returns a reference to the iterator
    ///
    /// Instead of using this method you could copy the ptr directly:
    /// ```motoko
    ///     let iter = Itertools.range(1, 5);
    ///     let ref = iter;
    /// ```
    ///
    /// #### Example
    /// ```motoko
    ///
    ///     let iter = Iter.fromArray([1, 2, 3]);
    ///     let refIter = Itertools.ref(iter);
    ///
    ///     assert iter.next() == ?1;
    ///     assert refIter.next() == ?2;
    ///     assert iter.next() == ?3;
    ///     assert refIter.next() == null;
    ///     assert iter.next() == null;
    /// ```

    public func ref<A>(iter: Iter.Iter<A>): Iter.Iter<A>{
        return iter;
    };

    /// Returns an iterator that repeats a given value `n` times.
    /// To repeat a value infinitely, use `Iter.make` from the base library.
    ///
    /// ### Example
    /// ```motoko
    ///
    ///     let iter = Itertools.repeat(3, 1);
    ///
    ///     assert iter.next() == ?1;
    ///     assert iter.next() == ?1;
    ///     assert iter.next() == ?1;
    ///     assert iter.next() == null;
    /// ```
    public func repeat<A>(item: A, n: Nat): Iter.Iter<A>{
        var i = 0;
        return object{
            public func next(): ?A{
                if (i < n){
                    i += 1;
                    return ?item;
                }else{
                    null
                }
            }
        };
    };

    /// Skips the first n elements of the iter
    ///
    /// ### Example
    /// ```motoko
    ///
    ///     let iter = [1, 2, 3, 4, 5].vals();
    ///     Itertools.skip(iter, 2);
    ///
    ///     assert iter.next() == ?3;
    ///     assert iter.next() == ?4;
    ///     assert iter.next() == ?5;
    ///     assert iter.next() == null;
    /// ```
    public func skip<A>(iter: Iter.Iter<A>, n: Nat){
        var i = 0;
        label l while (i < n){
            switch(iter.next()){
                case (?val){
                    i:= i + 1;
                };
                case (_){
                    break l;
                };
            };
        }
    };

    /// Returns overlapping tuple pairs from the given iterator.
    /// The first element of the iterator is paired with the second element, and the 
    /// second is paired with the third element, and so on. 
    /// ?(a, b), ?(b, c), ?(c, d), ...
    ///
    /// If the iterator has fewer than two elements, an null value is returned.
    ///
    /// ### Example
    ///
    /// ```motoko
    ///
    ///     let vals = [1, 2, 3, 4, 5].vals();
    ///     let pairs = Itertools.slidingTuples(vals);
    ///
    ///     assert pairs.next() == ?(1, 2);
    ///     assert pairs.next() == ?(2, 3);
    ///     assert pairs.next() == ?(3, 4);
    ///     assert pairs.next() == ?(4, 5);
    ///     assert pairs.next() == null;
    /// ```
    public func slidingTuples<A>(iter: Iter.Iter<A>): Iter.Iter<(A, A)>{
        var prev = iter.next();

        return object{
            public func next(): ?(A, A){
                switch(prev, iter.next()){
                    case (?_prev, ?curr){
                        let tmp = (_prev, curr);
                        prev := ?curr;
                        ?tmp
                    };
                    case(_){
                        return null;
                    };
                };
            };
        };
    };

    /// Returns consecutive, overlapping triplets from the given iterator.
    /// The iterator returns a tuple of three elements, which include the current element and the two proceeding ones.
    /// ?(a, b, c), ?(b, c, d), ?(c, d, e), ...
    ///
    /// If the iterator has fewer than three elements, an null value is returned.
    ///
    /// ### Example
    ///
    /// ```motoko
    ///
    ///     let vals = [1, 2, 3, 4, 5].vals();
    ///     let triples = Itertools.slidingTriples(vals);
    ///
    ///     assert triples.next() == ?(1, 2, 3);
    ///     assert triples.next() == ?(2, 3, 4);
    ///     assert triples.next() == ?(3, 4, 5);
    ///     assert triples.next() == null;
    /// ```
    public func slidingTriples<A>(iter: Iter.Iter<A>): Iter.Iter<(A, A, A)>{
        var a = iter.next();
        var b = iter.next();

        return object{
            public func next(): ?(A, A, A){
                switch(a, b, iter.next()){
                    case (?_a, ?_b, ?curr){
                        let tmp = (_a, _b, curr);
                        a := b;
                        b := ?curr;
                        ?tmp
                    };
                    case(_){
                        return null;
                    };
                };
            };
        };
    };

    /// Returns a tuple of iterators where the first element is the first n elements of the iterator, and the second element is the remaining elements.
    ///
    /// ### Example
    /// ```motoko
    ///
    ///     let iter = [1, 2, 3, 4, 5].vals();
    ///     let (left, right) = Itertools.splitAt(iter, 3);
    ///
    ///     assert left.next() == ?1;
    ///     assert right.next() == ?4;
    ///
    ///     assert left.next() == ?2;
    ///     assert right.next() == ?5;
    ///
    ///     assert left.next() == ?3;
    ///
    ///     assert left.next() == null;
    ///     assert right.next() == null;
    /// ```
    public func splitAt<A>(iter: Iter.Iter<A>, n: Nat): (Iter.Iter<A>, Iter.Iter<A>) {
        var left = Iter.toArray(take(iter, n)).vals();
        (left, iter)
    };

    /// Returns a tuple of iterators where the first element is an iterator with a copy of 
    /// the first n elements of the iterator, and the second element is the original iterator
    /// with all the elements
    ///
    /// ### Example
    /// ```motoko
    ///
    ///     let vals = [1, 2, 3, 4, 5].vals();
    ///     let (copy, iter) = Itertools.spy(vals, 3);
    ///
    ///     assert copy.next() == ?1;  
    ///     assert copy.next() == ?2;
    ///     assert copy.next() == ?3;
    ///     assert copy.next() == null;
    ///
    ///     assert vals.next() == ?1;
    ///     assert vals.next() == ?2;
    ///     assert vals.next() == ?3;
    ///     assert vals.next() == ?4;
    ///     assert vals.next() == ?5;
    ///     assert vals.next() == null;
    /// ```

    public func spy<A>(iter: Iter.Iter<A>, n: Nat): (Iter.Iter<A>, Iter.Iter<A>) {
        // let firstN = 
        var copy = Iter.toArray(take(iter, n));
        (copy.vals(), chain(copy.vals(), iter))
    };

    /// Returns every nth element of the iterator.
    /// n must be greater than zero.
    ///
    /// ### Example
    /// ```motoko
    ///
    ///     let vals = [1, 2, 3, 4, 5].vals();
    ///     let iter = Itertools.stepBy(vals, 2);
    ///
    ///     assert iter.next() == ?1;
    ///     assert iter.next() == ?3;
    ///     assert iter.next() == ?5;
    ///     assert iter.next() == null;
    /// ```
    public func stepBy<A>(iter: Iter.Iter<A>, n: Nat): Iter.Iter<A> {
        assert n > 0;

        var i = 0;
        var opt = iter.next();

        return object{
            public func next(): ?A{
                switch(opt){
                    case (?item){
                        skip(iter, Int.abs(n - 1));
                        opt := iter.next();
                        ?item
                    };
                    case (_){
                        return null;
                    };
                };
            }
        };
    };

    /// Returns an iterator with the first n elements of the given iter
    /// > Be aware that this returns a ref to the original iterator so
    /// > using it will cause the original iterator to be skipped.
    /// 
    /// If you want to keep the original iterator, use `spy` instead.
    /// 
    /// Note that using the returned iterator and the given iterator at the same time will cause the values in both iterators to be skipped.
    ///
    /// ### Example
    /// ```motoko
    ///
    ///     let iter = Iter.fromArray([1, 2, 3, 4, 5]);
    ///     let it = Itertools.take(iter, 3);
    ///
    ///     assert it.next() == ?1;
    ///     assert it.next() == ?2;
    ///     assert it.next() == ?3;
    ///     assert it.next() == null;
    ///
    ///     // the first n elements of the original iterator are skipped
    ///     assert iter.next() == ?4;
    ///     assert iter.next() == ?5;
    ///     assert iter.next() == null;
    /// ```

    public func take<A>(iter: Iter.Iter<A>, n: Nat): Iter.Iter<A>{
        var i = 0;
        return object{
            public func next(): ?A{
                if (i < n){
                    i:= i + 1;
                    iter.next()
                }else{
                    null
                };
            };
        };
    };

    /// Creates an iterator that returns returns elements from the given iter while the predicate is true.
    ///
    /// ### Example
    /// ```motoko
    ///
    ///     let vals = Iter.fromArray([1, 2, 3, 4, 5]);
    ///
    ///     let lessThan3 = func (x: Int) : Bool { x < 3 };
    ///     let it = Itertools.takeWhile(vals, lessThan3);
    ///
    ///     assert it.next() == ?1;
    ///     assert it.next() == ?2;
    ///     assert it.next() == null;
    /// ```
    public func takeWhile<A>(iter: Iter.Iter<A>, predicate: A -> Bool): Iter.Iter<A>{
        var iterate = true;
        return object{
            public func next(): ?A{
                if (iterate){
                    switch(iter.next()){
                        case (?item){
                            if (predicate(item)){
                                ?item
                            }else{
                                iterate := false;
                                null
                            };
                        };
                        case (_){
                            iterate := false;
                            return null;
                        };
                    };
                }else{
                    return null;
                }
            }
        };
    };

    /// Consumes an iterator and returns a tuple of cloned iterators.
    ///
    /// ### Example
    /// ```motoko
    ///
    ///     let iter = [1, 2, 3].vals();
    ///     let (iter1, iter2) = Itertools.tee(iter, 2);
    ///
    ///     assert iter1.next() == ?1;
    ///     assert iter1.next() == ?2;
    ///     assert iter1.next() == ?3;
    ///     assert iter1.next() == null;
    ///
    ///     assert iter2.next() == ?1;
    ///     assert iter2.next() == ?2;
    ///     assert iter2.next() == ?3;
    ///     assert iter2.next() == null;
    /// ```

    public func tee<A>(iter: Iter.Iter<A>): (Iter.Iter<A>, Iter.Iter<A>){
        let array = Iter.toArray(iter);
        return (Iter.fromArray(array), Iter.fromArray(array));
    };

    /// Returns an iterator of consecutive, non-overlapping tuple pairs of elements from a single iter.
    /// The first element is paired with the second element, the third element with the fourth, and so on.
    /// ?(a, b), ?(c, d), ?(e, f) ...
    ///
    /// If the iterator has less than two elements, it will return a null.
    /// > For overlappping pairs use slidingTuples.
    ///
    /// ### Example
    /// ```motoko
    ///
    ///     let vals = [1, 2, 3, 4, 5].vals();
    ///     let it = Itertools.tuples(vals);
    ///
    ///     assert it.next() == ?(1, 2);
    ///     assert it.next() == ?(3, 4);
    ///     assert it.next() == null;
    /// 
    /// ```
    public func tuples<A>(iter: Iter.Iter<A>): Iter.Iter<(A, A)>{
        return object{
            public func next(): ?(A, A){
                switch(iter.next(), iter.next()){
                    case(?a, ?b){
                        ?(a, b)
                    };
                    case(_){
                        null
                    };
                };
            }
        };
    };

    /// Returns an iterator of consecutive, non-overlapping triplets of elements from a single iter.
    /// ?(a, b, c), ?(d, e, f) ...
    ///
    /// If the iterator has less than three elements, it will return a null.
    ///
    /// ### Example
    /// ```motoko
    ///
    ///     let vals = [1, 2, 3, 4, 5, 6, 7].vals();
    ///     let it = Itertools.triples(vals);
    ///
    ///     assert it.next() == ?(1, 2, 3);
    ///     assert it.next() == ?(4, 5, 6);
    ///     assert it.next() == null;
    ///
    /// ```
    public func triples<A>(iter: Iter.Iter<A>): Iter.Iter<(A, A, A)>{
        return object{
            public func next(): ?(A, A, A){
                switch(iter.next(), iter.next(), iter.next()){
                    case(?a, ?b, ?c){
                        ?(a, b, c)
                    };
                    case(_){
                        null
                    };
                };
            }
        };
    };

    /// Unzips an iterator of tuples into a tuple of arrays.
    ///
    /// ### Example
    /// ```motoko
    ///
    ///     let iter = [(1, 'a'), (2, 'b'), (3, 'c')].vals();
    ///     let (arr1, arr2) = Itertools.unzip(iter);
    ///
    ///     assert arr1 == [1, 2, 3];
    ///     assert arr2 == ['a', 'b', 'c'];
    /// ```
    public func unzip<A>(iter: Iter.Iter<(A, A)>): ([A], [A]){
        var buf1 = Buffer.Buffer<A>(1);
        var buf2 = Buffer.Buffer<A>(1);

        for ((a, b) in iter){
            buf1.add(a);
            buf2.add(b);
        };

        (buf1.toArray(), buf2.toArray())
    };


    /// Zips two iterators into one iterator of tuples 
    /// The length of the zipped iterator is equal to the length 
    /// of the shorter iterator
    ///
    /// ### Example
    /// ```motoko
    ///
    ///     let iter1 = [1, 2, 3, 4, 5].vals();
    ///     let iter2 = "abc".chars();
    ///     let zipped = Itertools.zip(iter1, iter2);
    ///
    ///     assert zipped.next() == ?(1, 'a');
    ///     assert zipped.next() == ?(2, 'b');
    ///     assert zipped.next() == ?(3, 'c');
    ///     assert zipped.next() == null;
    /// ```

    public func zip<A, B>(a: Iter.Iter<A>, b:Iter.Iter<B>): Iter.Iter<(A, B)>{
        object{
            public func next(): ?(A, B){
                switch(a.next(), b.next()){
                    case(?valueA, ?valueB) ?(valueA, valueB);
                    case(_, _) null;
                }
            }
        }
    };

    /// Zips three iterators into one iterator of tuples
    /// The length of the zipped iterator is equal to the length
    /// of the shorter iterator
    ///
    /// ### Example
    /// ```motoko
    ///
    ///     let iter1 = [1, 2, 3, 4, 5].vals();
    ///     let iter2 = "abc".chars();
    ///     let iter3 = [1.35, 2.92, 3.74, 4.12, 5.93].vals();
    ///
    ///     let zipped = Itertools.zip3(iter1, iter2, iter3);
    ///
    ///     assert zipped.next() == ?(1, 'a', 1.35);
    ///     assert zipped.next() == ?(2, 'b', 2.92);
    ///     assert zipped.next() == ?(3, 'c', 3.74);
    ///     assert zipped.next() == null;
    /// ```
    public func zip3<A, B, C>(a: Iter.Iter<A>, b:Iter.Iter<B>, c:Iter.Iter<C>): Iter.Iter<(A, B, C)>{
        object{
            public func next(): ?(A, B, C){
                switch(a.next(), b.next(), c.next()){
                    case(?valueA, ?valueB, ?valueC) ?(valueA, valueB, valueC);
                    case(_, _, _) null;
                }
            }
        }
    };

    /// Collects a character iterator into a text
    ///
    /// ### Example
    /// ```motoko
    ///
    ///     let chars = ['a', 'b', 'c'].vals();
    ///     let text = Itertools.toText(chars);
    ///
    ///     assert text == "abc";
    /// ```
    public func toText(charIter: Iter.Iter<Char>): Text{
        let textIter = Iter.map<Char, Text>(charIter, func(c){Char.toText(c)});
        Text.join("", textIter);
    };
}