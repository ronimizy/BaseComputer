//
//  MicroCommandLevelStatus.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 29.11.2020.
//

import SwiftUI

class MicroCommandLevelStatus: Status
{
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
    
    init(_ computer: Computer) {
        self.shift = computer.shift.value
        self.accumulator = computer.accumulator.value
        self.addressRegister = computer.addressRegister.value
        self.commandRegister = computer.commandRegister.value
        self.dataRegister = computer.dataRegister.value
        self.statusRegister = computer.statusRegister.value
        self.externalDevices = computer.externalDevices
        
        self.microCommand = computer.microCommandManager.microCommandMemory[Int(computer.microCommandManager.microCommandCounter.getValue())]
        self.microCommandRegister = computer.microCommandManager.microCommandRegister.value
        self.buffer = computer.microCommandManager.buffer
    }
}
