//
//  Accumulator.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 26.10.2020.
//

import SwiftUI

struct Accumulator
{
    var value: UInt16
    {
        get
        {
            return buffer
        }
        set
        {
            buffer = newValue
        }
    }
    private var buffer: UInt16 = 0
    var string: String {
        get { return String.init(buffer, radix: 16).commandFormat() }
        set { buffer = UInt16.init(newValue, radix: 16) ?? buffer }
    }
    
    @Binding var shift: Shift
    
    
    mutating func clear() { value = UInt16(0) }
    
    init(_ shift: Binding<Shift>) { self._shift = shift }
    
    init()
    {
        self._shift = .constant(Shift())
    }
}
