//
//  MicroCommandManger.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 27.10.2020.
//

import SwiftUI

class MicroCommandManger {
    private var program: Program

    private var shift: Shift
    private var accumulator: Register<UInt16>
    private var commandCounter: Register<UInt16>
    private var addressRegister: Register<UInt16>
    private var commandRegister: Register<UInt16>
    private var dataRegister: Register<UInt16>
    private var statusRegister: StatusRegister
    private var externalDevices: ExternalDevices

    private(set) var microCommandCounter: Register<UInt16> = Register(defaultValue: 1)
    private(set) var microCommandRegister: Register<UInt16> = Register(0)

    private(set) var buffer: Register<UInt32> = Register(size: 17)

    public var microCommandMemory: [MicroCommand] = []

    private static let defaultCommands: [String] = [
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

    public func execute(_ changed: ((Command) -> ())? = nil) {
        if microCommandCounter.value == microCommandMemory.count - 1 {
            microCommandCounter.value = 0
        }

        let command = microCommandMemory[Int(microCommandCounter.value)]
        microCommandRegister.value = command.value

        if let command = command as? OperationCommandZero {
            var left: UInt16 = 0
            var right: UInt16 = 0

            switch command.leftGate {
            case .zero:
                left = 0
            case .accumulator:
                left = accumulator.value
            case .statusRegister:
                left = statusRegister.value
            case .commandRegister:
                left = commandRegister.value
            default:
                print("Command \(command.number) [\(command.string)] default on left gate, value: \(String(describing: command.leftGate))")
            }

            switch command.rightGate {
            case .zero:
                right = 0
            case .dataRegister:
                right = dataRegister.value
            case .commandRegister:
                right = commandRegister.value
            case .commandCounter:
                right = commandCounter.value
                statusRegister.commandFetch = true
            default:
                print("Command \(command.number) [\(command.string)] default on right gate, value: \(String(describing: command.rightGate))")
            }

            switch command.reverseCode {
            case .null:
                ()
            case .leftGate:
                left = ~left
            case .rightGate:
                right = ~right
            default:
                print("Command \(command.number) [\(command.string)] default on code reverse, value: \(String(describing: command.reverseCode))")
            }

            switch command.operation {
            case .sum:
                buffer.value = UInt32(left) + UInt32(right)
            case .sumIncremented:
                buffer.value = UInt32(left) + UInt32(right) + 1
            case .conjunction:
                buffer.value = UInt32(left & right)
            default:
                print("Command \(command.number) [\(command.string)] default on operation, value: \(String(describing: command.operation))")
            }

            switch command.shifts {
            case .null:
                ()
            case .right:
                buffer.value = (UInt32(accumulator.value) >> 1) + (accumulator.value[0] == 1 ? UInt32(0x1p15) : 0)
            case .left:
                buffer.value = UInt32(accumulator.value) << 1 + (accumulator.value[15] == 1 ? 1 : 0)
            default:
                print("Command \(command.number) [\(command.string)] default on shifts, value: \(String(describing: command.shifts))")
            }

            switch command.memory {
            case .null:
                ()
            case .read:
                dataRegister.value = program[addressRegister.value].value
            case .write:
                program[addressRegister.value] = Command(number: Int(addressRegister.value), value: dataRegister.value)
                changed?(program[addressRegister.value])
            default:
                print("Command \(command.number) [\(command.string)] default on memory, value: \(String(describing: command.memory))")
            }
            microCommandCounter += 1

        } else if let command = command as? OperationCommandOne {
            switch command.exchange {
            case .null:
                ()
            case .executeCommand:
                switch commandRegister.value.maskIOCommand() {
                case UInt16("E000", radix: 16):
                    externalDevices[Int(commandRegister.value.masked(8)) - 1].isReady = externalDevices[Int(commandRegister.value.masked(8)) - 1].queue != ""
                case UInt16("E100", radix: 16):
                    if externalDevices[Int(commandRegister.value.masked(8)) - 1].isReady {
                        commandCounter += 1
                    }
                case UInt16("E200", radix: 16):
                    accumulator.value = UInt16(externalDevices[Int(commandRegister.value.masked(8)) - 1].getValue())
                case UInt16("E300", radix: 16):
                    externalDevices[Int(commandRegister.value.masked(8)) - 1].value = UInt8(accumulator.value.masked(8))
                default:
                    print("Command \(command.number) [\(command.string)] default on IO switch")
                }
            case .layoffDevices:
                for device in externalDevices {
                    device.isReady = false
                }
            case .enableInterrupt:
                statusRegister.allowInterrupt = false
            case .disableInterrupt:
                statusRegister.allowInterrupt = true
            default:
                print("Command \(command.number) [\(command.string)] default on exchange, value: \(String(describing: command.exchange))")
            }

            switch command.terminate {
            case .null:
                ()
            case .terminate:
                statusRegister.working = false
            default:
                print("Command \(command.number) [\(command.string)] default on terminate, value: \(String(describing: command.terminate))")
            }

            switch command.destination {
            case .null:
                ()
            case .addressRegister:
                addressRegister.value = UInt16(buffer.value.masked(16))
            case .dataRegister:
                dataRegister.value = UInt16(buffer.value.masked(16))
            case .commandRegister:
                commandRegister.value = UInt16(buffer.value.masked(16))
            case .commandCounter:
                commandCounter.value = UInt16(buffer.value.masked(16))
            case .accumulator:
                accumulator.value = UInt16(buffer.value.masked(16))
            case .addressDataCommandAccumulator:
                addressRegister.value = UInt16(buffer.value.masked(16))
                dataRegister.value = UInt16(buffer.value.masked(16))
                commandRegister.value = UInt16(buffer.value.masked(16))
                accumulator.value = UInt16(buffer.value.masked(16))
            default:
                print("Command \(command.number) [\(command.string)] default on destination, value: \(String(describing: command.destination))")
            }


            switch command.shiftRegister {
            case .null:
                ()
            case .define:
                shift.value = buffer.value[16] == 1
            case .clear:
                shift.value = false
            case .set:
                shift.value = true
            default:
                print("Command \(command.number) [\(command.string)] default on shift, value: \(String(describing: command.shiftRegister))")
            }

            switch command.null {
            case .null:
                ()
            case .define:
                statusRegister.null = buffer.value == 0
            default:
                print("Micro Command \(command.number) [\(command.string)] default on null, value: \(String(describing: command.null))")
            }

            switch command.sign {
            case .null:
                ()
            case .define:
                statusRegister.sign = buffer.value[15] == 1
            default:
                print("Micro Command \(command.number) [\(command.string)] default on sign, value: \(String(describing: command.sign))")
            }

            microCommandCounter += 1
        } else if let command = command as? ManagingCommand {
            var checked: UInt16 = 0
            switch command.register {
            case .statusRegister:
                switch command.bitChecked {
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
                    print("Command \(command.number) default on status reg bit check, value: \(command.bitChecked)")
                }

            case .dataRegister:
                checked = dataRegister.value[Int(command.bitChecked)]
            case .commandRegister:
                checked = commandRegister.value[Int(command.bitChecked)]
                if command.address == UInt16("1D", radix: 16) {
                    statusRegister.commandFetch = false
                    statusRegister.addressFetch = true
                }
                if command.address == UInt16("1E", radix: 16) {
                    statusRegister.addressFetch = false
                    statusRegister.execution = true
                }

            case .accumulator:
                checked = accumulator.value[Int(command.bitChecked)]
            default:
                print("Command \(command.number) default on bit check, register: \(String(describing: command.register)), value: \(command.bitChecked)")
            }

            if checked == command.compareField {
                microCommandCounter.value = command.address
                if command.address == 1 {
                    statusRegister.commandFetch = false
                    statusRegister.addressFetch = false
                }
            } else {
                microCommandCounter += 1
            }

        } else {
            print("Command \(command.number) [\(command.string)] default on micro command")
        }
    }

    public func clear() {
        microCommandCounter.clear()
        microCommandRegister.clear()
        buffer.clear()
    }

    public func resetMemory() throws {
        microCommandMemory = try MicroCommandManger.defaultCommands
                .enumerated()
                .map({ try MicroCommandFactory.Create(number: $0.offset, value: $0.element) })
    }

    init(program: Program,
         shift: Shift,
         accumulator: Register<UInt16>,
         commandCounter: Register<UInt16>,
         addressRegister: Register<UInt16>,
         commandRegister: Register<UInt16>,
         dataRegister: Register<UInt16>,
         statusRegister: StatusRegister,
         externalDevices: ExternalDevices) throws {
        self.program = program
        self.shift = shift
        self.accumulator = accumulator
        self.commandCounter = commandCounter
        self.addressRegister = addressRegister
        self.commandRegister = commandRegister
        self.dataRegister = dataRegister
        self.statusRegister = statusRegister
        self.externalDevices = externalDevices
        
        try resetMemory()
    }
}
