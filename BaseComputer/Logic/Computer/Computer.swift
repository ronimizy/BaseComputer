//
//  Computer.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 26.10.2020.
//

import SwiftUI

class Computer: ObservableObject {
    @AppStorage("default-size") private var defaultSize = 50

    @Published var program: Program = Program()

    @Published var shift: Shift = Shift()
    @Published var accumulator: Register<UInt16> = Register()
    @Published var commandCounter: Register<UInt16> = Register()
    @Published var addressRegister: Register<UInt16> = Register()
    @Published var commandRegister: Register<UInt16> = Register()
    @Published var dataRegister: Register<UInt16> = Register()
    @Published var statusRegister: StatusRegister = StatusRegister()

    @Published var externalDevices: [ExternalDevice] = [ExternalDevice(), ExternalDevice(), ExternalDevice()]

    @Published var microCommandManager: MicroCommandManger = MicroCommandManger()


    var offset: (UnitPoint) -> () = { _ in
        ()
    }

    func execute() {
        program.changed = nil

        var microCommandCount = 1;
        repeat {
            microCommandManager.execute()
            microCommandCount += 1
        } while microCommandManager.microCommandCounter.value != 1

        print("Current MCC is \(microCommandManager.commandCounter.value) the unit executed \(microCommandCount) commands")


        if commandCounter.value >= program.commands.count {
            statusRegister.working = false
            return
        }
    }

    func trace(_ mode: Bool, _ size: Int = 1024) {
        var traceTable: [CommandStatus] = []


        while statusRegister.working && traceTable.count < size {
            let command = program[commandCounter.value]
            var microCommands: [MicroCommandStatus] = []

            if mode {
                repeat {
                    let microCommand = microCommandManager.microCommandMemory[Int(microCommandManager.microCommandCounter.value)]
                    microCommandManager.execute()
                    microCommands.append(MicroCommandStatus(self, microCommand))
                } while microCommandManager.microCommandCounter.value != 1
            } else {
                execute()
            }

            traceTable.append(CommandStatus(self, command, microCommands, program.changed))
        }

        if traceTable.count == size {
            AlertManager.runAlert(message: "Максимальный размер таблицы трассировки достигнут!\nПроверьте правильность программы",
                    style: .warning)
        }

        print("Program execution while tracing done")

        saveTracing(traceTable, mode: mode)
    }

    func restart() {
        accumulator.clear()
        commandCounter.value = program.start
        addressRegister.clear()
        commandRegister.clear()
        shift.value = false
        dataRegister.clear()
        statusRegister = StatusRegister()
        program.commands = program.initial

        microCommandManager.microCommandCounter.clear()
        microCommandManager.microCommandRegister.clear()
        microCommandManager.buffer.clear()

        externalDevices = [ExternalDevice(), ExternalDevice(), ExternalDevice()]
    }

    func clear() {
        accumulator.clear()
        commandCounter.clear()
        addressRegister.clear()
        commandRegister.clear()
        shift.value = false
        dataRegister.clear()
        statusRegister = StatusRegister()
        program = Program(commandCounter.value, defaultSize)

        microCommandManager.microCommandCounter.clear()
        microCommandManager.microCommandRegister.clear()
        microCommandManager.buffer.clear()
        microCommandManager.microCommandMemory = MicroCommand.array(MicroCommandManger.defaultCommands)

        externalDevices = [ExternalDevice(), ExternalDevice(), ExternalDevice()]
    }

    init(_ size: Int = 50) {
        let program = Binding(get: { self.program }, set: { self.program = $0 })
        let shift = Binding(get: { self.shift }, set: { self.shift = $0 })
        let accumulator = Binding(get: { self.accumulator }, set: { self.accumulator = $0 })
        let commandCounter = Binding(get: { self.commandCounter }, set: { self.commandCounter = $0 })
        let addressRegister = Binding(get: { self.addressRegister }, set: { self.addressRegister = $0 })
        let commandRegister = Binding(get: { self.commandRegister }, set: { self.commandRegister = $0 })
        let dataRegister = Binding(get: { self.dataRegister }, set: { self.dataRegister = $0 })
        let statusRegister = Binding(get: { self.statusRegister }, set: { self.statusRegister = $0 })
        let externalDevices = Binding(get: { self.externalDevices }, set: { self.externalDevices = $0  })


        self._program = Published(initialValue: Program(0, size))

        self._accumulator = Published(initialValue: Register(size: 16))
        self._commandCounter = Published(initialValue: Register(0, size: 11))
        self._addressRegister = Published(initialValue: Register(0, size: 11))
        self._commandRegister = Published(initialValue: Register(0, size: 16))
        self._dataRegister = Published(initialValue: Register(0, size: 16))
        self._statusRegister = Published(initialValue: StatusRegister(self))

        self._microCommandManager = Published(initialValue: MicroCommandManger(
                program: program,
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
