extension Tagged: Swift.ExpressibleByUnicodeScalarLiteral
where Tag: ~Copyable & ~Escapable, Underlying: Swift.ExpressibleByUnicodeScalarLiteral {

    @_disfavoredOverload
    public init(unicodeScalarLiteral value: Underlying.UnicodeScalarLiteralType) {
        self.init(_unchecked: Underlying(unicodeScalarLiteral: value))
    }
}
