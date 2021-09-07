//
//  UInt16.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 26.10.2020.
//

import SwiftUI

extension UInt16 {
    func negative() -> UInt16 {
        ~self == UINT16_MAX ? 1 : ~self + 1
    }

    func masked11() -> UInt16 {
        self.masked(11)
    }

    func maskAddressCommand() -> UInt16 {
        self & UInt16("F000", radix: 16)!
    }

    func maskIOCommand() -> UInt16 {
        self & UInt16("FF00", radix: 16)!
    }

    func signed() -> String {
        String((self[15] == 1 ? -1 * Int(UInt16.max[0...14] - self[0...14]) + 1 : Int(self[0...14])))
    }
}
