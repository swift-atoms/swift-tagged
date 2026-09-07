extension Tagged: Swift.ExpressibleByIntegerLiteral
where Tag: ~Copyable & ~Escapable, Underlying: Swift.ExpressibleByIntegerLiteral {

    @_disfavoredOverload
    public init(integerLiteral value: Underlying.IntegerLiteralType) {
        self = .init(_unchecked: Underlying(integerLiteral: value))
    }
}
