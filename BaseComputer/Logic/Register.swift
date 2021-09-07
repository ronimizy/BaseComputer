//
// Created by Георгий Круглов on 29.04.2021.
//

import Foundation

struct Register<TUInt> where TUInt: UnsignedInteger, TUInt: FixedWidthInteger {
    private var size: Int
    private let defaultValue: TUInt
    @Synchronized private var valueBacker: TUInt
    
    var value: TUInt {
        get {
            valueBacker
        }
        set {
            valueBacker = newValue.masked(size)
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
        self.valueBacker = defaultValue
        self.defaultValue = defaultValue
        self.size = size
    }

    init(_ value: TUInt = 0, size: Int = 16) {
        self.valueBacker = value
        self.defaultValue = 0
        self.size = size
    }

    static func +=(lhs: inout Register<TUInt>, rhs: TUInt) {
        lhs.value += rhs
    }

    mutating func clear() {
        value = defaultValue
    }
}
