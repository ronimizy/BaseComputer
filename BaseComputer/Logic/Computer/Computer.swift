//
//  Computer.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 26.10.2020.
//

import SwiftUI

class Computer: ObservableObject
{
    @Published var program: Program = Program()
    
    @Published var shift: Shift = Shift()
    @Published var accumulator: Accumulator = Accumulator()
    @Published var commandCounter: CommandCounter = CommandCounter()
    @Published var addressRegister: AddressRegister = AddressRegister()
    @Published var commandRegister: CommandRegister = CommandRegister()
    @Published var dataRegister: DataRegister = DataRegister()
    @Published var statusRegister: StatusRegister = StatusRegister()
    
    @Published var externalDevices: [ExternalDevice] = [ExternalDevice(), ExternalDevice(), ExternalDevice()]
    
    @Published var microCommandManager: MicroCommandManger = MicroCommandManger()
    
    
    var offset: () -> () = {()}
    
    func execute()
    {
        var a = 1;
        repeat {
            microCommandManager.execute()
            a += 1
        } while microCommandManager.microCommandCounter.getValue() != 1
        
        print("Current MCC is \(microCommandManager.commandCounter.getValue()) the unit executed \(a) commands")
    }
    
    func trace(_ mode: Bool)
    {
        var traceTable: [CommandStatus] = []
        
        
        while statusRegister.working && traceTable.count < 2048 {
            let commandsBuffer: [Command] = program.commands
            let command = program[commandCounter.getValue()]
            var microCommands: [MicroCommandStatus] = []
            var changed: Command?
            
            if mode {
                repeat {
                    let microCommand = microCommandManager.microCommandMemory[microCommandManager.microCommandCounter.getValue()]
                    microCommandManager.execute()
                    microCommands.append(MicroCommandStatus(self, microCommand))
                } while microCommandManager.microCommandCounter.getValue() != 1
            } else {
                execute()
            }
            
            for i in program.commands.indices {
                if program[i].value != commandsBuffer[i].value {
                    changed = commandsBuffer[i]
                    break
                }
            }
            
            traceTable.append(CommandStatus(self, command, microCommands, changed))
        }
        
        if traceTable.count == 2048 {
            let alert = NSAlert()
            alert.alertStyle = .critical
            alert.messageText = "Максимальный размер таблицы трассировки достигнут!\nПроверьте правильность программы"
            
            alert.runModal()
        }
        
        print("Program execution while tracing done")
        
        saveTracing(traceTable, mode: mode)
    }
    
    func restart() {
        self.accumulator.value = 0
        self.commandCounter.setValue(self.program.start)
        self.addressRegister.value = 0
        self.commandRegister.value = 0
        self.shift.value = false
        self.dataRegister.value = 0
        self.statusRegister = StatusRegister()
        self.program.commands = self.program.initial
        
        self.microCommandManager.microCommandCounter.setValue(1)
        self.microCommandManager.microCommandRegister.value = 0
        self.microCommandManager.buffer = 0
        
        self.externalDevices = [ExternalDevice(), ExternalDevice(), ExternalDevice()]
    }
    
    func clear() {
        self.accumulator.value = 0
        self.commandCounter.setValue(0)
        self.addressRegister.value = 0
        self.commandRegister.value = 0
        self.shift.value = false
        self.dataRegister.value = 0
        self.statusRegister = StatusRegister()
        self.program = Program()
        
        self.microCommandManager.microCommandCounter.setValue(1)
        self.microCommandManager.microCommandRegister.value = 0
        self.microCommandManager.buffer = 0
        self.microCommandManager.microCommandMemory = MicroCommand.array(MicroCommandManger.defaultCommands)
        
        self.externalDevices = [ExternalDevice(), ExternalDevice(), ExternalDevice()]
    }
    
    init(_ size: Int = 2048)
    {
        
        let program = Binding(get: {
            return self.program
        }, set: { (program) in
            self.program = program
        })
        let shift = Binding(get: {
            return self.shift
        }, set: { (shift) in
            self.shift = shift
        })
        let accumulator = Binding(get: {
            return self.accumulator
        }, set: { (accumulator) in
            self.accumulator = accumulator
        })
        let commandCounter = Binding(get: {
            return self.commandCounter
        }, set: { (commandCounter) in
            self.commandCounter = commandCounter
        })
        let addressRegister = Binding(get: {
            return self.addressRegister
        }, set: { (addressRegister) in
            self.addressRegister = addressRegister
        })
        let commandRegister = Binding(get: {
            return self.commandRegister
        }, set: { (commandRegister) in
            self.commandRegister = commandRegister
        })
        let dataRegister = Binding(get: {
            return self.dataRegister
        }, set: { (dataRegister) in
            self.dataRegister = dataRegister
        })
        let statusRegister = Binding(get: {
            return self.statusRegister
        }, set: { (statusRegister) in
            self.statusRegister = statusRegister
        })
        let externalDevices = Binding(get: {
            return self.externalDevices
        }, set: { (externalDevices) in
            self.externalDevices = externalDevices
        })


        self._program = Published(initialValue: Program(0, size))

        
        self._accumulator = Published(initialValue: Accumulator(shift))
        self._commandCounter = Published(initialValue: CommandCounter(0))
        self._addressRegister = Published(initialValue: AddressRegister(program: program,
                                                                        commandCounter: commandCounter))
        self._commandRegister = Published(initialValue: CommandRegister(program: program,
                                                                        commandCounter: commandCounter))
        
        self._microCommandManager = Published(initialValue: MicroCommandManger(program: program,
                                                                               shift: shift,
                                                                               accumulator: accumulator,
                                                                               commandCounter: commandCounter,
                                                                               addressRegister: addressRegister,
                                                                               commandRegister: commandRegister,
                                                                               dataRegister: dataRegister,
                                                                               statusRegister: statusRegister,
                                                                               externalDevices: externalDevices))
    }
}
