extension Tagged: Swift.ExpressibleByDictionaryLiteral
where Tag: ~Copyable & ~Escapable, Underlying: Swift.ExpressibleByDictionaryLiteral {

    @_disfavoredOverload
    public init(dictionaryLiteral elements: (Underlying.Key, Underlying.Value)...) {
        let f = unsafe unsafeBitCast(
            Underlying.init(dictionaryLiteral:)
                as ((Underlying.Key, Underlying.Value)...) -> Underlying,
            to: (([(Underlying.Key, Underlying.Value)]) -> Underlying).self
        )
        self.init(_unchecked: f(elements))
    }
}
