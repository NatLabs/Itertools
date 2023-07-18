# PeekableIter
Peekable Iterator

An iterator equipped with a `peek` method that returns the next value without advancing the iterator.

The `PeekableIter` type is an extension of the `Iter` type built in Motoko
so it is compatible with all the function defined for the `Iter` type.


## Type `PeekableIter`
``` motoko no-repl
type PeekableIter<T> = Iter.Iter<T> and { peek : () -> ?T }
```

Peekable Iterator Type.

## Function `fromIter`
``` motoko no-repl
func fromIter<T>(iter : Iter.Iter<T>) : PeekableIter<T>
```

Creates a `PeekableIter` from an `Iter`.

#### Example:
    let vals = [1, 2].vals();
    let peekableIter = PeekableIter.fromIter(vals);

    assert peekableIter.peek() == ?1;
    assert peekableIter.peek() == ?1;
    assert peekableIter.next() == ?1;

    assert peekableIter.peek() == ?2;
    assert peekableIter.peek() == ?2;
    assert peekableIter.peek() == ?2;
    assert peekableIter.next() == ?2;

    assert peekableIter.peek() == null;
    assert peekableIter.next() == null;
```

## Function `hasNext`
``` motoko no-repl
func hasNext<T>(iter : PeekableIter<T>) : Bool
```


## Function `isNext`
``` motoko no-repl
func isNext<T>(iter : PeekableIter<T>, val : T, isEq : (T, T) -> Bool) : Bool
```


## Function `skipWhile`
``` motoko no-repl
func skipWhile<A>(iter : PeekableIter<A>, pred : (A) -> Bool)
```

Skips elements continuously while the predicate is true.

### Example
```motoko

    let iter = [1, 2, 3, 4, 5].vals();
    let lessThan3 = func (a: Int) : Bool { a < 3 };

    Itertools.skipWhile(iter, lessThan3);

    assert Iter.toArray(iter) == [3, 4, 5];

```

## Function `takeWhile`
``` motoko no-repl
func takeWhile<A>(iter : PeekableIter<A>, predicate : A -> Bool) : PeekableIter<A>
```

Creates an iterator that returns elements from the given iter while the predicate is true.

### Example
```motoko

    let vals = Iter.fromArray([1, 2, 3, 4, 5]);

    let lessThan3 = func (x: Int) : Bool { x < 3 };
    let it = Itertools.takeWhile(vals, lessThan3);

    assert it.next() == ?1;
    assert it.next() == ?2;
    assert it.next() == null;
```
