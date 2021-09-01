//
//  CommandStatus.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 29.11.2020.
//

import SwiftUI

class CommandStatus {
    let number: Int
    let value: String
    
    let shift: Bool
    let commandCounter: String
    let accumulator: String
    let addressRegister: String
    let commandRegister: String
    let dataRegister: String
    let statusRegister: UInt16
    let externalDevices: [ExternalDevice]
    let changedCommand: Command?

    var microCommands: [MicroCommandStatus]


    init(_ computer: Computer, _ command: Command, _ microCommands: [MicroCommandStatus], _ changed: Command? = nil) {
        self.number = command.number
        self.value = command.string
        self.microCommands = microCommands

        self.shift = computer.shift.value
        self.commandCounter = computer.commandCounter.string
        self.accumulator = computer.accumulator.string
        self.addressRegister = computer.addressRegister.string
        self.commandRegister = computer.commandRegister.string
        self.dataRegister = computer.dataRegister.string
        self.statusRegister = computer.statusRegister.value
        self.externalDevices = computer.externalDevices
        self.changedCommand = changed
    }

    func toHTMLTableRow(mode: Bool, attributes: String) -> String {
        mode
                ? Html.tableRow(
                [String(number, radix: 16).commandFormat(3),
                 commandCounter,
                 value,
                 "",
                 "",
                 accumulator,
                 shift ? "1" : "0",
                 addressRegister,
                 commandRegister,
                 dataRegister,
                 String(statusRegister, radix: 16).commandFormat(),
                 changedCommand == nil ? "" : String(changedCommand!.number, radix: 16).commandFormat(3),
                 changedCommand == nil ? "" : changedCommand!.string,
                 externalDevices[0].isReady ? "Готов" : "Не готов", externalDevices[0].string,
                 externalDevices[1].isReady ? "Готов" : "Не готов", externalDevices[1].string,
                 externalDevices[2].isReady ? "Готов" : "Не готов", externalDevices[2].string],
                attributes: attributes)
                : Html.tableRow(
                [String(number, radix: 16).commandFormat(3),
                 commandCounter,
                 value,
                 accumulator,
                 shift ? "1" : "0",
                 addressRegister,
                 commandRegister,
                 dataRegister,
                 String(statusRegister, radix: 16).commandFormat(),
                 changedCommand == nil ? "" : String(changedCommand!.number, radix: 16).commandFormat(3),
                 changedCommand == nil ? "" : changedCommand!.string,
                 externalDevices[0].isReady ? "Готов" : "Не готов", externalDevices[0].string,
                 externalDevices[1].isReady ? "Готов" : "Не готов", externalDevices[1].string,
                 externalDevices[2].isReady ? "Готов" : "Не готов", externalDevices[2].string],
                attributes: attributes)
    }
}
