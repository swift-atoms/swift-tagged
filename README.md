# swift-tagged

Use this package when two values share a representation but must not be mixed up, such as a customer identifier and an order identifier that are both strings: wrap the value in `Tagged<Tag, Underlying>`, where `Tag` is a phantom type that names the domain. Start from `Tagged`. To write code that works over any wrapper with a domain and an underlying value, not only `Tagged`, depend on the sibling swift-carrier and constrain to `Carrier.Protocol` instead; `Tagged` conforms to it.

## Laws

- The tag exists only in the type. A `Tagged` value has the same memory layout as its `Underlying`, encodes and decodes as the bare underlying value, and its `description` and `id` are the underlying ones, so two values with different tags but the same underlying value print and identify alike. When decoding, the receiving type alone decides the domain.
- `init(_unchecked:)` and the `Carrier.Protocol` initializer attach the tag without checking anything. Any invariant must be enforced by `Underlying` before tagging; a failing underlying initializer means no `Tagged` value is made.
- Equality, hashing and ordering are those of `Underlying`, so sorting follows the underlying order and sets deduplicate by underlying value. On a tie, `Tagged.max` and `Tagged.min` return their first argument.
- `map` keeps the tag and is a functor: mapping the identity returns an equal value, and mapping `g` then `f` equals mapping `f(g(x))`. A throwing transform's error propagates and no value is produced.
- `retag` keeps the underlying value unchanged: retagging there and back returns an equal value, retagging through several tags equals retagging directly, and `map` and `retag` commute.
- Nesting does not flatten: a `Tagged` whose underlying value is another `Tagged` reports the inner `Tagged` as its `Underlying` and its own tag as its `Domain`. Each layer is unwrapped explicitly.
- Literal and string-interpolation initializers build the underlying value from the literal and tag it, giving the same value as `init(_unchecked:)`.
