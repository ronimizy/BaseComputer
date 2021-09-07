//
// Created by Георгий Круглов on 07.09.2021.
//

import SwiftUI

class CommandViewModelFactory {
    public static func create(command: Binding<Command>) -> CommandViewModel {
        let number = formatNumber(command.wrappedValue.number)
        let value = command.string
        let formattedValue = formatValue(command.wrappedValue.value, isIndirect: command.wrappedValue.isIndirect)
        
        switch getCommandFamily(value: command.wrappedValue.value) {
        case "1000":
            return CommandViewModel(number: number, value: value, mnemonics: "AND \(formattedValue)",
                                    description: "[\(formattedValue)] & [A] –> A")
        case "2000":
            return CommandViewModel(number: number, value: value, mnemonics: "JSR \(formattedValue)",
                                    description: "[CK] –> \(formattedValue); \(formattedValue) + 1 -> CK")
        case "3000":
            return CommandViewModel(number: number, value: value, mnemonics: "MOV \(formattedValue)",
                                    description: "[A] -> \(formattedValue)")
        case "4000":
            return CommandViewModel(number: number, value: value, mnemonics: "ADD \(formattedValue)",
                                    description: "[A] + [\(formattedValue)] -> A")
        case "5000":
            return CommandViewModel(number: number, value: value, mnemonics: "ADC \(formattedValue)",
                                    description: "[A] + [C] + [\(formattedValue)] -> A")
        case "6000":
            return CommandViewModel(number: number, value: value, mnemonics: "SUB \(formattedValue)",
                                    description: "[A] - \(formattedValue) -> A")
        case "8000":
            return CommandViewModel(number: number, value: value, mnemonics: "BCS \(formattedValue)",
                                    description: "IF [C] == 0 THEN \(formattedValue) -> CK")
        case "9000":
            return CommandViewModel(number: number, value: value, mnemonics: "BPL \(formattedValue)",
                                    description: "IF [A] ≥ 0 THEN \(formattedValue) -> CK")
        case "A000":
            return CommandViewModel(number: number, value: value, mnemonics: "BMI \(formattedValue)",
                                    description: "IF [A] < 0 THEN \(formattedValue) -> CK")
        case "B000":
            return CommandViewModel(number: number, value: value, mnemonics: "BEQ \(formattedValue)",
                                    description: "IF [A] == 0 AND [C] == 0 THEN \(formattedValue) -> CK")
        case "C000":
            return CommandViewModel(number: number, value: value, mnemonics: "BR \(formattedValue)",
                                    description: "\(formattedValue) -> CK")
        case "0000":
            return CommandViewModel(number: number, value: value, mnemonics: "IZS \(formattedValue)",
                                    description: "[\(formattedValue)] + 1 -> \(formattedValue); IF \(formattedValue)  ≥ 0 THEN [CK] + 1 –> CK")
        case "F000":
            switch command.wrappedValue.string {
            case "F000":
                return CommandViewModel(number: number, value: value, mnemonics: "HLT", description: "0 –> РС(7)")
            case "F100":
                return CommandViewModel(number: number, value: value, mnemonics: "NOP", description: "NO OPERATION")
            case "F200":
                return CommandViewModel(number: number, value: value, mnemonics: "CLA", description: "0 -> A")
            case "F300":
                return CommandViewModel(number: number, value: value, mnemonics: "CLC", description: "0 -> C")
            case "F400":
                return CommandViewModel(number: number, value: value, mnemonics: "CMA", description: "~[A] -> A")
            case "F500":
                return CommandViewModel(number: number, value: value, mnemonics: "CMC", description: "~[C] -> C")
            case "F600":
                return CommandViewModel(number: number, value: value, mnemonics: "ROL", description: "[A] << 1; A(15) –> C; [C] –> A(0)")
            case "F700":
                return CommandViewModel(number: number, value: value, mnemonics: "ROR", description: "[A] >> 1; A(0) –> C; [C] –> A(15)")
            case "F800":
                return CommandViewModel(number: number, value: value, mnemonics: "INC", description: "[A] + 1 –> A")
            case "F900":
                return CommandViewModel(number: number, value: value, mnemonics: "DEC", description: "[A] - 1 –> A")
            case "FA00":
                return CommandViewModel(number: number, value: value, mnemonics: "EI", description: "1 –> РС(4)")
            case "FB00":
                return CommandViewModel(number: number, value: value, mnemonics: "BI", description: "0 –> РС(4)")
            default:
                return getPlainNumberViewModel(number: number, command: command)
            }
            
        case "E000":
            let formattedIOValue = formatIOValue(command.wrappedValue.value)
            switch getIOCommandFamily(value: command.wrappedValue.value) {
            case "E000":
                return CommandViewModel(number: number, value: value, mnemonics: "CLF \(formattedIOValue)",
                                        description: "0 –> ВУ-\(formattedIOValue)")
            case "E100":
                return CommandViewModel(number: number, value: value, mnemonics: "TSF \(formattedValue)",
                                        description: "IF ВУ-\(formattedIOValue) == 1 THEN [CK] + 1 –> CK")
            case "E200":
                return CommandViewModel(number: number, value: value, mnemonics: "IN \(formattedIOValue)",
                                        description: "[ВУ-\(formattedIOValue)] –> A")
            case "E300":
                return CommandViewModel(number: number, value: value, mnemonics: "OUT \(formattedIOValue)",
                                        description: "[A] –> [ВУ-\(formattedIOValue)]")
            default:
                return getPlainNumberViewModel(number: number, command: command)
            }
            
        default:
            return getPlainNumberViewModel(number: number, command: command)
        }
    }
    
    private static func getCommandFamily(value: UInt16) -> String {
        String(value & UInt16("F000", radix: 16)!, radix: 16).commandFormat()
    }
    
    private static func getIOCommandFamily(value: UInt16) -> String {
        String(value & UInt16("FF00", radix: 16)!, radix: 16).commandFormat()
    }
    
    private static func formatNumber(_ number: Int) -> String {
        String(number, radix: 16).commandFormat(3)
    }
    
    private static func formatValue(_ value: UInt16, isIndirect: Bool) -> String {
        let stringValue = String(value.masked(11), radix: 16).commandFormat(3)
        
        if isIndirect {
            return "(\(stringValue))"
        }
        
        return stringValue
    }
    
    private static func formatIOValue(_ value: UInt16) -> String {
        String(value.masked(8), radix: 16)
    }
    
    private static func getPlainNumberViewModel(number: String, command: Binding<Command>) -> CommandViewModel {
        return CommandViewModel(number: number, value: command.string,
                                mnemonics: command.wrappedValue.string,
                                description: command.wrappedValue.value.description)
    }
}
