//
//  CommandStatus.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 29.11.2020.
//

import SwiftUI

class CommandStatus {
    var command: Command
    var shift: Bool
    var accumulator: UInt16
    var addressRegister: UInt16
    var commandRegister: UInt16
    var dataRegister: UInt16
    var statusRegister: UInt16
    var externalDevices: [ExternalDevice]
    var changedCommand: Command? = nil

    var microCommands: [MicroCommandStatus]


    init(_ computer: Computer, _ command: Command, _ microCommands: [MicroCommandStatus], _ changed: Command? = nil) {
        self.command = command
        self.microCommands = microCommands

        self.shift = computer.shift.value
        self.accumulator = computer.accumulator.value
        self.addressRegister = computer.addressRegister.value
        self.commandRegister = computer.commandRegister.value
        self.dataRegister = computer.dataRegister.value
        self.statusRegister = computer.statusRegister.value
        self.externalDevices = computer.externalDevices
        self.changedCommand = changed
    }

    func toHTMLTableRow(mode: Bool, attributes: String) -> String {
        mode
                ? Html.tableRow(
                [String(command.number, radix: 16).commandFormat(3),
                 command.string,
                 "",
                 "",
                 String(accumulator, radix: 16).commandFormat(),
                 shift ? "1" : "0",
                 String(addressRegister, radix: 16).commandFormat(),
                 String(commandRegister, radix: 16).commandFormat(),
                 String(dataRegister, radix: 16).commandFormat(),
                 String(statusRegister, radix: 16).commandFormat(),
                 changedCommand == nil ? "" : String(changedCommand!.number, radix: 16).commandFormat(3),
                 changedCommand == nil ? "" : changedCommand!.string,
                 externalDevices[0].isReady ? "Готов" : "Не готов", externalDevices[0].string,
                 externalDevices[1].isReady ? "Готов" : "Не готов", externalDevices[1].string,
                 externalDevices[2].isReady ? "Готов" : "Не готов", externalDevices[2].string],
                attributes: attributes)
                : Html.tableRow(
                [String(command.number, radix: 16).commandFormat(3),
                 command.string,
                 String(accumulator, radix: 16).commandFormat(),
                 shift ? "1" : "0",
                 String(addressRegister, radix: 16).commandFormat(),
                 String(commandRegister, radix: 16).commandFormat(),
                 String(dataRegister, radix: 16).commandFormat(),
                 String(statusRegister, radix: 16).commandFormat(),
                 changedCommand == nil ? "" : String(changedCommand!.number, radix: 16).commandFormat(3),
                 changedCommand == nil ? "" : changedCommand!.string,
                 externalDevices[0].isReady ? "Готов" : "Не готов", externalDevices[0].string,
                 externalDevices[1].isReady ? "Готов" : "Не готов", externalDevices[1].string,
                 externalDevices[2].isReady ? "Готов" : "Не готов", externalDevices[2].string],
                attributes: attributes)
    }
}
