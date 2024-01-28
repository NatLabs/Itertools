/// Reversible Iterator
///
/// Reversible Iterators supports iteration over a data structure in both directions.
///
/// They are useful for iterating over data structures in reverse without allocating extra space for the reverse iteration.
///
/// The `RevIter` type is an extension of the `Iter` type so it is compatible with all the function defined for the `Iter` type.
///
/// - An example reversing a list of integers and breaking them into chunks of size `n`:
///
/// ```motoko
///
///   import Itertools "mo:itertools/Iter";
///   import RevIter "mo:itertools/RevIter";
///
///   let arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
///
///   // create a Reversible Iterator from an array
///   let iter = RevIter.fromArray(arr);
///
///   // reverse Reversible Iterator
///   let rev_iter = iter.rev();
///
///   // Reversible Iterator gets typecasted to an Iter type
///   let chunks = Itertools.chunks(rev_iter, 3);
///
///   assert chunks.next() == ?[10, 9, 8];
///   assert chunks.next() == ?[7, 6, 5];
///   assert chunks.next() == ?[4, 3, 2];
///   assert chunks.next() == ?[1];
///   assert chunks.next() == null;
///
/// ```

import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Int "mo:base/Int";
import List "mo:base/List";
import Deque "mo:base/Deque";
import Option "mo:base/Option";

module RevIter {

    /// A Reversible Iterator.
    public type RevIter<T> = {
        /// Returns the next element in the iterator.
        next : () -> ?T;

        /// Returns the element at the end of the iterator
        nextFromEnd : () -> ?T;

        /// Returns a new iterator that is the reverse of this one.
        rev : () -> RevIter<T>;
    };

    /// Create a new Reversible Iterator by providing functions for `next` and `nextFromEnd`
    public func new<A>(next : () -> ?A, nextFromEnd : () -> ?A) : RevIter<A> {
        let iter = {
            next = next;
            nextFromEnd = nextFromEnd;
            rev = func() : RevIter<A> {
                {
                    next = nextFromEnd;
                    nextFromEnd = next;
                    rev = func() = iter;
                };
            };
        };
    };

    /// Map a function over a Reversible Iterator
    public func map<A, B>(rev_iter : RevIter<A>, f : (A) -> B) : RevIter<B> {
        func next() : ?B {
            Option.map(rev_iter.next(), f);
        };

        func nextFromEnd() : ?B {
            Option.map(rev_iter.nextFromEnd(), f);
        };

        return new(next, nextFromEnd);
    };

    /// Returns a Reversible Iterator over a range of natural, `Nat` numbers from [start, end)
    public func range(start : Nat, end : Nat) : RevIter<Nat> {
        func intToNat(int : Int) : Nat = Int.abs(int);
        return RevIter.map(intRange(start, end), intToNat);
    };

    /// Returns a Reversible Iterator over a range of integers (`Int`) from [start, end)
    public func intRange(start : Int, end : Int) : RevIter<Int> {
        var i = start;
        var j = end;

        func next() : ?Int {
            if (i < end and i < j) {
                let tmp = i;
                i += 1;
                return ?tmp;
            } else {
                return null;
            };
        };

        func nextFromEnd() : ?Int {
            if (j > start and j > i) {
                j -= 1;
                return ?j;
            } else {
                return null;
            };
        };

        return RevIter.new(next, nextFromEnd);
    };

    /// Creates an iterator for the elements of an array.
    ///
    /// #### Example
    ///
    /// ```motoko
    ///
    ///   let arr = [1, 2, 3];
    ///   let iter = RevIter.fromArray(arr);
    ///
    ///   assert rev_iter.next() == ?1;
    ///   assert rev_iter.nextFromEnd() == ?3;
    ///   assert rev_iter.nextFromEnd() == ?2;
    ///   assert rev_iter.nextFromEnd() == null;
    ///   assert rev_iter.next() == null;
    ///
    /// ```
    public func fromArray<T>(array : [T]) : RevIter<T> {
        var left = 0;
        var right = array.size();

        func next() : ?T {
            if (left < right) {
                left += 1;
                ?array[left - 1];
            } else {
                null;
            };
        };

        func nextFromEnd() : ?T {
            if (left < right) {
                right -= 1;
                ?array[right];
            } else {
                null;
            };
        };

        return RevIter.new(next, nextFromEnd);
    };

    public func toArray<T>(RevIter : RevIter<T>) : [T] {
        Iter.toArray(RevIter);
    };

    public func fromVarArray<T>(array : [var T]) : RevIter<T> {
        var left = 0;
        var right = array.size();

        func next() : ?T {
            if (left < right) {
                left += 1;
                ?array[left - 1];
            } else {
                null;
            };
        };

        func nextFromEnd() : ?T {
            if (left < right) {
                right -= 1;
                ?array[right];
            } else {
                null;
            };
        };

        return RevIter.new(next, nextFromEnd);
    };

    public func toVarArray<T>(RevIter : RevIter<T>) : [var T] {
        Iter.toArrayMut<T>(RevIter);
    };

    type GenericBuffer<T> = {
        size : () -> Nat;
        get : (Nat) -> T;
    };

    public func fromBuffer<T>(buffer : GenericBuffer<T>) : RevIter<T> {
        var left = 0;
        var right = buffer.size();

        func next() : ?T {
            if (left < right) {
                left += 1;
                ?buffer.get(left - 1);
            } else {
                null;
            };
        };

        func nextFromEnd() : ?T {
            if (left < right) {
                right -= 1;
                ?buffer.get(right);
            } else {
                null;
            };
        };

        return RevIter.new(next, nextFromEnd);
    };

    /// Returns an iterator for a deque.
    public func fromDeque<T>(deque : Deque.Deque<T>) : RevIter<T> {

        var deq = deque;

        func next() : ?T {
            switch (Deque.popFront(deq)) {
                case (?(val, next)) {
                    deq := next;
                    ?val;
                };
                case (null) null;
            };
        };

        func nextFromEnd() : ?T {
            switch (Deque.popBack(deq)) {
                case (?(prev, val)) {
                    deq := prev;
                    ?val;
                };
                case (null) null;
            };
        };

        return RevIter.new(next, nextFromEnd);
    };

    /// Converts an iterator to a deque.
    public func toDeque<T>(RevIter : RevIter<T>) : Deque.Deque<T> {
        var dq = Deque.empty<T>();

        for (item in RevIter) {
            dq := Deque.pushBack(dq, item);
        };

        dq;
    };
};
