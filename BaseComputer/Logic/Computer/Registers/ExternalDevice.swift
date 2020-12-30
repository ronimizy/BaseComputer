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
    
    var queue: String = ""
    
    mutating func getValue() -> UInt8 {
        let value = self.value
        
        var components = queue.components(separatedBy: " ")
        
        guard UInt8.init(components[0], radix: 16) != nil else {
            self.queue = ""
            self.value = 0
            return value
        }
        
        self.value = UInt8.init(components[0], radix: 16)!
        
        components.removeFirst()
        
        self.queue = components.count == 0 ? " " : components.joined(separator: " ")
        
        return value
    }
    
    var isReady: Bool = false
}
