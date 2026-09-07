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
