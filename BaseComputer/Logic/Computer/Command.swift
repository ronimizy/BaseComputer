//
//  Command.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 24.10.2020.
//

import Cocoa
import SwiftUI

struct Command: ComputerCommand
{
    static private let commandsArray: [String: String] =
    [
        "1000" : "AND ",
        "2000" : "JSR ",
        "3000" : "MOV ",
        "4000" : "ADD ",
        "5000" : "ADC ",
        "6000" : "SUB ",
        "8000" : "BCS ",
        "9000" : "BPL ",
        "A000" : "BMI ",
        "B000" : "BEQ ",
        "C000" : "BR ",
        "0000" : "ISZ ",
        "F200" : "CLA",
        "F300" : "CLC",
        "F400" : "CMA",
        "F500" : "CMC",
        "F600" : "ROL",
        "F700" : "ROR",
        "F800" : "INC",
        "F900" : "DEC",
        "F000" : "HLT",
        "F100" : "NOP",
        "FA00" : "EI",
        "FB00" : "BI",
        "E000" : "CLF ",
        "E100" : "TSF ",
        "E200" : "IN ",
        "E300" : "OUT "
    ]
    
    var value: UInt16
    var number: Int
    
    var string: String
    {
        get
        {
            return String.init(self.value, radix: 16).commandFormat()
        }
        set
        {
            self.value = UInt16((Int.init(newValue, radix: 16) ?? 0) & Int(UInt16.max))
        }
    }
    
    var mnemonics: String
    {
        get
        {
            switch value.maskAddressCommand() {
            case UInt16.init("F000", radix: 16):
                return Command.commandsArray[string] ?? string
                
            case UInt16.init("E000", radix: 16):
                if Command.commandsArray[String.init(value.maskIOCommand(), radix: 16).uppercased()] != nil
                {
                    return Command.commandsArray[String.init(value.maskIOCommand(), radix: 16).uppercased()]!
                        + String.init(value.mask(8), radix: 16)
                } else {
                    return string
                }
                
            default:
                if Command.commandsArray[String.init(value.maskAddressCommand(), radix: 16).commandFormat()] != nil
                {
                    return Command.commandsArray[String.init(value.maskAddressCommand(), radix: 16).commandFormat()]!
                        + (value.isIndirect() ? " (" : " ")
                        + String.init(value.mask11(), radix: 16).setLength(3).uppercased()
                        + (value.isIndirect() ? ")" : "")
                } else {
                    return string
                }
            }
        }
    }
    
    mutating func format()
    {
        string = string.commandFormat()
    }
    
    init(number: Int, value: UInt16 = UInt16.init("0000", radix: 16)!)
    {
        self.number = number
        self.value = value
    }
    init(number: Int, value: String = "0000")
    {
        self.init(number: number, value: UInt16.init(value, radix: 16) ?? 0)
    }
}
