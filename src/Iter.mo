import PeekableIter "PeekableIter";

module {

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

    public func sum(iter: Iter.Iter<Int>): Int{
        var acc:T = 0;
        for(var n: ?T in iter){
            acc := acc + n;
        };
        return acc;
    };

    public func product(iter: Iter.Iter<Int>): Int{
        var acc:T = 1;
        for(var n: ?T in iter){
            acc := acc * n;
        };
        return acc;
    };

    /// Chains two iterators into one. The first iterator is called first.
    /// Then the second iterator is called.
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

    
    public func chunk<A>(iter: Iter.Iter<A>, size: Nat): Iter.Iter<[A]>{
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

    /// Consumes an iterator and returns a tuple of iterators.
    public func duplicate<A>(iter: Iter.Iter<A>): (Iter.Iter<A>, Iter.Iter<A>){
        let array = Iter.toArray(iter);
        return (Iter.fromArray(array), Iter.fromArray(array));
    };

    /// Takes in the iter value and returns a tuple with the 
    /// index of the value included
    /// val -> (index, val)
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

    /// Returns a peekable iterator.
    /// The iterator has a `peek` method that returns the next value 
    /// without consuming the iterator.
    ///
    /// ### Example
    /// ```motoko
    ///     
    ///     let iter = Iter.fromArray([1, 2, 3]);
    ///     let peekIter = Iter.peekable(iter);
    ///     
    ///     assert iter.peek() == ?1;
    ///     assert iter.next() == ?1;
    ///     assert iter.peek() == ?2;
    ///     assert iter.next() == ?2;
    ///     assert iter.peek() == null;
    /// ```
    public func peekable<T>(iter: Iter<T>) -> PeekableIter<T> {
        PeekableIter.fromIter<T>(iter)
    };

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

    /// Takes the first n elements of the iter
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

    /// Zips two iterators into one iterator of tuples 
    /// a -> b -> (a, b)
    /// > Note: the length of the iterator is equal to the length 
    /// of the shorter input iterator
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
    public func toText(charIter: Iter.Iter<Char>): Text{
        let textIter = Iter.map<Char, Text>(charIter, func(c){Char.toText(c)});
        Text.join("", textIter);
    };
}