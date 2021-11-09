//
//  MicroCommandManger.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 27.10.2020.
//

import SwiftUI

struct MicroCommandManger {
    @Binding var program: Program

    @Binding var shift: Shift
    @Binding var accumulator: Register<UInt16>
    @Binding var commandCounter: Register<UInt16>
    @Binding var addressRegister: Register<UInt16>
    @Binding var commandRegister: Register<UInt16>
    @Binding var dataRegister: Register<UInt16>
    @Binding var statusRegister: StatusRegister
    @Binding var externalDevices: [ExternalDevice]

    var microCommandCounter: Register<UInt16> = Register(defaultValue: 1)
    var microCommandRegister: Register<UInt16> = Register(0)

    var buffer: Register<UInt32> = Register(size: 17)
    var bufferShift: Bool

    var microCommandMemory: [MicroCommand] = MicroCommand.array(MicroCommandManger.defaultCommands)

    static let defaultCommands: [String] = [
        "0000",
        "0300", "4001", "0311", "4004", "0100",
        "4003", "AF0C", "AE0C", "AD0C", "EC5E",
        "838E", "AB1D", "0100", "4001", "0001",
        "A31D", "E41D", "E51D", "E61D", "E71D",
        "E81D", "E91D", "EA1D", "0110", "4002",
        "0002", "0140", "4002", "EF2D", "0100",
        "4001", "EE27", "AD24", "AC57", "8338",
        "0001", "AC50", "8335", "0001", "AD2B",
        "AC43", "83B0", "AC3C", "833F", "AE30",
        "AC47", "83D0", "AD33", "AC4C", "834E",
        "AC46", "834A", "1120", "4035", "838F",
        "1000", "4002", "0002", "838F", "1100",
        "4075", "838F", "803C", "1110", "4075",
        "838F", "1190", "4075", "838F", "808F",
        "0100", "4004", "838F", "C28F", "8347",
        "828F", "8347", "818F", "8347", "0110",
        "4002", "0002", "DF8F", "0310", "4004",
        "838F", "0110", "4003", "0300", "4002",
        "0202", "4004", "838F", "AB61", "AA6C",
        "83E0", "AA67", "A965", "A882", "8385",
        "A87B", "837E", "A96A", "A876", "8379",
        "A888", "8387", "A96F", "A88A", "838C",
        "A873", "1080", "4075", "838F", "1010",
        "4075", "838F", "0020", "4035", "838F",
        "4080", "838F", "1040", "4035", "838F",
        "8080", "8379", "40C0", "838F", "0008",
        "4075", "838F", "0004", "4075", "838F",
        "4008", "8301", "4800", "8301", "4400",
        "8301", "4100", "8788", "8501", "0020",
        "4001", "0300", "4002", "0012", "4004",
        "4400", "8301", "3000", "4004", "838F",
        "0300", "4001", "0311", "4004", "848F",
        "0300", "4001", "3000", "4002", "0312",
        "4004", "838F", "0020", "4077", "4200",
        "4400", "838F", "0000", "0000", "0000",
        "0000", "0000", "0000", "0000", "0000",
        "0000", "0000", "0000", "0000", "0000",
        "0000", "0000", "0000", "0000", "0000",
        "0000", "0000", "0000", "0000", "0000",
        "0000", "0000", "0000", "0000", "0000",
        "0000", "0000", "0000", "0000", "0000",
        "0000", "0000", "0000", "0000", "0000",
        "0000", "0000", "0000", "0000", "0000",
        "0000", "0000", "0000", "0000", "0000",
        "0000", "0000", "0000", "0000", "0000",
        "0000", "0000", "0000", "0000", "0000",
        "0000", "0000", "0000", "0000", "0000",
        "0000", "0000", "0000", "0000", "0000",
        "0000", "0000", "0000", "0000", "0000",
        "0000", "0000", "0000", "0000", "0000",
        "0000", "0000", "0000", "0000", "0000"
    ]

    func findCommandWith(a: Int, b: Int, value: UInt16, type: Int = 0) {
        for microCommand in microCommandMemory {
            if microCommand.operationCode() == type && microCommand.value[b...a] == value {
                print("\(String(microCommand.number, radix: 16).uppercased()) \(microCommand.string)")
            }
        }
    }

    mutating func execute() {
        if microCommandCounter.value == microCommandMemory.count - 1 {
            syncMain {
                commandCounter.value = 0
            }
        }
        let command = microCommandMemory[Int(microCommandCounter.value)]
        syncMain {
            microCommandRegister.value = command.value
        }

        switch command.operationCode() {
        case 0:
            var left: UInt16 = 0
            var right: UInt16 = 0

            bufferShift = false

            switch command.leftGate() {
            case 0:
                left = 0
            case 1:
                left = accumulator.value
            case 2:
                left = statusRegister.value
            case 3:
                left = commandRegister.value
            default:
                print("Command \(command.number) [\(command.string)] default on left gate, value: \(command.leftGate())")
            }

            switch command.rightGate() {
            case 0:
                right = 0
            case 1:
                right = dataRegister.value
            case 2:
                right = commandRegister.value
            case 3:
                right = commandCounter.value
                statusRegister.commandFetch = true
            default:
                print("Command \(command.number) [\(command.string)] default on right gate, value: \(command.rightGate())")
            }

            switch command.reverseCode() {
            case 0:
                ()
            case 1:
                left = ~left
            case 2:
                right = ~right
            default:
                print("Command \(command.number) [\(command.string)] default on code reverse, value: \(command.reverseCode())")
            }

            switch command.operation() {
            case 0:
                syncMain {
                    buffer.value = UInt32(left) + UInt32(right)
                }
            case 1:
                syncMain {
                    buffer.value = UInt32(left) + UInt32(right) + 1
                }
            case 2:
                syncMain {
                    buffer.value = UInt32(left & right)
                }
            default:
                print("Command \(command.number) [\(command.string)] default on operation, value: \(command.operation())")
            }

            switch command.shifts() {
            case 0:
                ()
            case 1:
                bufferShift = accumulator.value[0] == 1
                syncMain {
                    buffer.value = (UInt32(accumulator.value) >> 1)
                }
            case 2:
                bufferShift = accumulator.value[15] == 1
                syncMain {
                    buffer.value = UInt32(accumulator.value) << 1
                }
            default:
                print("Command \(command.number) [\(command.string)] default on shifts, value: \(command.shifts())")
            }

            switch command.memory() {
            case 0:
                ()
            case 1:
                syncMain {
                    dataRegister.value = program[addressRegister.value].value
                }
            case 2:
                syncMain {
                    program[addressRegister.value].value = dataRegister.value
                    program.changed = program[addressRegister.value]
                }
            default:
                print("Command \(command.number) [\(command.string)] default on memory, value: \(command.memory())")
            }

            syncMain {
                microCommandCounter += 1
            }

        case 1:
            switch command.exchange() {
            case 0:
                ()
            case 1:
                switch commandRegister.value.maskIOCommand() {
                case UInt16("E000", radix: 16):
                    syncMain {
                        externalDevices[Int(commandRegister.value.masked(8)) - 1].isReady = externalDevices[Int(commandRegister.value.masked(8)) - 1].queue != ""
                    }
                case UInt16("E100", radix: 16):
                    if externalDevices[Int(commandRegister.value.masked(8)) - 1].isReady {
                        syncMain {
                            commandCounter += 1
                        }
                    }
                case UInt16("E200", radix: 16):
                    let maskedAccumulator = accumulator.value & 0xFF00
                    syncMain {
                        accumulator.value = maskedAccumulator + UInt16(externalDevices[Int(commandRegister.value.masked(8)) - 1].getValue())
                    }
                case UInt16("E300", radix: 16):
                    syncMain {
                        externalDevices[Int(commandRegister.value.masked(8)) - 1].value = UInt8(accumulator.value.masked(8))
                    }
                default:
                    print("Command \(command.number) [\(command.string)] default on IO switch")
                }
            case 2:
                syncMain {
                    statusRegister.externalDevice = false
                    for device in externalDevices.indices {
                        externalDevices[device].isReady = false
                    }
                }
            case 4:
                syncMain {
                    statusRegister.allowInterrupt = false
                }
            case 8:
                syncMain {
                    statusRegister.allowInterrupt = true
                }
            default:
                print("Command \(command.number) [\(command.string)] default on exchange, value: \(command.exchange())")
            }

            switch command.terminate() {
            case 0:
                ()
            case 1:
                syncMain {
                    statusRegister.working = false
                }
            default:
                print("Command \(command.number) [\(command.string)] default on terminate, value: \(command.terminate())")
            }

            switch command.destination() {
            case 0:
                ()
            case 1:
                syncMain {
                    addressRegister.value = UInt16(buffer.value.masked(16))
                }
            case 2:
                syncMain {
                    dataRegister.value = UInt16(buffer.value.masked(16))
                }
            case 3:
                syncMain {
                    commandRegister.value = UInt16(buffer.value.masked(16))
                }
            case 4:
                syncMain {
                    commandCounter.value = UInt16(buffer.value.masked(16))
                }
            case 5:
                syncMain {
                    accumulator.value = UInt16(buffer.value.masked(16))
                }
            case 7:
                syncMain {
                    addressRegister.value = UInt16(buffer.value.masked(16))
                    dataRegister.value = UInt16(buffer.value.masked(16))
                    commandRegister.value = UInt16(buffer.value.masked(16))
                    accumulator.value = UInt16(buffer.value.masked(16))
                }
            default:
                print("Command \(command.number) [\(command.string)] default on destination, value: \(command.destination())")
            }


            switch command.shift() {
            case 0:
                ()
            case 1:
                syncMain {
                    shift.value = bufferShift
                }
            case 2:
                syncMain {
                    shift.value = false
                }
            case 3:
                syncMain {
                    shift.value = true
                }
            default:
                print("Command \(command.number) [\(command.string)] default on shift, value: \(command.shift())")
            }

            switch command.null() {
            case 0:
                ()
            case 1:
                syncMain {
                    statusRegister.null = buffer.value == 0
                }
            default:
                print("Micro Command \(command.number) [\(command.string)] default on null, value: \(command.null())")
            }

            switch command.sign() {
            case 0:
                ()
            case 1:
                syncMain {
                    statusRegister.sign = buffer.value[15] == 1
                }
            default:
                print("Micro Command \(command.number) [\(command.string)] default on sign, value: \(command.null())")
            }

            syncMain {
                microCommandCounter += 1
            }

        case 2:
            var checked: UInt16 = 0
            switch command.register() {
            case 0:
                switch command.bitChecked() {
                case 0:
                    checked = statusRegister.shift ? 1 : 0
                case 1:
                    checked = statusRegister.null ? 1 : 0
                case 2:
                    checked = statusRegister.sign ? 1 : 0
                case 3:
                    checked = statusRegister.zero ? 1 : 0
                case 4:
                    checked = statusRegister.allowInterrupt ? 1 : 0
                case 5:
                    checked = statusRegister.interrupted ? 1 : 0
                case 6:
                    checked = statusRegister.externalDevice ? 1 : 0
                case 7:
                    checked = statusRegister.working ? 1 : 0
                case 8:
                    checked = statusRegister.program ? 1 : 0
                case 9:
                    checked = statusRegister.commandFetch ? 1 : 0
                case 10:
                    checked = statusRegister.addressFetch ? 1 : 0
                case 11:
                    checked = statusRegister.execution ? 1 : 0
                case 12:
                    checked = statusRegister.IO ? 1 : 0
                default:
                    print("Command \(command.number) default on status reg bit check, value: \(command.bitChecked())")
                }

            case 1:
                checked = dataRegister.value[Int(command.bitChecked())]
            case 2:
                checked = commandRegister.value[Int(command.bitChecked())]
                if command.address() == UInt16("1D", radix: 16) {
                    syncMain {
                        statusRegister.commandFetch = false
                        statusRegister.addressFetch = true
                    }
                }
                if command.address() == UInt16("1E", radix: 16) {
                    syncMain {
                        statusRegister.addressFetch = false
                        statusRegister.execution = true
                    }
                }

            case 3:
                checked = accumulator.value[Int(command.bitChecked())]
            default:
                print("Command \(command.number) default on bit check, register: \(command.register()), value: \(command.bitChecked())")
            }

            syncMain {
                if checked == command.compareField() {
                    microCommandCounter.value = command.address()
                    if command.address() == 1 {
                        statusRegister.commandFetch = false
                        statusRegister.addressFetch = false
                    }
                } else {
                    microCommandCounter += 1
                }
            }


        default:
            print("Command \(command.number) [\(command.string)] default on micro command, value: \(command.operationCode())")
        }
    }

    init(program: Binding<Program> = .constant(Program()),
         shift: Binding<Shift> = .constant(Shift()),
         accumulator: Binding<Register<UInt16>> = .constant(Register()),
         commandCounter: Binding<Register<UInt16>> = .constant(Register()),
         addressRegister: Binding<Register<UInt16>> = .constant(Register()),
         commandRegister: Binding<Register<UInt16>> = .constant(Register()),
         dataRegister: Binding<Register<UInt16>> = .constant(Register()),
         statusRegister: Binding<StatusRegister> = .constant(StatusRegister()),
         externalDevices: Binding<[ExternalDevice]> = .constant([])) {
        self._program = program

        self._shift = shift
        self._accumulator = accumulator
        self._commandCounter = commandCounter
        self._addressRegister = addressRegister
        self._commandRegister = commandRegister
        self._dataRegister = dataRegister
        self._statusRegister = statusRegister
        self._externalDevices = externalDevices
    }
}
