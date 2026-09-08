import Carrier
import Tagged
import Testing

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
struct `Tagged carrier tests` {
    @Suite struct `Unit tests` {}
    @Suite struct `Edge case tests` {}
    @Suite struct `Integration tests` {}
    @Suite(.serialized) struct `Performance tests` {}
}

extension `Tagged carrier tests`.`Unit tests` {

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

extension `Tagged carrier tests`.`Edge case tests` {

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

extension `Tagged carrier tests`.`Integration tests` {

    @Test
    func `test support supplies collection self-carriers`() {
        let array = [1, 2, 3]
        let contiguous = ContiguousArray(array)
        let dictionary = ["answer": 42]
        let set = Set(array)

        #expect(array.underlying == array)
        #expect(contiguous.underlying == contiguous)
        #expect(dictionary.underlying == dictionary)
        #expect(set.underlying == set)
    }

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

extension `Tagged carrier tests`.`Performance tests` {

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
