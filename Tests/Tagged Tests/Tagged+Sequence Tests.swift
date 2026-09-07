import Tagged
import Tagged_Test_Support
import Testing

@testable import Tagged

private enum Tag1 {}

@Suite
struct `Tagged sequences preserve the underlying iteration behavior` {
    @Suite struct `Tagged sequences forward iterator construction and conformance` {}
    @Suite struct `Tagged iteration preserves empty and populated sequences` {}
    @Suite struct `Generic sequence algorithms accept tagged sequences` {}
    @Suite(.serialized) struct `Tagged sequence repetitions preserve the underlying traversal` {}
}

extension `Tagged sequences preserve the underlying iteration behavior`.`Tagged sequences forward iterator construction and conformance` {

    @Test
    func `makeIterator forwards to Underlying`() {
        let tagged: Tagged<Tag1, [Int]> = [1, 2, 3]
        var iter = tagged.makeIterator()
        #expect(iter.next() == 1)
        #expect(iter.next() == 2)
        #expect(iter.next() == 3)
        #expect(iter.next() == nil)
    }

    @Test
    func `Tagged conforms to Sequence when Underlying conforms`() {
        func _requireSequence<T: Swift.Sequence>(_: T.Type) {}
        _requireSequence(Tagged<Tag1, [Int]>.self)
        _requireSequence(Tagged<Tag1, Set<Int>>.self)
        #expect(Bool(true))
    }
}

extension `Tagged sequences preserve the underlying iteration behavior`.`Tagged iteration preserves empty and populated sequences` {

    @Test
    func `empty sequence iterates zero times`() {
        let tagged: Tagged<Tag1, [Int]> = []
        var count = 0
        for _ in tagged { count += 1 }
        #expect(count == 0)
    }

    @Test
    func `for-in produces same elements as underlying iteration`() {
        let tagged: Tagged<Tag1, [Int]> = [10, 20, 30]
        var viaTagged: [Int] = []
        for x in tagged { viaTagged.append(x) }
        var viaRaw: [Int] = []
        for x in tagged.underlying { viaRaw.append(x) }
        #expect(viaTagged == viaRaw)
    }
}

extension `Tagged sequences preserve the underlying iteration behavior`.`Generic sequence algorithms accept tagged sequences` {

    @Test
    func `generic Sequence algorithm accepts Tagged`() {

        func sum<S: Swift.Sequence>(_ s: S) -> Int where S.Element == Int {
            s.reduce(0, +)
        }
        let tagged: Tagged<Tag1, [Int]> = [1, 2, 3, 4]
        let plain: [Int] = [1, 2, 3, 4]
        #expect(sum(tagged) == sum(plain))
        #expect(sum(tagged) == 10)
    }
}

extension `Tagged sequences preserve the underlying iteration behavior`.`Tagged sequence repetitions preserve the underlying traversal` {

    @Test
    func `Repeated tagged iteration preserves the underlying elements`() {
        let elements = Array(0..<1_000)
        let tagged: Tagged<Tag1, [Int]> = Tagged<Tag1, [Int]>(_unchecked: elements)
        var sum = 0
        for x in tagged { sum &+= x }
        #expect(sum == elements.reduce(0, &+))
    }
}
