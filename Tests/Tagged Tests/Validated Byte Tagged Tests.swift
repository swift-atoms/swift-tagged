import Tagged
import Testing

private enum Packet {}

private struct EvenByte: Equatable {
    enum Error: Swift.Error, Equatable {
        case odd
    }

    let byte: UInt8

    init(_ byte: UInt8) throws(Error) {
        guard byte.isMultiple(of: 2) else { throw .odd }
        self.byte = byte
    }
}

private func requirePacketDomain<Value>(_: Tagged<Packet, Value>) {}

@Suite
struct `Validated Byte Tagged Tests` {

    @Test func `forwards the underlying byte`() {
        let tagged = Tagged<Packet, UInt8>(_unchecked: UInt8(0x42))
        #expect(tagged.underlying == UInt8(0x42))
    }

    @Test func `tags a successfully validated byte`() throws {
        let underlying = try EvenByte(UInt8(0xA4))
        let tagged = Tagged<Packet, EvenByte>(_unchecked: underlying)
        #expect(tagged.underlying.byte == UInt8(0xA4))
    }

    @Test func `uses the tag as the validated value domain`() {
        let tagged = Tagged<Packet, UInt8>(_unchecked: UInt8(0x42))
        requirePacketDomain(tagged)
    }

    @Test func `validates before attaching the tag`() {
        #expect(throws: EvenByte.Error.odd) {
            Tagged<Packet, EvenByte>(_unchecked: try EvenByte(UInt8(0x01)))
        }
    }

    @Test func `round-trips every byte through Tagged`() {
        for raw in UInt8.min...UInt8.max {
            let tagged = Tagged<Packet, UInt8>(_unchecked: UInt8(raw))
            #expect(tagged.underlying == raw)
        }
    }
}
