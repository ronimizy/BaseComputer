//
// Created by Георгий Круглов on 29.04.2021.
//

import Foundation

class Register<TUInt> where TUInt: UnsignedInteger, TUInt: FixedWidthInteger {
    private var size: Int
    private let defaultValue: TUInt

    var value: TUInt {
        didSet {
            value = value.masked(size)
        }
    }

    var string: String {
        get {
            String(value, radix: 16).commandFormat()
        }
        set {
            value = TUInt(UInt32(newValue, radix: 16) ?? UInt32(value))
        }
    }

    init(defaultValue: TUInt, size: Int = 16) {
        self.value = defaultValue
        self.defaultValue = defaultValue
        self.size = size
    }

    init(_ value: TUInt = 0, size: Int = 16) {
        self.value = value
        self.defaultValue = 0
        self.size = size
    }

    static func +=(lhs: inout Register<TUInt>, rhs: TUInt) {
        lhs.value += rhs
    }

    func clear() {
        value = defaultValue
    }
}
