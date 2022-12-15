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
