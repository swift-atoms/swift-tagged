import Tagged
import Testing

@testable import Tagged

private enum Tag1 {}
private enum Tag2 {}

private struct DomainKey: Identifiable, Hashable, Equatable, Sendable {
    let id: UInt64
}

@Suite
struct `Tagged identity follows the underlying identifier` {
    @Suite struct `Tagged identifiers preserve the underlying value and identifier type` {}
    @Suite struct `Different phantom tags can expose the same underlying identity` {}
    @Suite struct `Generic identity algorithms observe tagged underlying identifiers` {}
    @Suite(.serialized) struct `Repeated tagged identifier access preserves identity` {}
}

extension `Tagged identity follows the underlying identifier`.`Tagged identifiers preserve the underlying value and identifier type` {

    @Test
    func `id forwards to Underlying id`() {
        let key = DomainKey(id: 42)
        let tagged: Tagged<Tag1, DomainKey> = Tagged<Tag1, DomainKey>(_unchecked: key)
        #expect(tagged.id == 42)
    }

    @Test
    func `Tagged conforms to Identifiable when Underlying conforms`() {
        func _requireIdentifiable<T: Identifiable>(_: T.Type) {}
        _requireIdentifiable(Tagged<Tag1, DomainKey>.self)
        #expect(Bool(true))
    }

    @Test
    func `id type matches Underlying ID type`() {
        let key = DomainKey(id: 7)
        let tagged: Tagged<Tag1, DomainKey> = Tagged<Tag1, DomainKey>(_unchecked: key)
        let _: UInt64 = tagged.id
    }
}

extension `Tagged identity follows the underlying identifier`.`Different phantom tags can expose the same underlying identity` {

    @Test
    func `phantom-Tag-distinct values with same Underlying id observe identity-inversion`() {

        let key = DomainKey(id: 99)
        let a: Tagged<Tag1, DomainKey> = Tagged<Tag1, DomainKey>(_unchecked: key)
        let b: Tagged<Tag2, DomainKey> = Tagged<Tag2, DomainKey>(_unchecked: key)
        #expect(a.id == b.id)
    }
}

extension `Tagged identity follows the underlying identifier`.`Generic identity algorithms observe tagged underlying identifiers` {

    @Test
    func `generic Identifiable algorithm sees the underlying id`() {
        func describe<T: Identifiable>(_ value: T) -> String where T.ID == UInt64 {
            "id=\(value.id)"
        }
        let key = DomainKey(id: 314)
        let tagged: Tagged<Tag1, DomainKey> = Tagged<Tag1, DomainKey>(_unchecked: key)
        #expect(describe(tagged) == "id=314")
    }
}

extension `Tagged identity follows the underlying identifier`.`Repeated tagged identifier access preserves identity` {

    @Test
    func `Repeated tagged identifier access preserves the underlying identifier`() {
        var sum: UInt64 = 0
        (0..<UInt64(1_000)).forEach { i in
            let tagged: Tagged<Tag1, DomainKey> = Tagged<Tag1, DomainKey>(
                _unchecked: DomainKey(id: i)
            )
            sum &+= tagged.id
        }
        #expect(sum == (0..<1_000).reduce(0, &+))
    }
}
