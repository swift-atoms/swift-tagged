extension Tagged: ExpressibleByStringInterpolation
where Tag: ~Copyable & ~Escapable, Underlying: ExpressibleByStringInterpolation {

    @_disfavoredOverload
    public init(stringInterpolation: Underlying.StringInterpolation) {
        self.init(_unchecked: Underlying(stringInterpolation: stringInterpolation))
    }
}
