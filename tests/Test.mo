import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";

import ActorSpec "./utils/ActorSpec";
import DoubleEndedIter "../src/DeIter";

let {
    assertTrue; assertFalse; assertAllTrue; describe; it; skip; pending; run
} = ActorSpec;

let success = run([
    describe("DoubleEndedIter", [
        it("fromArray", do {
            let arr = [1, 2, 3, 4, 5];
            let deiter = DoubleEndedIter.fromArray<Nat>(arr);

            assertAllTrue([
                deiter.next() == ?1,
                deiter.next() == ?2,
                deiter.next_back() == ?5,
                deiter.next_back() == ?4,
                deiter.next() == ?3,
                deiter.next_back() == null,
                deiter.next() == null
            ])
        }),
    ])
]);

if(success == false){
  Debug.trap("Tests failed");
}else{
    Debug.print("\1b[23;45;64m Success!");
}