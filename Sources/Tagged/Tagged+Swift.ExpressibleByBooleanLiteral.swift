extension Tagged: Swift.ExpressibleByBooleanLiteral
where Tag: ~Copyable & ~Escapable, Underlying: Swift.ExpressibleByBooleanLiteral {

    @_disfavoredOverload
    public init(booleanLiteral value: Underlying.BooleanLiteralType) {
        self.init(_unchecked: Underlying(booleanLiteral: value))
    }
}
