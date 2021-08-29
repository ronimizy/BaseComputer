//
//  Command.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 24.10.2020.
//

import Cocoa

class Command: ComputerCommand {
    static private let commandsArray: [String: String] =
            [
                "1000": "AND ",
                "2000": "JSR ",
                "3000": "MOV ",
                "4000": "ADD ",
                "5000": "ADC ",
                "6000": "SUB ",
                "8000": "BCS ",
                "9000": "BPL ",
                "A000": "BMI ",
                "B000": "BEQ ",
                "C000": "BR ",
                "0000": "ISZ ",
                "F200": "CLA",
                "F300": "CLC",
                "F400": "CMA",
                "F500": "CMC",
                "F600": "ROL",
                "F700": "ROR",
                "F800": "INC",
                "F900": "DEC",
                "F000": "HLT",
                "F100": "NOP",
                "FA00": "EI",
                "FB00": "BI",
                "E000": "CLF ",
                "E100": "TSF ",
                "E200": "IN ",
                "E300": "OUT "
            ]

    public var value: UInt16
    public var number: Int

    public var string: String {
        get {
            String(self.value, radix: 16).commandFormat()
        }
        set {
            self.value = UInt16(newValue, radix: 16) ?? UInt16.max
        }
    }

    public var description: String {
        get {
            switch value.maskAddressCommand() {
            case UInt16("F000", radix: 16):
                return Command.commandsArray[string] ?? string

            case UInt16("E000", radix: 16):
                if Command.commandsArray[String(value.maskIOCommand(), radix: 16).uppercased()] != nil {
                    return Command.commandsArray[String(value.maskIOCommand(), radix: 16).uppercased()]!
                            + String(value.masked(8), radix: 16)
                } else {
                    return string
                }

            default:
                if Command.commandsArray[String(value.maskAddressCommand(), radix: 16).commandFormat()] != nil {
                    return Command.commandsArray[String(value.maskAddressCommand(), radix: 16).commandFormat()]!
                            + (value.isIndirect() ? " (" : " ")
                            + String(value.masked11(), radix: 16).withLength(3).uppercased()
                            + (value.isIndirect() ? ")" : "")
                } else {
                    return string
                }
            }
        }
    }

    public var longDescription: String {
        get {
            switch String(value.maskAddressCommand(), radix: 16).commandFormat() {
            case "1000":
                return "[\(value.isIndirect() ? "(" : "")\(String(value.masked11(), radix: 16).commandFormat(3))\(value.isIndirect() ? ")" : "")] & [A] –> A"
            case "2000":
                return "[CK] –> \(String(value.masked11(), radix: 16).commandFormat(3)); \(String(value.masked11(), radix: 16).commandFormat(3)) + 1 –> CK"
            case "3000":
                return "[A] –> \(String(value.masked11(), radix: 16).commandFormat(3))"
            case "4000":
                return "[A] + [\(String(value.masked11(), radix: 16).commandFormat(3))] –> A"
            case "5000":
                return "[A] + [C] + [\(String(value.masked11(), radix: 16).commandFormat(3))] –> A"
            case "6000":
                return "[A] - [\(String(value.masked11(), radix: 16).commandFormat(3))] –> A"
            case "8000":
                return "IF [C] == 0 THEN \(String(value.masked11(), radix: 16).commandFormat(3)) –> CK"
            case "9000":
                return "IF [A] ≥ 0 THEN \(String(value.masked11(), radix: 16).commandFormat(3)) –> CK"
            case "A000":
                return "IF [A] < 0 THEN \(String(value.masked11(), radix: 16).commandFormat(3)) –> CK"
            case "B000":
                return "IF [A] == 0 AND [C] == 0 THEN \(String(value.masked11(), radix: 16).commandFormat(3)) –> CK"
            case "C000":
                return "\(String(value.masked11(), radix: 16).commandFormat(3)) –> CK"
            case "0000":
                return """
                       [\(String(value.masked11(), radix: 16).commandFormat(3))] + 1 –> \(String(value.masked11(), radix: 16).commandFormat(3)); 
                       IF [\(String(value.masked11(), radix: 16).commandFormat(3))] ≥ 0 THEN [CK] + 1 –> CK
                       """
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
                switch String(value.maskIOCommand(), radix: 16).commandFormat() {
                case "E000":
                    return "0 –> ВУ-\(String(value.masked(8)))"
                case "E100":
                    return "IF ВУ-\(String(value.masked(8))) == 1 THEN [CK] + 1 –> CK"
                case "E200":
                    return "[ВУ-\(String(value.masked(8)))] –> A"
                case "E300":
                    return "[A] –> [ВУ-\(String(value.masked(8)))]"
                default:
                    return ""
                }
            default:
                return ""
            }
        }
    }

    public init(number: Int, value: UInt16 = 0) {
        self.number = number
        self.value = value
    }

    public convenience init(number: Int, value: String) {
        self.init(number: number, value: UInt16(value, radix: 16) ?? 0)
    }
}
