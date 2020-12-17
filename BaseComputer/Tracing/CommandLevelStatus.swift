//
//  Status.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 29.11.2020.
//

import SwiftUI

protocol Status {
}

class CommandLevelStatus: Status
{
    var command: Command
    var shift: Bool
    var accumulator: UInt16
    var addressRegister: UInt16
    var commandRegister: UInt16
    var dataRegister: UInt16
    var statusRegister: UInt16
    var externalDevices: [ExternalDevice]
    var changedCommand: Command? = nil
    
    
    init(_ computer: Computer, changed: Command? = nil, command: Command) {
        self.command = command
        self.shift = computer.shift.value
        self.accumulator = computer.accumulator.value
        self.addressRegister = computer.addressRegister.value
        self.commandRegister = computer.commandRegister.value
        self.dataRegister = computer.dataRegister.value
        self.statusRegister = computer.statusRegister.value
        self.externalDevices = computer.externalDevices
        self.changedCommand = changed
    }
}
