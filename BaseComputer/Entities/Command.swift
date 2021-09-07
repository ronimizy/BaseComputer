//
//  Command.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 24.10.2020.
//

import Cocoa
import SwiftUI

struct Command: ComputerCommand, Hashable {
    var number: Int
    var value: UInt16

    var string: String {
        get {
            String(value, radix: 16).commandFormat()
        }
        set {
            value = UInt16((Int(newValue, radix: 16) ?? 0) & Int(UInt16.max))
        }
    }

    public var isIndirect: Bool {
        value[11] == 1
    }

    init(number: Int, value: UInt16 = UInt16("0000", radix: 16)!) {
        self.number = number
        self.value = value
        self.string = String(value, radix: 16).commandFormat()
    }

    init(number: Int, value: String = "0000") {
        self.init(number: number, value: UInt16(value, radix: 16) ?? 0)
    }
}
