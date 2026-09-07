extension Tagged: Swift.ExpressibleByFloatLiteral
where Tag: ~Copyable & ~Escapable, Underlying: Swift.ExpressibleByFloatLiteral {

    @_disfavoredOverload
    public init(floatLiteral value: Underlying.FloatLiteralType) {
        self.init(_unchecked: Underlying(floatLiteral: value))
    }
}
