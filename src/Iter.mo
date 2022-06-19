import PeekableIter "PeekableIter";

module {

    /// Returns a reference to a modified iterator that returns the accumulated values based on the given predicate.
    ///  
    /// ### Example
    /// - An example calculating the running sum of a iterator of integers:
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
    /// - An example calculating the running product of a iterator of integers:
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

    public func accumulate(iter: Iter.Iter<Int>, predicate: (Int, Int) -> Int): Iter.Iter<Int>{
        var acc:Int = 0;
        return object{
            public func next(): ?Int{
                switch(iter.next()){
                    case (null) null;
                    case (?n){
                        acc := predicate(acc, n);
                        return ?acc;  
                    };
                }
            }
        };
    };

    /// Consumes an iterator of integers and returns the sum of all values.
    /// An empty iterator returns 0.
    ///
    /// ### Example
    /// ```motoko
    ///
    ///     let vals = [1, 2, 3, 4].vals();
    ///     let sum = Itertools.sum(vals);
    ///
    ///     assert sum == 10;
    /// ```
    public func sum(iter: Iter.Iter<Int>): Int{
        var acc:T = 0;
        for(var n: ?T in iter){
            acc := acc + n;
        };
        return acc;
    };

    /// Consumes an iterator of integers and returns the product of all values.
    /// An empty iterator returns 1.
    ///
    /// ### Example
    /// ```motoko
    ///
    ///     let vals = [1, 2, 3, 4].vals();
    ///     let prod = Itertools.product(vals);
    ///
    ///     assert prod == 24;
    /// ```
    public func product(iter: Iter.Iter<Int>): Int{
        var acc:T = 1;
        for(var n: ?T in iter){
            acc := acc * n;
        };
        return acc;
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
    ///     let isEven = func(a) { a % 2 == 0 };
    ///
    ///     assert Itertools.all(a, isEven) == false;
    ///     assert Itertools.all(b, isEven) == true;
    /// ```

    public func all<A>(iter: Iter.Iter<A>, predicate: (A) -> Bool): Bool{
        for ( item in iter ){
            if(!predicate(item)){
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
    ///     let isEven = func(a) { a % 2 == 0 };
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
    ///    chained = Itertools.chain(iter1, iter2);
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
        var buf = Buffer.Buffer<A>();
        
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
    ///     let isEven = func(x){x % 2 == 0};
    ///     let square = func(x){x * x};
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

    /// Returns a peekable iterator.
    /// The iterator has a `peek` method that returns the next value 
    /// without consuming the iterator.
    ///
    /// ### Example
    /// ```motoko
    ///     
    ///     let iter = Iter.fromArray([1, 2]);
    ///     let peekIter = Itertools.peekable(iter);
    ///     
    ///     assert iter.peek() == ?1;
    ///     assert iter.next() == ?1;
    ///
    ///     assert iter.peek() == ?2;
    ///     assert iter.peek() == ?2;
    ///     assert iter.next() == ?2;
    ///
    ///     assert iter.peek() == null;
    ///     assert iter.next() == null;
    /// ```
    public func peekable<T>(iter: Iter<T>) -> PeekableIter<T> {
        PeekableIter.fromIter<T>(iter)
    };

    /// Returns a reference to the iterator
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
    s
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

    /// Returns an iterator with the first n elements of the given iter
    /// > Be aware that this returns a ref to the original iterator so
    /// > using it will cause the original iterator to be skipped.
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

    /// Consumes an iterator and returns a tuple of cloned iterators.
    ///
    /// ### Example
    /// ```motoko
    ///
    ///     let iter = [1, 2, 3].vals();
    ///     let (iter1, iter2) = Itertools.tee(iter, 2);
    ///
    ///     assert iter.next() == null;
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
    ///     assert zipped.next() == ?(1, "a");
    ///     assert zipped.next() == ?(2, "b");
    ///     assert zipped.next() == ?(3, "c");
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

    /// Collects a character iterator into a text
    ///
    /// ### Example
    /// ```motoko
    ///
    ///     let iter = "abc".chars();
    ///     let text = Itertools.toText(iter);
    ///
    ///     assert text == "abc";
    /// ```
    public func toText(charIter: Iter.Iter<Char>): Text{
        let textIter = Iter.map<Char, Text>(charIter, func(c){Char.toText(c)});
        Text.join("", textIter);
    };
}