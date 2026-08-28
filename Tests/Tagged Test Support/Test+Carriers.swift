public import Carrier_Protocol

extension Array: @retroactive Carrier.`Protocol` {

    public typealias Underlying = [Element]
}

extension ContiguousArray: @retroactive Carrier.`Protocol` {

    public typealias Underlying = ContiguousArray<Element>
}

extension Dictionary: @retroactive Carrier.`Protocol` {

    public typealias Underlying = [Key: Value]
}

extension Set: @retroactive Carrier.`Protocol` {

    public typealias Underlying = Set<Element>
}
