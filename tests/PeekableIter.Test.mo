import Debug "mo:base/Debug";
import Deque "mo:base/Deque";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";

import ActorSpec "./utils/ActorSpec";

import PeekableIter "../src/PeekableIter";

let {
    assertTrue;
    assertFalse;
    assertAllTrue;
    describe;
    it;
    skip;
    pending;
    run;
} = ActorSpec;

let success = run([
    describe(
        "PeekableIter",
        [
            it(
                "fromIter",
                do {
                    let vals = [1, 2, 3].vals();
                    let peekable = PeekableIter.fromIter<Nat>(vals);

                    assertAllTrue([
                        peekable.peek() == ?1,
                        peekable.next() == ?1,

                        peekable.peek() == ?2,
                        peekable.peek() == ?2,
                        peekable.next() == ?2,

                        peekable.peek() == ?3,
                        peekable.next() == ?3,

                        peekable.peek() == null,
                        peekable.next() == null,
                    ]);
                },
            ),
            it(
                "takeWhile",
                do {
                    let iter = PeekableIter.fromIter([1, 2, 3, 4, 5].vals());
                    let lessThan3 = func(x : Nat) : Bool { x < 3 };
                    let below_three = PeekableIter.takeWhile(iter, lessThan3);

                    let res = [

                        below_three.next() == ?1,
                        below_three.next() == ?2,
                        below_three.next() == null,

                        // after the below_three iterator is consumed, 
                        // the original iterator should be at the next value

                        iter.next() == ?3,
                        iter.next() == ?4,
                        iter.next() == ?5,
                        iter.next() == null,

                    ];

                    assertAllTrue(res);
                },
            ),
        ],
    ),
]);

if (success == false) {
    Debug.trap("\1b[46;41mTests failed\1b[0m");
} else {
    Debug.print("\1b[23;42;3m Success!\1b[0m");
};
