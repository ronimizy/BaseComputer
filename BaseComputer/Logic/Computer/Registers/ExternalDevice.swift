//
//  ExternalDevice.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 28.10.2020.
//

import SwiftUI

struct ExternalDevice
{
    var value: UInt8 = 0
    var string: String
    {
        get { return String.init(value, radix: 16).uppercased() }
        set { value = UInt8.init(newValue, radix: 16) ?? 0 }
    }
    
    var isReady: Bool = false
}
