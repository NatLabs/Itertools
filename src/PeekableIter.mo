/// Peekable Iterator
///
/// An iterator equipped with a `peek` method that returns the next value without advancing the iterator.
///
/// The `PeekableIter` type is an extension of the `Iter` type built in Motoko
/// so it is compatible with all the function defined for the `Iter` type.
///
import Iter "mo:base/Iter";

module {
    /// Peekable Iterator Type.
    public type PeekableIter<T> = Iter.Iter<T> and {
        peek : () -> ?T;
    };

    /// Creates a `PeekableIter` from an `Iter`.
    ///
    /// #### Example:
    ///     let vals = [1, 2].vals();
    ///     let peekableIter = PeekableIter.fromIter(vals);
    ///
    ///     assert peekableIter.peek() == ?1;
    ///     assert peekableIter.peek() == ?1;
    ///     assert peekableIter.next() == ?1;
    ///
    ///     assert peekableIter.peek() == ?2;
    ///     assert peekableIter.peek() == ?2;
    ///     assert peekableIter.peek() == ?2;
    ///     assert peekableIter.next() == ?2;
    ///
    ///     assert peekableIter.peek() == null;
    ///     assert peekableIter.next() == null;
    /// ```
    public func fromIter<T>(iter : Iter.Iter<T>) : PeekableIter<T> {
        var next_item = iter.next();

        return object {
            public func peek() : ?T {
                next_item;
            };

            public func next() : ?T {
                switch (next_item) {
                    case (?val) {
                        next_item := iter.next();
                        ?val;
                    };
                    case (null) {
                        null;
                    };
                };
            };
        };
    };

    public func hasNext<T>(iter : PeekableIter<T>) : Bool {
        switch (iter.peek()) {
            case (?_) { true };
            case (null) { false };
        };
    };

    public func isNext<T>(iter : PeekableIter<T>, val : T, isEq: (T, T) -> Bool) : Bool {
        switch (iter.peek()) {
            case (?v) { isEq(v, val) };
            case (null) { false };
        };
    };

    /// Skips elements continuously while the predicate is true.
    ///
    /// ### Example
    /// ```motoko
    ///
    ///     let iter = [1, 2, 3, 4, 5].vals();
    ///     let lessThan3 = func (a: Int) : Bool { a < 3 };
    ///
    ///     Itertools.skipWhile(iter, lessThan3);
    ///
    ///     assert Iter.toArray(iter) == [3, 4, 5];
    ///
    /// ```
    public func skipWhile<A>(iter : PeekableIter<A>, pred : (A) -> Bool){

        label l loop {
            switch (iter.peek()) {
                case (?val) {
                    if (not pred(val)) {
                        break l;
                    };

                    ignore iter.next();
                };
                case (_) {
                    break l;
                };
            };
        };
    };

    /// Creates an iterator that returns elements from the given iter while the predicate is true.
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
    public func takeWhile<A>(iter : PeekableIter<A>, predicate : A -> Bool) : PeekableIter<A> {
        var iterate = true;

        return object {
            public func next() : ?A {
                if (not iterate) return null;

                let item = switch (iter.peek()) {
                    case (?item) item;
                    case (_) {
                        iterate := false;
                        return null;
                    };
                };

                if (predicate(item)) {
                    iter.next();
                } else {
                    iterate := false;
                    null;
                };
            };

            public func peek() : ?A  = iter.peek();
        };
    };
};
