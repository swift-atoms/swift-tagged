extension Tagged: Swift.ExpressibleByArrayLiteral
where Tag: ~Copyable & ~Escapable, Underlying: Swift.ExpressibleByArrayLiteral {

    @_disfavoredOverload
    public init(arrayLiteral elements: Underlying.ArrayLiteralElement...) {
        let f = unsafe unsafeBitCast(
            Underlying.init(arrayLiteral:) as (Underlying.ArrayLiteralElement...) -> Underlying,
            to: (([Underlying.ArrayLiteralElement]) -> Underlying).self
        )
        self.init(_unchecked: f(elements))
    }
}
