extension Tagged: Swift.Comparable
where Tag: ~Copyable & ~Escapable, Underlying: Swift.Comparable & ~Copyable & Escapable {

    @inlinable
    public static func < (lhs: borrowing Tagged, rhs: borrowing Tagged) -> Bool {
        lhs.underlying < rhs.underlying
    }

    @inlinable
    public static func max(_ a: consuming Self, _ b: consuming Self) -> Self {
        a.underlying >= b.underlying ? a : b
    }

    @inlinable
    public static func min(_ a: consuming Self, _ b: consuming Self) -> Self {
        a.underlying <= b.underlying ? a : b
    }
}
