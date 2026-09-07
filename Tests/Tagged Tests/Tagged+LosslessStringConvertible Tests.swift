import Tagged
import Testing

@testable import Tagged

private enum Tag1 {}
private enum Tag2 {}

@Suite
struct `Tagged text conversion preserves values within the receiving domain` {
    @Suite struct `Tagged parsing and descriptions forward to the underlying type` {}
    @Suite struct `Tagged text preserves values while the receiver selects the domain` {}
    @Suite struct `Tagged text conversion round trips a range of values` {}
    @Suite(.serialized) struct `Repeated tagged text conversion preserves values` {}
}

extension `Tagged text conversion preserves values within the receiving domain`.`Tagged parsing and descriptions forward to the underlying type` {

    @Test
    func `init parses valid string`() {
        let tagged: Tagged<Tag1, Int>? = Tagged<Tag1, Int>(String("42"))
        #expect(tagged?.underlying == 42)
    }

    @Test
    func `init returns nil for invalid string`() {
        let tagged: Tagged<Tag1, Int>? = Tagged<Tag1, Int>(String("not-an-int"))
        #expect(tagged == nil)
    }

    @Test
    func `description forwards to underlying description`() {
        let tagged: Tagged<Tag1, Int> = 99
        #expect(tagged.description == "99")
    }

    @Test
    func `Tagged conforms to LosslessStringConvertible when Underlying conforms`() {
        func _requireLossless<T: LosslessStringConvertible>(_: T.Type) {}
        _requireLossless(Tagged<Tag1, Int>.self)
        #expect(Bool(true))
    }
}

extension `Tagged text conversion preserves values within the receiving domain`.`Tagged text preserves values while the receiver selects the domain` {

    @Test
    func `within-domain roundtrip preserves value`() {
        let original: Tagged<Tag1, Int> = 100
        let serialized = original.description
        let reconstructed: Tagged<Tag1, Int>? = Tagged<Tag1, Int>(serialized)
        #expect(reconstructed == original)
    }

    @Test
    func `string description does not encode the phantom Tag`() {

        let userVal: Tagged<Tag1, Int> = 42
        let orderVal: Tagged<Tag2, Int> = 42
        #expect(userVal.description == orderVal.description)
    }

    @Test
    func `same string parses to either Tag — receiver type decides`() {
        let asTag1: Tagged<Tag1, Int>? = Tagged<Tag1, Int>(String("99"))
        let asTag2: Tagged<Tag2, Int>? = Tagged<Tag2, Int>(String("99"))
        #expect(asTag1?.underlying == 99 && asTag2?.underlying == 99)
    }
}

extension `Tagged text conversion preserves values within the receiving domain`.`Tagged text conversion round trips a range of values` {

    @Test
    func `Tagged text conversion preserves values across a range`() {
        for raw in [Int.min, -1, 0, 1, 42, Int.max] {
            let original: Tagged<Tag1, Int> = Tagged<Tag1, Int>(_unchecked: raw)
            let reconstructed: Tagged<Tag1, Int>? = Tagged<Tag1, Int>(original.description)
            #expect(reconstructed == original)
        }
    }
}

extension `Tagged text conversion preserves values within the receiving domain`.`Repeated tagged text conversion preserves values` {

    @Test
    func `Repeated tagged text conversion preserves every value`() {
        var ok = 0
        (0..<1_000).forEach { i in
            let original: Tagged<Tag1, Int> = Tagged<Tag1, Int>(_unchecked: i)
            if let reconstructed: Tagged<Tag1, Int> = Tagged<Tag1, Int>(original.description),
                reconstructed == original
            {
                ok += 1
            }
        }
        #expect(ok == 1_000)
    }
}
