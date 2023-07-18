# Deiter
Double Ended Iterator

This type of iterator allows for both forward and backward iteration
Double Ended Iterators are useful for iterating over data structures in reverse without allocating extra space for the reverse iteration.

The `Deiter` type is an extension of the `Iter` type built in Motoko
so it is compatible with all the function defined for the `Iter` type.


The `Deiter` is intended to be used with functions for the `Iter` type to avoid rewriting similar functions for both types.

- An example reversing a list of integers and breaking them into chunks of size `n`:

```motoko

  import Itertools "mo:itertools/Iter";
  import Deiter "mo:itertools/Deiter";

  let arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  // create a double ended iterator from an array
  let deiter = Deiter.fromArray(arr);

  // reverse double ended iterator
  let revDeiter = Deiter.reverse(deiter);

  // Double Ended Iter gets typecasted to an Iter typw
  let chunks = Itertools.chunks(revDeiter, 3);

  assert chunks.next() == ?[10, 9, 8];
  assert chunks.next() == ?[7, 6, 5];
  assert chunks.next() == ?[4, 3, 2];
  assert chunks.next() == ?[1];
  assert chunks.next() == null;

```

## Type `Deiter`
``` motoko no-repl
type Deiter<T> = Iter.Iter<T> and { next_back : () -> ?T }
```

Double Ended Iterator Type

## Function `range`
``` motoko no-repl
func range(start : Nat, end : Nat) : Deiter<Nat>
```

Returns a Double Ended Iterator over a range of natural, `Nat` numbers from [start, end)

## Function `intRange`
``` motoko no-repl
func intRange(start : Int, end : Int) : Deiter<Int>
```

Returns a Double Ended Iterator over a range of integers (`Int`) from [start, end)

## Function `rev`
``` motoko no-repl
func rev<T>(deiter : Deiter<T>) : Deiter<T>
```

@deprecated in favor of `reverse`

## Function `reverse`
``` motoko no-repl
func reverse<T>(deiter : Deiter<T>) : Deiter<T>
```

Returns an iterator that iterates over the elements in reverse order.
#### Example

```motoko

  let arr = [1, 2, 3];
  let deiter = Deiter.fromArray(arr);

  assert deiter.next() == ?1;
  assert deiter.next() == ?2;
  assert deiter.next() == ?3;
  assert deiter.next() == null;

  let deiter2 = Deiter.fromArray(arr);
  let revIter = Deiter.reverse(deiter2);

  assert revIter.next() == ?3;
  assert revIter.next() == ?2;
  assert revIter.next() == ?1;
  assert revIter.next() == null;

```

## Function `fromArray`
``` motoko no-repl
func fromArray<T>(array : [T]) : Deiter<T>
```

Creates an iterator for the elements of an array.

#### Example

```motoko

  let arr = [1, 2, 3];
  let deiter = Deiter.fromArray(arr);

  assert deiter.next() == ?1;
  assert deiter.next_back() == ?3;
  assert deiter.next_back() == ?2;
  assert deiter.next_back() == null;
  assert deiter.next() == null;

```

## Function `toArray`
``` motoko no-repl
func toArray<T>(deiter : Deiter<T>) : [T]
```


## Function `fromArrayMut`
``` motoko no-repl
func fromArrayMut<T>(array : [var T]) : Deiter<T>
```


## Function `toArrayMut`
``` motoko no-repl
func toArrayMut<T>(deiter : Deiter<T>) : [var T]
```


## Function `toIter`
``` motoko no-repl
func toIter<T>(iter : Iter.Iter<T>) : Iter.Iter<T>
```

Type Conversion from Deiter to Iter

## Function `fromBuffer`
``` motoko no-repl
func fromBuffer<T>(buffer : GenericBuffer<T>) : Deiter<T>
```


## Function `fromDeque`
``` motoko no-repl
func fromDeque<T>(deque : Deque.Deque<T>) : Deiter<T>
```

Returns an iterator for a deque.

## Function `toDeque`
``` motoko no-repl
func toDeque<T>(deiter : Deiter<T>) : Deque.Deque<T>
```

Converts an iterator to a deque.
