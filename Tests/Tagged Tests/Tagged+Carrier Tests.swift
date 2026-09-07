import Carrier
import Tagged
import Testing

@testable import Tagged

private enum Tag1 {}
private enum Tag2 {}
private enum Tag3 {}

private func describeIntCarrier<C: Carrier.`Protocol`>(_ c: C) -> Int
where C.Underlying == Int {
    c.underlying
}

private func describeAnyCarrier<C: Carrier.`Protocol`>(_ c: C) -> String {
    String(describing: C.Underlying.self)
}

@Suite
struct `Tagged carriers expose their immediate underlying type and phantom domain` {
    @Suite struct `Tagged carrier associated types preserve the immediate wrapping layer` {}
    @Suite struct `Nested tagged carriers retain each wrapping layer` {}
    @Suite struct `Generic carrier algorithms distinguish tagged wrapping layers` {}
    @Suite(.serialized) struct `Repeated carrier dispatch preserves each tagged value` {}
}

extension `Tagged carriers expose their immediate underlying type and phantom domain`.`Tagged carrier associated types preserve the immediate wrapping layer` {

    @Test
    func `Domain associatedtype equals the phantom Tag`() {
        let _: Tagged<Tag1, Int> = 1

        let _: Tagged<Tag1, Int>.Domain.Type = Tag1.self
    }

    @Test
    func `different phantom Tags retain distinct Domain`() {
        let _: Tagged<Tag1, Int> = 1
        let _: Tagged<Tag2, Int> = 1

        let _: Tagged<Tag1, Int>.Domain.Type = Tag1.self
        let _: Tagged<Tag2, Int>.Domain.Type = Tag2.self
    }

    @Test
    func `Underlying associatedtype equals the immediate generic parameter`() {

        let _: Tagged<Tag1, Int>.Underlying.Type = Int.self
    }

    @Test
    func `nested Tagged exposes immediate wrapped type as Underlying`() {

        let _: Tagged<Tag1, Tagged<Tag2, Int>>.Underlying.Type = Tagged<Tag2, Int>.self
    }
}

extension `Tagged carriers expose their immediate underlying type and phantom domain`.`Nested tagged carriers retain each wrapping layer` {

    @Test
    func `triple-nested Tagged reaches innermost via explicit recursion`() {

        let outer: Tagged<Tag1, Tagged<Tag2, Tagged<Tag3, Int>>> = 99
        let middle = outer.underlying
        let inner = middle.underlying
        let value = inner.underlying
        #expect(value == 99)
    }

    @Test
    func `triple-nested Tagged construction uses literal at each layer`() {

        let constructed: Tagged<Tag1, Tagged<Tag2, Tagged<Tag3, Int>>> = 7
        #expect(constructed.underlying.underlying.underlying == 7)
    }
}

extension `Tagged carriers expose their immediate underlying type and phantom domain`.`Generic carrier algorithms distinguish tagged wrapping layers` {

    @Test
    func `single-level Tagged conforms to Carrier with Underlying == Int`() {
        let tagged: Tagged<Tag1, Int> = 42
        let underlying = describeIntCarrier(tagged)
        #expect(underlying == 42)
    }

    @Test
    func `single-level Tagged round-trips through Carrier init`() {
        let constructed: Tagged<Tag1, Int> = .init(99)
        #expect(constructed.underlying == 99)
    }

    @Test
    func `Form-D generic algorithm reports immediate Underlying type`() {
        let bare: Int = 1
        let single: Tagged<Tag1, Int> = 2

        #expect(describeAnyCarrier(bare) == "Int")

        #expect(describeAnyCarrier(single) == "Int")
    }

    @Test
    func `Form-D generic algorithm distinguishes nesting layers`() {
        let nested: Tagged<Tag1, Tagged<Tag2, Int>> = 3

        let typeName = describeAnyCarrier(nested)
        #expect(typeName.contains("Tagged"))
        #expect(typeName.contains("Tag2"))
    }
}

extension `Tagged carriers expose their immediate underlying type and phantom domain`.`Repeated carrier dispatch preserves each tagged value` {

    @Test
    func `Form-D dispatch holds across batched carriers`() {

        var sum: Int = 0
        (0..<1_000).forEach { i in
            let tagged = Tagged<Tag1, Int>(_unchecked: i)
            sum &+= describeIntCarrier(tagged)
        }
        #expect(sum == (0..<1_000).reduce(0, &+))
    }
}
