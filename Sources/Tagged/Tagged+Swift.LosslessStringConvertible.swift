extension Tagged: Swift.LosslessStringConvertible
where
    Tag: ~Copyable & ~Escapable,
    Underlying: Swift.LosslessStringConvertible & Escapable
{

    @inlinable
    public init?(_ description: String) {
        guard let raw = Underlying(description) else { return nil }
        self.init(_unchecked: raw)
    }

}
