public import Carrier_Protocol

extension Tagged: Carrier.`Protocol`
where Tag: ~Copyable & ~Escapable, Underlying: ~Copyable & ~Escapable {

    public typealias Domain = Tag

    public typealias Underlying = Underlying

    @_lifetime(copy underlying)
    public init(_ underlying: consuming Underlying) {
        self.init(_unchecked: underlying)
    }
}
