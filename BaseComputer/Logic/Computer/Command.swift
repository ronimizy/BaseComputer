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
    
    var description: String {
        get {
            switch String.init(value.maskAddressCommand(), radix: 16).commandFormat() {
            case "1000":
                return "[\(value.isIndirect() ? "(" : "")\(String.init(value.mask11(), radix: 16).commandFormat(3))\(value.isIndirect() ? ")" : "")] & [A] –> A"
            case "2000":
                return "[CK] –> \(String.init(value.mask11(), radix: 16).commandFormat(3)); \(String.init(value.mask11(), radix: 16).commandFormat(3)) + 1 –> CK"
            case "3000":
                return "[A] –> \(String.init(value.mask11(), radix: 16).commandFormat(3))"
            case "4000":
                return "[A] + [\(String.init(value.mask11(), radix: 16).commandFormat(3))] –> A"
            case "5000":
                return "[A] + [C] + [\(String.init(value.mask11(), radix: 16).commandFormat(3))] –> A"
            case "6000":
                return "[A] - [\(String.init(value.mask11(), radix: 16).commandFormat(3))] –> A"
            case "8000":
                return "IF [C] == 0 THEN \(String.init(value.mask11(), radix: 16).commandFormat(3)) –> CK"
            case "9000":
                return "IF [A] ≥ 0 THEN \(String.init(value.mask11(), radix: 16).commandFormat(3)) –> CK"
            case "A000":
                return "IF [A] < 0 THEN \(String.init(value.mask11(), radix: 16).commandFormat(3)) –> CK"
            case "B000":
                return "IF [A] == 0 AND [C] == 0 THEN \(String.init(value.mask11(), radix: 16).commandFormat(3)) –> CK"
            case "C000":
                return "\(String.init(value.mask11(), radix: 16).commandFormat(3)) –> CK"
            case "0000":
                return "[\(String.init(value.mask11(), radix: 16).commandFormat(3))] + 1 –> \(String.init(value.mask11(), radix: 16).commandFormat(3)); IF [\(String.init(value.mask11(), radix: 16).commandFormat(3))] ≥ 0 THEN [CK] + 1 –> CK"
            case "F000":
                switch string {
                case "F000":
                    return "0 –> РС(7)"
                case "F100":
                    return "NO OPERATION"
                case "F200":
                    return "0 –> A"
                case "F300":
                    return "0 –> C"
                case "F400":
                    return "~[A] –> A"
                case "F500":
                    return "~[C} –> C";
                case "F600":
                    return "[A] << 1; A(15) –> C; [C] –> A(0)"
                case "F700":
                    return "[A] >> 1; A(0) –> C; [C] –> A(15)"
                case "F800":
                    return "[A] + 1 –> A"
                case "F900":
                    return "[A] - 1 –> A"
                case "FA00":
                    return "1 –> РС(4)"
                case "FB00":
                    return "0 –> РС(4)"
                default:
                    return ""
                }
            case "E000":
                switch String.init(value.maskIOCommand(), radix: 16).commandFormat() {
                case "E000":
                    return "0 –> ВУ-\(String(value.mask(8)))"
                case "E100":
                    return "IF ВУ-\(String(value.mask(8))) == 1 THEN [CK] + 1 –> CK"
                case "E200":
                    return "[ВУ-\(String(value.mask(8)))] –> A"
                case "E300":
                    return "[A] –> [ВУ-\(String(value.mask(8)))]"
                default:
                    return ""
                }
            default:
                return ""
            }
        }
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
