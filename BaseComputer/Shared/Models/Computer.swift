//
//  Computer.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 26.10.2020.
//

import Foundation

class Computer {
    private static var defaultSize = 50

    public var program: Program = Program()

    public var shift: Shift = Shift()
    public var accumulator = Register<UInt16>()
    public var commandCounter = Register<UInt16>()
    public var addressRegister = Register<UInt16>()
    public var commandRegister = Register<UInt16>()
    public var dataRegister = Register<UInt16>()
    public var statusRegister: StatusRegister

    public var externalDevices = ExternalDevices([ExternalDevice(), ExternalDevice(), ExternalDevice()])

    public var microCommandManager: MicroCommandManger

    func execute(_ changed: ((Command) -> ())? = nil) {
        var microCommandCount = 1;
        repeat {
            microCommandManager.execute(changed)
            microCommandCount += 1
        } while microCommandManager.microCommandCounter.value != 1

        print("Current MCC is \(microCommandManager.microCommandCounter.value) the unit executed \(microCommandCount) commands")


        if commandCounter.value >= program.count {
            statusRegister.working = false
            return
        }
    }

    func trace(_ mode: Bool, _ size: Int = 1024) {
        var traceTable: [CommandStatus] = []

        while statusRegister.working && traceTable.count < size {
            let command = program[commandCounter.value]
            var microCommands: [MicroCommandStatus] = []
            var changed: Command?

            if mode {
                repeat {
                    let microCommand = microCommandManager.microCommandMemory[Int(microCommandManager.microCommandCounter.value)]
                    microCommandManager.execute({ changed = $0 })
                    microCommands.append(MicroCommandStatus(self, microCommand))
                } while microCommandManager.microCommandCounter.value != 1
            } else {
                execute({ changed = $0 })
            }

            traceTable.append(CommandStatus(self, command, microCommands, changed))
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
        statusRegister = StatusRegister(devices: externalDevices)
        program.reset()

        microCommandManager.clear()

        resetDevices()
    }

    func clear() throws {
        accumulator.clear()
        commandCounter.clear()
        addressRegister.clear()
        commandRegister.clear()
        shift.value = false
        dataRegister.clear()
        statusRegister = StatusRegister(devices: externalDevices)
        program = Program(commandCounter.value, Computer.defaultSize)

        microCommandManager.clear()
        try microCommandManager.resetMemory()

        resetDevices()
    }

    private func resetDevices() {
        externalDevices = ExternalDevices([ExternalDevice(), ExternalDevice(), ExternalDevice()])
    }

    init(_ size: Int = 50) throws {
        self.program = Program(0, size)

        self.accumulator = Register(size: 16)
        self.commandCounter = Register(0, size: 11)
        self.addressRegister = Register(0, size: 11)
        self.commandRegister = Register(0, size: 16)
        self.dataRegister = Register(0, size: 16)
        self.statusRegister = StatusRegister(devices: externalDevices)

        self.microCommandManager = try MicroCommandManger(
                program: program,
                shift: shift,
                accumulator: accumulator,
                commandCounter: commandCounter,
                addressRegister: addressRegister,
                commandRegister: commandRegister,
                dataRegister: dataRegister,
                statusRegister: statusRegister,
                externalDevices: externalDevices)
    }
}
