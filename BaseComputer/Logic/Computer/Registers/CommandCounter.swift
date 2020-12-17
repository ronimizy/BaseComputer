//
//  CommandCounter.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 26.10.2020.
//

import SwiftUI

struct CommandCounter
{
    private var value: UInt16
    var string: String {
        get { String.init(value, radix: 16).commandFormat() }
        set { value = UInt16.init(newValue, radix: 16) ?? value }
    }
    
    mutating func increment()
    {
        self.value += 1
        self.value = self.value.mask11()
        self.string = String.init(value, radix: 16).commandFormat()
    }
    
    func getValue() -> UInt16 { return self.value }
    mutating func setValue(_ value: UInt16)
    {
        self.value = value.mask11()
    }
    
    init(_ start: UInt16 = 0)
    {
        self.value = start
    }
}
