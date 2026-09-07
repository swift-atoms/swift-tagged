import Tagged
import Testing

@testable import Tagged

private enum Tag1 {}

@Suite
struct `Tagged collections forward their underlying collection behavior` {
    @Suite struct `Tagged collections preserve underlying indices and elements` {}
    @Suite struct `Tagged collections preserve empty and single element shapes` {}
    @Suite struct `Collection algorithms operate on tagged values` {}
    @Suite(.serialized) struct `Repeated tagged subscripting preserves the underlying elements` {}
}

extension `Tagged collections forward their underlying collection behavior`.`Tagged collections preserve underlying indices and elements` {

    @Test
    func `startIndex and endIndex forward to Underlying`() {
        let tagged: Tagged<Tag1, [Int]> = [10, 20, 30]
        #expect(tagged.startIndex == 0)
        #expect(tagged.endIndex == 3)
    }

    @Test
    func `subscript forwards to Underlying`() {
        let tagged: Tagged<Tag1, [Int]> = [10, 20, 30]
        #expect(tagged[0] == 10)
        #expect(tagged[1] == 20)
        #expect(tagged[2] == 30)
    }

    @Test
    func `index after forwards to Underlying`() {
        let tagged: Tagged<Tag1, [Int]> = [10, 20]
        #expect(tagged.index(after: 0) == 1)
        #expect(tagged.index(after: 1) == 2)
    }

    @Test
    func `Tagged conforms to Collection when Underlying conforms`() {
        func _requireCollection<T: Swift.Collection>(_: T.Type) {}
        _requireCollection(Tagged<Tag1, [Int]>.self)
        _requireCollection(Tagged<Tag1, String>.self)
        #expect(Bool(true))
    }
}

extension `Tagged collections forward their underlying collection behavior`.`Tagged collections preserve empty and single element shapes` {

    @Test
    func `empty collection is empty`() {
        let tagged: Tagged<Tag1, [Int]> = []
        #expect(tagged.isEmpty)
        #expect(tagged.first == nil)
    }

    @Test
    func `Tagged collections preserve a single element`() {
        let tagged: Tagged<Tag1, [Int]> = [42]
        #expect(tagged.count == 1)
        #expect(tagged.first == 42)
    }
}

extension `Tagged collections forward their underlying collection behavior`.`Collection algorithms operate on tagged values` {

    @Test
    func `Collection algorithms work via opt-in conformance`() {
        let tagged: Tagged<Tag1, [Int]> = [3, 1, 4, 1, 5, 9, 2, 6]
        #expect(tagged.count == 8)
        #expect(tagged.first == 3)
        #expect(tagged.contains(4))
        #expect(!tagged.contains(99))

    }
}

extension `Tagged collections forward their underlying collection behavior`.`Repeated tagged subscripting preserves the underlying elements` {

    @Test
    func `Repeated tagged subscript access preserves every element`() {
        let elements = Array(0..<1_000)
        let tagged: Tagged<Tag1, [Int]> = Tagged<Tag1, [Int]>(_unchecked: elements)
        var sum = 0
        tagged.forEach { sum &+= $0 }
        #expect(sum == elements.reduce(0, &+))
    }
}
