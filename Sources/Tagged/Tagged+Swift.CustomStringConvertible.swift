extension Tagged: Swift.CustomStringConvertible
where Tag: ~Copyable & ~Escapable, Underlying: Swift.CustomStringConvertible & Escapable {

    @inlinable
    public var description: String { underlying.description }
}
