//
//  MicroCommandStatus.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 21.12.2020.
//

import Foundation

class MicroCommandStatus {
    let accumulator: String
    let shift: Bool
    let addressRegister: String
    let commandRegister: String
    let dataRegister: String
    let statusRegister: UInt16
    let externalDevices: [ExternalDevice]

    let number: Int
    let value: String
    let microCommandRegister: String
    let microCommandCounter: String
    let buffer: String

    init(_ computer: Computer, _ microCommand: MicroCommand) {
        self.shift = computer.shift.value
        self.accumulator = computer.accumulator.string
        self.addressRegister = computer.addressRegister.string
        self.commandRegister = computer.commandRegister.string
        self.dataRegister = computer.dataRegister.string
        self.statusRegister = computer.statusRegister.value
        self.externalDevices = computer.externalDevices

        self.number = microCommand.number
        self.value = microCommand.string
        self.microCommandRegister = computer.microCommandManager.microCommandRegister.string
        self.microCommandCounter = computer.microCommandManager.microCommandCounter.string
        self.buffer = computer.microCommandManager.buffer.string
    }

    func toHTMLTableRow(attributes: String) -> String {
        Html.tableRow(
                [String(number, radix: 16).commandFormat(2),
                 microCommandCounter,
                 value,
                 microCommandRegister,
                 buffer,
                 accumulator,
                 shift ? "1" : "0",
                 addressRegister,
                 commandRegister,
                 dataRegister,
                 String(statusRegister, radix: 16).commandFormat(),
                 "",
                 "",
                 externalDevices[0].isReady ? "Готов" : "Не готов", externalDevices[0].string,
                 externalDevices[1].isReady ? "Готов" : "Не готов", externalDevices[1].string,
                 externalDevices[2].isReady ? "Готов" : "Не готов", externalDevices[2].string],
                attributes: attributes)
    }
}
