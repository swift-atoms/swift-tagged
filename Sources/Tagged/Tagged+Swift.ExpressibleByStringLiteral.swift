extension Tagged: Swift.ExpressibleByStringLiteral
where Tag: ~Copyable & ~Escapable, Underlying: Swift.ExpressibleByStringLiteral {

    @_disfavoredOverload
    public init(stringLiteral value: Underlying.StringLiteralType) {
        self.init(_unchecked: Underlying(stringLiteral: value))
    }
}
