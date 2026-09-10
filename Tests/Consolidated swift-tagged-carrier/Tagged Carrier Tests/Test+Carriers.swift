public import Carrier
public import Tagged

extension Swift.Array: @retroactive Carrier.`Protocol` {

    public typealias Underlying = Swift.Array<Element>
}

extension Swift.ContiguousArray: @retroactive Carrier.`Protocol` {

    public typealias Underlying = Swift.ContiguousArray<Element>
}

extension Swift.Dictionary: @retroactive Carrier.`Protocol` {

    public typealias Underlying = Swift.Dictionary<Key, Value>
}

extension Swift.Set: @retroactive Carrier.`Protocol` {

    public typealias Underlying = Swift.Set<Element>
}
