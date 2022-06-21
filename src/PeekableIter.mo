import Iter "mo:base/Iter";

module {
    public type PeekableIter<T> = {
        peek: () -> ?T;
        next: () -> ?T;
    };

    public func fromIter<T>(iter: Iter.Iter<T>): PeekableIter<T>{
        var next_item = iter.next();

        return object {
            public func peek() : ?T {
                next_item
            };

            public func next() : ?T {
                switch(next_item){
                    case(?val){
                        next_item  := iter.next();
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