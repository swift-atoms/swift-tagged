extension Tagged: Swift.ExpressibleByExtendedGraphemeClusterLiteral
where Tag: ~Copyable & ~Escapable, Underlying: Swift.ExpressibleByExtendedGraphemeClusterLiteral {

    @_disfavoredOverload
    public init(extendedGraphemeClusterLiteral value: Underlying.ExtendedGraphemeClusterLiteralType)
    {
        self.init(_unchecked: Underlying(extendedGraphemeClusterLiteral: value))
    }
}
