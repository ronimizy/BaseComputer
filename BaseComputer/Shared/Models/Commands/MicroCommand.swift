//
//  MicroCommand.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 27.10.2020.
//

import Foundation

protocol MicroCommand: ComputerCommand {}

extension MicroCommand {
    public var string: String {
        get {
            String(value, radix: 16).commandFormat()

        }
        set {
            value = UInt16(newValue, radix: 16) ?? 0
        }
    }
}

enum MicroCommandError: Error {
    case invalidOperationCode
    case invalidValue
}

class MicroCommandFactory {
    public static func Create(number: Int, value: UInt16) throws -> MicroCommand {
        let operationCode = value[14...15]

        if operationCode == 0 {
            return OperationCommandZero(number: number, value: value)
        } else if operationCode == 1 {
            return OperationCommandOne(number: number, value: value)
        } else if operationCode == 2 || operationCode == 3 {
            return ManagingCommand(number: number, value: value)
        }

        throw MicroCommandError.invalidOperationCode
    }

    public static func Create(number: Int, value: String) throws -> MicroCommand {
        guard let parsedValue = UInt16(value, radix: 16) else {
            throw MicroCommandError.invalidValue
        }

        return try Create(number: number, value: parsedValue)
    }
}
