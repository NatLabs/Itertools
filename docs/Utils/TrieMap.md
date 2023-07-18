# Utils/TrieMap

## Function `containsKey`
``` motoko no-repl
func containsKey<A, B>(map : TrieMap.TrieMap<A, B>, key : A) : Bool
```


## Function `putOrUpdate`
``` motoko no-repl
func putOrUpdate<A, B>(map : TrieMap.TrieMap<A, B>, key : A, defaultVal : B, update : (B) -> B)
```

