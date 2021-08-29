//
//  OperationCommandOne.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 25.08.2021.
//

import Foundation

class OperationCommandOne: MicroCommand {
    public var number: Int
    public var value: UInt16
    
    var description: String {
        var result = "ОМК1: "
        
        if shiftRegister == .define || null == .define || sign == .define {
            result += "БР -> "
            if shiftRegister == .define {
                result += "C, "
            }
            if null == .define {
                result += "N, "
            }
            if sign == .define {
                result += "S"
            }
            
            result += "; "
        }
        
        if shiftRegister != nil && shiftRegister!.rawValue > 1 {
            result += "\(shiftRegister!.rawValue == 2 ? "0" : "1") -> C "
        }
        
        if (terminate == .terminate) {
            result += "0 -> РС(7) "
        }
        
        switch destination {
        case .null:
            ()
        case .addressRegister:
            result += "БР -> РА"
        case .dataRegister:
            result += "БР -> РД"
        case .commandRegister:
            result += "БР -> РК"
        case .commandCounter:
            result += "БР -> СК"
        case .accumulator:
            result += "БР -> А"
        case .addressDataCommandAccumulator:
            result += "БР -> РА, РД, РК, А"
        default:
            print("Unknown destination")
            return ""
        }
        
        return result
    }
    
    public var unused: UInt16 {
        value[12...13]
    }
    
    public enum Exchange: UInt16 {
        case null = 0
        case executeCommand = 1
        case layoffDevices = 2
        case enableInterrupt = 4
        case disableInterrupt = 8
    }
    
    public var exchange: Exchange? {
        Exchange(rawValue: value[8...11])
    }
    
    
    public enum ShiftRegister: UInt16 {
        case null = 0
        case define = 1
        case clear = 2
        case set = 3
    }

    public var shiftRegister: ShiftRegister? {
        ShiftRegister(rawValue: value[6...7])
    }
    
    
    public enum FlagRegister: UInt16 {
        case null = 0
        case define = 1
    }
    
    public var null: FlagRegister? {
        FlagRegister(rawValue: value[5])
    }
    
    public var sign: FlagRegister? {
        FlagRegister(rawValue: value[4])
    }
    
    
    public enum Terminate: UInt16 {
        case null = 0
        case terminate = 1
    }
    
    public var terminate: Terminate? {
        Terminate(rawValue: value[3])
    }
    
    
    public enum Destination: UInt16 {
        case null = 0
        case addressRegister = 1
        case dataRegister = 2
        case commandRegister = 3
        case commandCounter = 4
        case accumulator = 5
        case addressDataCommandAccumulator = 7
    }
    
    public var destination: Destination? {
        Destination(rawValue: value[0...2])
    }
    
    public init(number: Int, value: UInt16) {
        self.number = number
        self.value = value
    }
}
