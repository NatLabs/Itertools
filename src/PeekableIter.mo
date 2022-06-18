import Iter "mo:base/Iter";

module {
    type PeekableIter<T> = {
        peek: () -> T;
        next: () -> T;
    };

    public func fromIter<T>(iter: Iter.Iter<T>): PeekableIter<T>{
        var next: ?T = iter.next();

        return object {
            public func peek() -> T {
                switch(next){
                    case(?val){
                        ?val
                    };
                    case(null){
                        null
                    };
                }
            };

            public func next() -> T {
                switch(next){
                    case(?val){
                        next  = iter.next();
                        ?val
                    };
                    case(null){
                        null
                    };
                }
            };
        };
    };
}