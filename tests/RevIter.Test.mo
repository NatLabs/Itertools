import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import Deque "mo:base/Deque";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";

import ActorSpec "./utils/ActorSpec";

import RevIter "../src/RevIter";
import Itertools "../src/Iter";

import DequeUtils "../src/Utils/Deque";

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
        "Reversible Iterator",
        [
            it(
                "fromArray",
                do {
                    let arr = [1, 2, 3, 4, 5];
                    let iter = RevIter.fromArray<Nat>(arr);

                    assertAllTrue([
                        iter.next() == ?1,
                        iter.next() == ?2,
                        iter.nextFromEnd() == ?5,
                        iter.nextFromEnd() == ?4,
                        iter.next() == ?3,
                        iter.nextFromEnd() == null,
                        iter.next() == null,
                    ]);
                },
            ),
            it(
                "fromVarArray",
                do {
                    let arr = [var 1, 2, 3, 4, 5];
                    let iter = RevIter.fromVarArray<Nat>(arr);

                    assertAllTrue([
                        iter.next() == ?1,
                        iter.next() == ?2,
                        iter.nextFromEnd() == ?5,
                        iter.nextFromEnd() == ?4,
                        iter.next() == ?3,
                        iter.nextFromEnd() == null,
                        iter.next() == null,
                    ]);
                },
            ),
            it(
                "fromBuffer",
                do {
                    let buffer = Buffer.fromArray<Nat>([1, 2, 3, 4, 5]);
                    let iter = RevIter.fromBuffer<Nat>(buffer);

                    assertAllTrue([
                        iter.next() == ?1,
                        iter.next() == ?2,
                        iter.nextFromEnd() == ?5,
                        iter.nextFromEnd() == ?4,
                        iter.next() == ?3,
                        iter.nextFromEnd() == null,
                        iter.next() == null,
                    ]);
                },
            ),
            it(
                "fromDeque",
                do {
                    let deque = DequeUtils.fromArray([1, 2, 3, 4, 5]);
                    let iter = RevIter.fromDeque<Nat>(deque);

                    Debug.print("deque: " # debug_show Iter.toArray(RevIter.fromDeque<Nat>(deque)));

                    assertAllTrue([
                        iter.next() == ?1,
                        iter.next() == ?2,
                        iter.nextFromEnd() == ?5,
                        iter.nextFromEnd() == ?4,
                        iter.next() == ?3,
                        iter.nextFromEnd() == null,
                        iter.next() == null,
                    ]);
                },
            ),
            it(
                "reverse",
                do {
                    let deque = DequeUtils.fromArray([1, 2, 3, 4, 5]);
                    let rev_iter = RevIter.fromDeque<Nat>(deque).rev();
        
                    assertAllTrue([
                        rev_iter.next() == ?5,
                        rev_iter.next() == ?4,
                        rev_iter.nextFromEnd() == ?1,
                        rev_iter.nextFromEnd() == ?2,
                        rev_iter.next() == ?3,
                        rev_iter.nextFromEnd() == null,
                        rev_iter.next() == null,
                    ]);
                },
            ),
            it(
                "reverse chunks",
                do {
                    let arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

                    let rev_iter = RevIter.fromArray(arr).rev();
                    let chunks = Itertools.chunks(rev_iter, 3);

                    assertAllTrue([
                        chunks.next() == ?[10, 9, 8],
                        chunks.next() == ?[7, 6, 5],
                        chunks.next() == ?[4, 3, 2],
                        chunks.next() == ?[1],
                        chunks.next() == null,
                    ])

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
