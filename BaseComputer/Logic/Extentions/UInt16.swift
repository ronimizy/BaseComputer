//
//  UInt16.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 26.10.2020.
//

import SwiftUI

extension UInt16
{
    func negative() -> UInt16 { return ~self == UINT16_MAX ? 1 : ~self+1 }
    func isIndirect() -> Bool { return self.getBitsValue(11) == 1 }
    
    func mask11() -> UInt16 { return self & UInt16(0x1p11-1) }
    func mask(_ a: Int) -> UInt16 {
        return self.getBitsValue(a-1, 0)
    }
    
    func maskAddressCommand() -> UInt16 { return self & UInt16.init("F000", radix: 16)! }
    func maskIOCommand() -> UInt16 { return self & UInt16.init("FF00", radix: 16)! }
    
    func getBitsValue(_ bits: Int...) -> UInt16
    {
        if bits.count == 1 {
            return (self & (1 << bits[0])) >> bits[0]
        }
        else if bits.count == 2 {
            var answer: UInt16 = 0;
            for i in bits[1]...bits[0]
            {
                answer += self & (1 << i)
            }
            return answer >> bits[1]
        }
        return UInt16(0)
    }
    
    func signed() -> String {
        return String((self.getBitsValue(15) == 1 ? -1 * Int(UInt16.max.getBitsValue(14, 0) - self.getBitsValue(14, 0) + 1) : Int(self.getBitsValue(14, 0))))
    }
}
