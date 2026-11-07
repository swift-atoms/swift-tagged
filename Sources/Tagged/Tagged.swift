@frozen
public struct Tagged<Tag: ~Copyable & ~Escapable, Underlying: ~Copyable & ~Escapable>: ~Copyable,
    ~Escapable
{

    public package(set) var underlying: Underlying

    @_lifetime(copy underlying)
    public init(_unchecked underlying: consuming Underlying) {
        self.underlying = underlying
    }
}

extension Tagged where Tag: ~Copyable & ~Escapable, Underlying: ~Copyable & ~Escapable {
    package mutating func modify<T>(_ body: (_ underlying: inout Underlying) -> T) -> T {
        body(&self.underlying)
    }
}

extension Tagged: Swift.Copyable where Tag: ~Swift.Copyable & ~Escapable, Underlying: Swift.Copyable & ~Escapable {}

extension Tagged: Swift.Escapable where Tag: ~Copyable & ~Swift.Escapable, Underlying: Swift.Escapable & ~Copyable {}

extension Tagged: Swift.Sendable
where Tag: ~Copyable & ~Escapable, Underlying: ~Copyable & Swift.Sendable & Escapable {}

extension Tagged: Swift.Equatable
where Tag: ~Copyable & ~Escapable, Underlying: Swift.Equatable & ~Copyable & Escapable {}

extension Tagged: Swift.Hashable
where Tag: ~Copyable & ~Escapable, Underlying: Swift.Hashable & ~Copyable & Escapable {}

extension Tagged where Tag: ~Copyable & ~Escapable, Underlying: ~Copyable {

    @inlinable
    public static func map<E: Swift.Error, NewUnderlying: ~Copyable>(
        _ tagged: consuming Tagged,
        transform: (consuming Underlying) throws(E) -> NewUnderlying
    ) throws(E) -> Tagged<Tag, NewUnderlying> {
        Tagged<Tag, NewUnderlying>(_unchecked: try transform(tagged.underlying))
    }

    @inlinable
    public static func retag<New: ~Copyable & ~Escapable>(
        _ tagged: consuming Tagged,
        to _: New.Type = New.self
    ) -> Tagged<New, Underlying> {
        Tagged<New, Underlying>(_unchecked: tagged.underlying)
    }
}

extension Tagged where Tag: ~Copyable & ~Escapable, Underlying: ~Copyable {

    @inlinable
    public consuming func map<E: Swift.Error, NewUnderlying: ~Copyable>(
        _ transform: (consuming Underlying) throws(E) -> NewUnderlying
    ) throws(E) -> Tagged<Tag, NewUnderlying> {
        try Self.map(self, transform: transform)
    }

    @inlinable
    public consuming func retag<New: ~Copyable & ~Escapable>(
        _: New.Type = New.self
    ) -> Tagged<New, Underlying> {
        Self.retag(self, to: New.self)
    }
}

extension Tagged: Identifiable
where Tag: ~Copyable & ~Escapable, Underlying: Identifiable & Escapable {

    @inlinable
    public var id: Underlying.ID { underlying.id }
}

extension Tagged: ExpressibleByStringInterpolation
where Tag: ~Copyable & ~Escapable, Underlying: ExpressibleByStringInterpolation {

    @_disfavoredOverload
    public init(stringInterpolation: Underlying.StringInterpolation) {
        self.init(_unchecked: Underlying(stringInterpolation: stringInterpolation))
    }
}

extension Tagged: Swift.BitwiseCopyable
where Tag: ~Copyable & ~Escapable, Underlying: Swift.BitwiseCopyable & Escapable {}

#if !hasFeature(Embedded)
    extension Tagged: Swift.Codable
    where Tag: ~Copyable & ~Escapable, Underlying: Swift.Codable & Escapable {

        @inlinable
        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.init(_unchecked: try container.decode(Underlying.self))
        }

        @inlinable
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self.underlying)
        }
    }
#endif

extension Tagged: Swift.Collection
where Tag: ~Copyable & ~Escapable, Underlying: Swift.Collection & Escapable {

    public typealias Index = Underlying.Index

    public typealias Element = Underlying.Element

    @inlinable
    public var startIndex: Underlying.Index { underlying.startIndex }

    @inlinable
    public var endIndex: Underlying.Index { underlying.endIndex }

    @inlinable
    public subscript(position: Underlying.Index) -> Underlying.Element {
        underlying[position]
    }

    @inlinable
    public func index(after i: Underlying.Index) -> Underlying.Index {
        underlying.index(after: i)
    }
}

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

extension Tagged: Swift.CustomStringConvertible
where Tag: ~Copyable & ~Escapable, Underlying: Swift.CustomStringConvertible & Escapable {

    @inlinable
    public var description: String { underlying.description }
}

extension Tagged: Swift.ExpressibleByArrayLiteral
where Tag: ~Copyable & ~Escapable, Underlying: Swift.ExpressibleByArrayLiteral {

    @_disfavoredOverload
    public init(arrayLiteral elements: Underlying.ArrayLiteralElement...) {
        let f = unsafe unsafeBitCast(
            Underlying.init(arrayLiteral:) as (Underlying.ArrayLiteralElement...) -> Underlying,
            to: (([Underlying.ArrayLiteralElement]) -> Underlying).self
        )
        self.init(_unchecked: f(elements))
    }
}

extension Tagged: Swift.ExpressibleByBooleanLiteral
where Tag: ~Copyable & ~Escapable, Underlying: Swift.ExpressibleByBooleanLiteral {

    @_disfavoredOverload
    public init(booleanLiteral value: Underlying.BooleanLiteralType) {
        self.init(_unchecked: Underlying(booleanLiteral: value))
    }
}

extension Tagged: Swift.ExpressibleByDictionaryLiteral
where Tag: ~Copyable & ~Escapable, Underlying: Swift.ExpressibleByDictionaryLiteral {

    @_disfavoredOverload
    public init(dictionaryLiteral elements: (Underlying.Key, Underlying.Value)...) {
        let f = unsafe unsafeBitCast(
            Underlying.init(dictionaryLiteral:)
                as ((Underlying.Key, Underlying.Value)...) -> Underlying,
            to: (([(Underlying.Key, Underlying.Value)]) -> Underlying).self
        )
        self.init(_unchecked: f(elements))
    }
}

extension Tagged: Swift.ExpressibleByExtendedGraphemeClusterLiteral
where Tag: ~Copyable & ~Escapable, Underlying: Swift.ExpressibleByExtendedGraphemeClusterLiteral {

    @_disfavoredOverload
    public init(extendedGraphemeClusterLiteral value: Underlying.ExtendedGraphemeClusterLiteralType) {
        self.init(_unchecked: Underlying(extendedGraphemeClusterLiteral: value))
    }
}

extension Tagged: Swift.ExpressibleByFloatLiteral
where Tag: ~Copyable & ~Escapable, Underlying: Swift.ExpressibleByFloatLiteral {

    @_disfavoredOverload
    public init(floatLiteral value: Underlying.FloatLiteralType) {
        self.init(_unchecked: Underlying(floatLiteral: value))
    }
}

extension Tagged: Swift.ExpressibleByIntegerLiteral
where Tag: ~Copyable & ~Escapable, Underlying: Swift.ExpressibleByIntegerLiteral {

    @_disfavoredOverload
    public init(integerLiteral value: Underlying.IntegerLiteralType) {
        self = .init(_unchecked: Underlying(integerLiteral: value))
    }
}

extension Tagged: Swift.ExpressibleByStringLiteral
where Tag: ~Copyable & ~Escapable, Underlying: Swift.ExpressibleByStringLiteral {

    @_disfavoredOverload
    public init(stringLiteral value: Underlying.StringLiteralType) {
        self.init(_unchecked: Underlying(stringLiteral: value))
    }
}

extension Tagged: Swift.ExpressibleByUnicodeScalarLiteral
where Tag: ~Copyable & ~Escapable, Underlying: Swift.ExpressibleByUnicodeScalarLiteral {

    @_disfavoredOverload
    public init(unicodeScalarLiteral value: Underlying.UnicodeScalarLiteralType) {
        self.init(_unchecked: Underlying(unicodeScalarLiteral: value))
    }
}

extension Tagged: Swift.Sequence
where Tag: ~Copyable & ~Escapable, Underlying: Swift.Sequence & Escapable {

    @inlinable
    public func makeIterator() -> Underlying.Iterator {
        underlying.makeIterator()
    }
}
