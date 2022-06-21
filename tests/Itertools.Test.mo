import Debug "mo:base/Debug";
import Deque "mo:base/Deque";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";

import ActorSpec "./utils/ActorSpec";

import DoubleEndedIter "../src/Deiter";
import Itertools "../src/Iter";
import PeekableIter "../src/PeekableIter";

let {
    assertTrue; assertFalse; assertAllTrue; describe; it; skip; pending; run
} = ActorSpec;

let success = run([
    describe("Iter", [
        it("sum", do{
            let vals = [1, 2, 3, 4].vals();
            let sum = Itertools.sum(vals);
    
            assertTrue(sum == 10)
        }),
        it("product", do{
            let vals = [1, 2, 3, 4].vals();
            let product = Itertools.product(vals);
    
            assertTrue(product == 24)
        }),
        describe("accumulate", [
            it("sum", do{
                let vals = [1, 2, 3, 4].vals();
                let it = Itertools.accumulate<Nat>(vals, func(a, b) { 
                    a + b 
                });
        
                assertAllTrue([
                    it.next() == ?1,
                    it.next() == ?3,
                    it.next() == ?6,
                    it.next() == ?10,
                    it.next() == null
                ])
            }),
            it("product", do{
                let vals = [1, 2, 3, 4].vals();
                let it = Itertools.accumulate<Int>(
                    vals, 
                    func(a, b) { a * b }
                );
        
                assertAllTrue([
                    it.next() == ?1,
                    it.next() == ?2,
                    it.next() == ?6,
                    it.next() == ?24,
                    it.next() == null
                ])
            }),
            it("complex record type", do{
                type Point = { x: Int; y: Int };

                let points = [
                    { x = 1; y = 2 }, 
                    { x = 3; y = 4 }
                ].vals();
                
                let it = Itertools.accumulate<Point>(
                    points, 
                    func(a, b) { 
                        return { 
                            x = a.x + b.x; 
                            y = a.y + b.y 
                        };
                    }
                );

                assertAllTrue([
                    it.next() == ?{ x = 1; y = 2 },
                    it.next() == ?{ x = 4; y = 6 },
                    it.next() == null
                ])
            })
        ]),
        it("all", do{
    
            let a = [1, 2, 3, 4].vals();
            let b = [2, 4, 6, 8].vals();
    
            let isEven = func(a: Int): Bool { a % 2 == 0 };
    
            assertAllTrue([
                Itertools.all(a, isEven) == false,
                Itertools.all(b, isEven) == true
            ])
        }),
        it("any", do{
            let a = [1, 2, 3, 4].vals();
            let b = [1, 3, 5, 7].vals();
    
            let isEven = func(a: Nat) : Bool { a % 2 == 0 };
    
            assertAllTrue([
                Itertools.any(a, isEven) == true,
                Itertools.any(b, isEven) == false
            ])
        }),
        it("chain", do{
            let iter1 = [1, 2].vals();
            let iter2 = [3, 4].vals();
            let chained = Itertools.chain(iter1, iter2);

            assertAllTrue([
                chained.next() == ?1,
                chained.next() == ?2,
                chained.next() == ?3,
                chained.next() == ?4,
                chained.next() == null
            ])
        }),
        it("chunks", do{
            let vals = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].vals();
            let it = Itertools.chunks<Nat>(vals, 3);
    
            assertAllTrue([
                it.next() == ?[1, 2, 3],
                it.next() == ?[4, 5, 6],
                it.next() == ?[7, 8, 9],
                it.next() == ?[10],
                it.next() == null
            ])
        }),
        it("chunksExact", do{
            let vals = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].vals();
            let it = Itertools.chunksExact(vals, 3);
    
            assertAllTrue([
                it.next() == ?[1, 2, 3],
                it.next() == ?[4, 5, 6],
                it.next() == ?[7, 8, 9],
                it.next() == null
            ])
        }),
        it("cycle", do{
            let chars = "abc".chars();
            let it = Itertools.cycle(chars);
    
            assertAllTrue([
                it.next() == ?'a',
                it.next() == ?'b',
                it.next() == ?'c',

                it.next() == ?'a',
                it.next() == ?'b',
                it.next() == ?'c',

                it.next() == ?'a',
            ])
        }),
        it("enumerate", do{
             let chars = "abc".chars();
             let iter = Itertools.enumerate(chars);

            assertAllTrue([
                iter.next() == ?(0, 'a'),
                iter.next() == ?(1, 'b'),
                iter.next() == ?(2, 'c'),
                iter.next() == null
            ])
        }),
        it("filterMap", do{
            let vals = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].vals();

            let isEven = func( x : Nat ) : Bool { x % 2 == 0};
            let square = func( x : Nat ) : Nat {x * x};
            let it = Itertools.filterMap(vals, isEven, square);
    
            assertAllTrue([
                it.next() == ?4,
                it.next() == ?16,
                it.next() == ?36,
                it.next() == ?64,
                it.next() == ?100,
                it.next() == null
            ])
        }),
        it("find", do{
            let vals = [1, 2, 3, 4, 5].vals();

            let isEven = func( x : Int ) : Bool {x % 2 == 0};
            let res = Itertools.find(vals, isEven);

            assertTrue(res == ?2)
        }),
        it("findIndex", do{
            let vals = [1, 2, 3, 4, 5].vals();

            let isEven = func( x : Int ) : Bool {x % 2 == 0};
            let res = Itertools.findIndex(vals, isEven);

            assertTrue(res == ?1)
        }),
        describe("max", [
            it("find max", do{
                let vals = [1, 2, 3, 4, 5].vals();
                let max = Itertools.max<Nat>(vals, Nat.compare);
        
                assertTrue(max == ?5)
            }),
            it("empty iter return null", do{
                let vals = [].vals();
                let max = Itertools.max(vals, Nat.compare);
        
                assertTrue(max == null)
            }),
        ]),
        describe("min", [
            it("find min", do{
                let vals = [8, 4, 6, 9].vals();
                let min = Itertools.min(vals, Nat.compare);

                assertTrue(min == ?4)
            }),
            it("empty iter return null", do{
                let vals = [].vals();
                let res = Itertools.min(vals, Nat.compare);
        
                assertTrue(res == null)
            }),
        ]),
        describe("minmax", [
            it("find min and max", do{
                let vals = [8, 4, 6, 9].vals();
                let minmax = Itertools.minmax(vals, Nat.compare);
        
                assertTrue(minmax == ?(4, 9))
            }),
            it("empty iter return null", do{
                let vals = [].vals();
                let minmax = Itertools.minmax(vals, Nat.compare);
        
                assertTrue(minmax == null)
            }),
            it("minmax for iter with one element", do{
                let vals = [8].vals();
                let minmax = Itertools.minmax(vals, Nat.compare);
        
                assertTrue(minmax == ?(8, 8))
            }),
        ]),
        it("nth", do{
            let vals = [0, 1, 2, 3, 4, 5].vals();
            let nth = Itertools.nth(vals, 3);

            assertTrue(nth == ?3)
        }),
        it("nthOr (-1)", do{
             let vals = [0, 1, 2, 3, 4, 5].vals();

            assertAllTrue([
                Itertools.nthOr(vals, 3, -1) == 3,
                Itertools.nthOr(vals, 3, -1) == -1
            ])
        }),
        it("peekable", do{
            let vals = [1, 2].vals();
            let peekIter = Itertools.peekable(vals);

            assertAllTrue([
                peekIter.peek() == ?1,
                peekIter.next() == ?1,
    
                peekIter.peek() == ?2,
                peekIter.peek() == ?2,
                peekIter.next() == ?2,
    
                peekIter.peek() == null,
                peekIter.next() == null,
            ])
        }),
        it("range", do {
            let iter = DoubleEndedIter.range(0, 5);

            assertAllTrue([
                iter.next() == ?0,
                iter.next() == ?1,
                iter.next() == ?2,
                iter.next() == ?3,
                iter.next() == ?4,
                iter.next() == null
            ])
        }),
        it("intRange", do{
            let iter = DoubleEndedIter.intRange(0, 5);

            assertAllTrue([
                iter.next() == ?0,
                iter.next() == ?1,
                iter.next() == ?2,
                iter.next() == ?3,
                iter.next() == ?4,
                iter.next() == null
            ])
        }),
        it("ref(erence)", do{
            let iter = Iter.fromArray([1, 2, 3]);
            let refIter = Itertools.ref(iter);

            assertAllTrue([
                iter.next() == ?1,
                refIter.next() == ?2,
                iter.next() == ?3,
                refIter.next() == null
            ])
        }),
        it("repeat", do{
            let iter = Itertools.repeat(1, 3);

            assertAllTrue([
                iter.next() == ?1,
                iter.next() == ?1,
                iter.next() == ?1,
                iter.next() == null
            ])
        }),
    ])
]);

if(success == false){
  Debug.trap("\1b[48;2;31mTests failed\1b[0m");
}else{
    Debug.print("\1b[23;42;3m Success!\1b[0m");
}