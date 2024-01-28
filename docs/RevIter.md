# RevIter
Reversible Iterator

This type of iterator allows for both forward and backward iteration
Reversible Iterators are useful for iterating over data structures in reverse without allocating extra space for the reverse iteration.

The `RevIter` type is an extension of the `Iter` type built in Motoko
so it is compatible with all the function defined for the `Iter` type.


The `RevIter` is intended to be used with functions for the `Iter` type to avoid rewriting similar functions for both types.

- An example reversing a list of integers and breaking them into chunks of size `n`:

```motoko

  import Itertools "mo:itertools/Iter";
  import RevIter "mo:itertools/RevIter";

  let arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  // create a Reversible Iterator from an array
  let iter = RevIter.fromArray(arr);

  // reverse iterator
  let rev_iter = iter.rev();

  // Reversible Iterator gets typecasted to an Iter type
  let chunks = Itertools.chunks(revRevIter, 3);

  assert chunks.next() == ?[10, 9, 8];
  assert chunks.next() == ?[7, 6, 5];
  assert chunks.next() == ?[4, 3, 2];
  assert chunks.next() == ?[1];
  assert chunks.next() == null;

```

## Type `RevIter`
``` motoko no-repl
type RevIter<T> = Iter.Iter<T> and { nextFromEnd : () -> ?T }
```

Reversible Iterator Type

## Function `range`
``` motoko no-repl
func range(start : Nat, end : Nat) : RevIter<Nat>
```

Returns a Reversible Iterator over a range of natural, `Nat` numbers from [start, end)

## Function `intRange`
``` motoko no-repl
func intRange(start : Int, end : Int) : RevIter<Int>
```

Returns a Reversible Iterator over a range of integers (`Int`) from [start, end)

## Function `rev`
``` motoko no-repl
func rev<T>(RevIter : RevIter<T>) : RevIter<T>
```

@deprecated in favor of `reverse`

## Function `reverse`
``` motoko no-repl
func reverse<T>(RevIter : RevIter<T>) : RevIter<T>
```

Returns an iterator that iterates over the elements in reverse order.
#### Example

```motoko

  let arr = [1, 2, 3];
  let iter = RevIter.fromArray(arr);

  assert iter.next() == ?1;
  assert iter.next() == ?2;
  assert iter.next() == ?3;
  assert iter.next() == null;

  let rev_iter = RevIter.fromArray(arr).rev();

  assert rev_iter.next() == ?3;
  assert rev_iter.next() == ?2;
  assert rev_iter.next() == ?1;
  assert rev_iter.next() == null;

```

## Function `fromArray`
``` motoko no-repl
func fromArray<T>(array : [T]) : RevIter<T>
```

Creates an iterator for the elements of an array.

#### Example

```motoko

  let arr = [1, 2, 3];
  let iter = RevIter.fromArray(arr);

  assert rev_iter.next() == ?1;
  assert rev_iter.nextFromEnd() == ?3;
  assert rev_iter.nextFromEnd() == ?2;
  assert rev_iter.nextFromEnd() == null;
  assert rev_iter.next() == null;

```

## Function `toArray`
``` motoko no-repl
func toArray<T>(RevIter : RevIter<T>) : [T]
```


## Function `fromVarArray`
``` motoko no-repl
func fromVarArray<T>(array : [var T]) : RevIter<T>
```


## Function `toVarArray`
``` motoko no-repl
func toVarArray<T>(RevIter : RevIter<T>) : [var T]
```


## Function `toIter`
``` motoko no-repl
func toIter<T>(iter : Iter.Iter<T>) : Iter.Iter<T>
```

Type Conversion from RevIter to Iter

## Function `fromBuffer`
``` motoko no-repl
func fromBuffer<T>(buffer : GenericBuffer<T>) : RevIter<T>
```


## Function `fromDeque`
``` motoko no-repl
func fromDeque<T>(deque : Deque.Deque<T>) : RevIter<T>
```

Returns an iterator for a deque.

## Function `toDeque`
``` motoko no-repl
func toDeque<T>(RevIter : RevIter<T>) : Deque.Deque<T>
```

Converts an iterator to a deque.
