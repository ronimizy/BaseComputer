//
//  Program.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 25.10.2020.
//

import Cocoa

class Program: RandomAccessCollection, MutableCollection {
    typealias Element = Array<Command>.Element
    typealias Index = Array<Command>.Index
    typealias SubSequence = Array<Command>.SubSequence
    typealias Indices = Array<Command>.Indices

    var startIndex: Array<Command>.Index {
        commands.startIndex
    }

    var endIndex: Array<Command>.Index {
        commands.endIndex
    }

    private var commands: [Command] = []
    private var initial: [Command]

    public var start: UInt16

    public var description: [[String]] {
        get {
            var array: [[String]] = []

            for i in commands.indices {
                if !(commands[i].value == 0 &&
                        (i != 0 && commands[i - 1].value == 0) &&
                        (i != 2047 && commands[i + 1].value == 0)) {
                    let command = commands[i]

                    array.append([
                        String(i, radix: 16).commandFormat(3),
                        command.string,
                        command.description,
                        command.longDescription
                    ])
                }
            }

            return array
        }
    }

    public init(_ start: UInt16 = 0, _ size: Int = 2048) {
        var array: [Command] = []
        for i in 0..<size {
            array.append(Command(number: i))
        }

        self.commands = array
        self.initial = self.commands
        self.start = start
    }

    public init(_ start: UInt16, _ values: [Int: Command]) {
        for command in values {
            while command.key >= commands.count {
                commands.append(Command(number: commands.count))
            }

            commands[command.key] = command.value
        }

        self.initial = self.commands
        self.start = start
    }

    public subscript<TIndex: BinaryInteger>(_ rawIndex: TIndex) -> Command {
        get {
            let index = Int(rawIndex)
            if index >= commands.count {
                commands.addCommands(n: index - commands.count + 1)
            }
            return commands[index]
        }
        set {
            let index = Int(rawIndex)
            if index >= commands.count {
                commands.addCommands(n: index - commands.count + 1)
            }
            return commands[index] = newValue
        }
    }

    public func reset() {
        commands = initial
    }

    public func save() {
        initial = commands
    }
}

extension Array where Element == Command {
    mutating func addCommands(n: Int) {
        if n < 0 {
            return
        }

        for _ in 0..<n {
            if count >= 2048 {
                break
            }

            append(Command(number: count))
        }
    }
}
