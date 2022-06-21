import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Int "mo:base/Int";
import List "mo:base/List";
import Deque "mo:base/Deque";

/// Double Ended Iterator Implementation
/// Allows for both forward and backward iteration
/// Usefull for iterating over an array in reverse without allocating a new array
module {

  /// Double Ended Iterator Type
  public type Deiter<T> = {
    next: () -> ?T;
    next_back : () -> ?T;
  };
  
  /// 
  public func range(start: Nat, end: Nat): Deiter<Nat> {
    let intIter = intRange(start, end);
    
    func optIntToNat(optInt: ?Int) : ?Nat {
       switch(optInt) {
          case (null) null;
          case (?val) ?Int.abs(val);
        }
    };

    return object {
      public func next(): ?Nat {
        optIntToNat(intIter.next())
      };
      public func next_back(): ?Nat {
        optIntToNat(intIter.next_back())
      };
    };
  };

  public func intRange(start: Int, end: Int): Deiter<Int> {
    var i = start;
    var j = end;

    return object {
      public func next(): ?Int {
        if (i < end and i < j) {
          let tmp = i;
          i += 1;
          return ?tmp;
        } else {
          return null;
        }
      };
      public func next_back(): ?Int {
        if (j > start and j > i) {
          j -= 1;
          return ?j;
        } else {
          return null;
        }
      };
    };
  };

  /// Returns an iterator that iterates over the elements in reverse order.
  /// #### Examples 
  public func rev<T>(deiter : Deiter<T>) : Deiter<T> {
    return object{
      public func next(): ?T {
        deiter.next_back()
      };
      public func next_back(): ?T {
        deiter.next()
      }
    };
  };

  public func fromArray<T>(array: [T]): Deiter<T> {
    var left  =0;
    var right = array.size();

    return  {
      next = func(): ?T {
        if (left < right) {
          left += 1;
          ?array[left - 1]
        } else {
          null
        }
      };
      next_back = func(): ?T {
        if (left < right) {
          right -= 1;
          ?array[right]
        } else {
          null
        }
      }
    };
  };

  public func toArray<T>(deiter: Deiter<T>): [T] {
    Iter.toArray(deiter)
  };

  public func fromArrayMut<T>(array: [var T]): Deiter<T>{
    fromArray<T>(Array.freeze<T>(array))
  };

  public func toArrayMut<T>(deiter: Deiter<T>): [var T] {
    Iter.toArrayMut<T>(deiter)
  };

  /// Deiter are interchangable with Iter types so there 
  /// is no need to convert them. 
  /// This function casts a Deiter to an Iter type.
  /// So you won't be able to use the next_back function after calling this function.
  /// So if you want to get the values in reverse order you need 
  /// to use the `rev` function before calling this function.

  public func toIter<T>(iter: Iter.Iter<T>): Iter.Iter<T> {
    iter
  };

  /// Returns an iterator for a deque.
  public func fromDeque<T>(deque: Deque.Deque<T>): Deiter<T> {

    var deq = deque;
    return object {
      public func next(): ?T {
        switch(Deque.popFront(deq)){
          case (?(val, next)){
            deq := next;
            ?val
          };
          case (null) null;
        }
      };

      public func next_back(): ?T {
        switch(Deque.popBack(deq)){
          case (?(prev, val)){
            deq := prev;
            ?val
          };
          case (null) null;
        }
      }
    };
  };

  /// Converts an iterator to a deque.
  public func toDeque<T>(deiter: Deiter<T>): Deque.Deque<T> {
    var deq = Deque.empty<T>();

    label l loop {
        switch(deiter.next_back()){
          case (?val){
            deq := Deque.pushFront(deq, val);
          };
          case (null) break l;
        }
    };
    deq
  };
};
