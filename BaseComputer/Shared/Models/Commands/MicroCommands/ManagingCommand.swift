//
//  ManagingCommand.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 25.08.2021.
//

import Foundation

class ManagingCommand: MicroCommand {
    public var number: Int
    public var value: UInt16
    
    public var description: String {
        var result = "УМК: IF "
        
        switch register {
        case .statusRegister:
            result += "РС"
        case .dataRegister:
            result += "РД"
        case .commandRegister:
            result += "РК"
        case .accumulator:
            result += "А"
        default:
            print("Unknown register")
            return ""
        }
        
        result += "(\(bitChecked)) == \(compareField) THEN "
        
        result += "\(String(address, radix: 16).commandFormat(2)) -> CМK"
        
        return result
    }
    
    public var compareField: UInt16 {
        value[14]
    }
    
    
    public enum CheckedRegister: UInt16 {
        case statusRegister = 0
        case dataRegister = 1
        case commandRegister = 2
        case accumulator = 3
    }
    
    public var register: CheckedRegister? {
        CheckedRegister(rawValue: value[12...13])
    }
    
    public var bitChecked: UInt16 {
        value[8...11]
    }
    
    public var address: UInt16 {
        value[0...7]
    }
    
    public init(number: Int, value: UInt16) {
        self.number = number
        self.value = value
    }
}
