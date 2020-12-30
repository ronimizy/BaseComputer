//
//  UInt32.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 03.11.2020.
//

import SwiftUI

extension UInt32
{
    func getBitsValue(_ bits: Int...) -> UInt32
    {
        if bits.count == 1
        {
            let a = (self & (UInt32(1) << bits.first!))
            if a == 0
            {
                return a
            } else {
                return a - ((UInt32(1) << bits.first!) - 1)
            }
        } else if bits.count > 1 {
            let first = UInt32(1) << (bits[0] + 1) - UInt32(1)
            let last = UInt32(1) << (bits[1] + 1) - UInt32(1)
            return self & (first - last)
        }
        return UInt32(0)
    }
    
    mutating func mask(_ n: Int)
    {
        self &= ((UInt32(1) << n) - 1)
    }
    func mask(_ n: Int) -> UInt32
    {
        return self & ((UInt32(1) << n) - 1)
    }
    
    func signed() -> String {
        return String((self.getBitsValue(15) == 1 ? -1 * Int(UInt32(UInt16.max.getBitsValue(14, 0)) - self.getBitsValue(14, 0) + 1) : Int(self.getBitsValue(14, 0))))
    }
}
