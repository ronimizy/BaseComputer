//
//  MicroCommandStatus.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 21.12.2020.
//

import Foundation

class MicroCommandStatus {
    var accumulator: UInt16
    var shift: Bool
    var addressRegister: UInt16
    var commandRegister: UInt16
    var dataRegister: UInt16
    var statusRegister: UInt16
    var externalDevices: [ExternalDevice]

    var microCommand: MicroCommand
    var microCommandRegister: UInt16
    var buffer: UInt32

    init(_ computer: Computer, _ microCommand: MicroCommand) {
        self.shift = computer.shift.value
        self.accumulator = computer.accumulator.value
        self.addressRegister = computer.addressRegister.value
        self.commandRegister = computer.commandRegister.value
        self.dataRegister = computer.dataRegister.value
        self.statusRegister = computer.statusRegister.value
        self.externalDevices = computer.externalDevices

        self.microCommand = microCommand
        self.microCommandRegister = computer.microCommandManager.microCommandRegister.value
        self.buffer = computer.microCommandManager.buffer.value
    }

    func toHTMLTableRow(attributes: String) -> String {
        Html.tableRow(
                [String(microCommand.number, radix: 16).commandFormat(2),
                 microCommand.string,
                 String(microCommandRegister, radix: 16).commandFormat(),
                 String(buffer, radix: 16).commandFormat(),
                 String(accumulator, radix: 16).commandFormat(),
                 shift ? "1" : "0",
                 String(addressRegister, radix: 16).commandFormat(),
                 String(commandRegister, radix: 16).commandFormat(),
                 String(dataRegister, radix: 16).commandFormat(),
                 String(statusRegister, radix: 16).commandFormat(),
                 "",
                 "",
                 externalDevices[0].isReady ? "Готов" : "Не готов", externalDevices[0].string,
                 externalDevices[1].isReady ? "Готов" : "Не готов", externalDevices[1].string,
                 externalDevices[2].isReady ? "Готов" : "Не готов", externalDevices[2].string],
                attributes: attributes)
    }
}
