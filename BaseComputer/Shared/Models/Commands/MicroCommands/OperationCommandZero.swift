//
//  OperationCommandZero.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 25.08.2021.
//

import Foundation

class OperationCommandZero: MicroCommand {
    public var number: Int
    public var value: UInt16
    
    var description: String {
        var result = "ОМК0: "
        
        if reverseCode != nil && reverseCode!.rawValue > 0 {
            result += "~"
        }
        
        switch leftGate {
        case .zero:
            result += "0 "
        case .accumulator:
            result += "A "
        case .statusRegister:
            result += "РС "
        case .commandRegister:
            result += "КР "
        default:
            print("Unknown left gate")
            return ""
        }
        
        switch operation {
        case .sum, .sumIncremented:
            result += "+ "
        case .conjunction:
            result += "& "
        default:
            print("Unknown operation")
            return ""
        }
        
        if reverseCode != nil && reverseCode!.rawValue > 1 {
            result += "~"
        }
        switch rightGate {
        case .zero:
            result += "0 "
        case .dataRegister:
            result += "РД "
        case .commandRegister:
            result += "РК "
        case .commandCounter:
            result += "СК "
        default:
            print("Unknown right gate")
            return ""
        }
        if operation == .sumIncremented {
            result += "+ 1"
        }
        
        result += " -> БР; "
        
        if !(shifts == .null && memory == .null) {
            switch shifts {
            case .null:
                ()
            case .right:
                result += "(A >> 1) -> БР; "
            case .left:
                result += "(A << 1) -> БР; "
            default:
                print("Unknown shift")
                return ""
            }
            
            switch memory {
            case .null:
                ()
            case .read:
                result += "ОП(РА) -> РД;"
            case .write:
                result += "РД -> ОП(РА);"
            default:
                print("Unknown memory")
                return ""
            }
        }
        
        return result
    }
    
    public enum LeftGate: UInt16 {
        case zero = 0
        case accumulator = 1
        case statusRegister = 2
        case commandRegister = 3
    }
    
    public var leftGate: LeftGate? {
        LeftGate(rawValue: value[12...13])
    }
    
    
    public enum RightGate: UInt16 {
        case zero = 0
        case dataRegister = 1
        case commandRegister = 2
        case commandCounter = 3
    }
    
    public var rightGate: RightGate? {
        RightGate(rawValue: value[8...9])
    }
    
    
    public enum ReverseCode: UInt16 {
        case null = 0
        case leftGate = 1
        case rightGate = 2
    }
    
    public var reverseCode: ReverseCode? {
        ReverseCode(rawValue: value[6...7])
    }
    
    
    public enum Operation: UInt16 {
        case sum = 0
        case sumIncremented = 1
        case conjunction = 2
    }

    public var operation: Operation? {
        Operation(rawValue: value[4...5])
    }
    
    
    public enum Shifts: UInt16 {
        case null = 0
        case right = 1
        case left = 2
    }
    
    public var shifts: Shifts? {
        Shifts(rawValue: value[2...3])
    }
    
    
    public enum Memory: UInt16 {
        case null = 0
        case read = 1
        case write = 2
    }
    
    public var memory: Memory? {
        Memory(rawValue: value[0...1])
    }
    
    public init(number: Int, value: UInt16) {
        self.number = number
        self.value = value
    }
}
