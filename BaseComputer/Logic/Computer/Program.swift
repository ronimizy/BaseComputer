//
//  Program.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 25.10.2020.
//

import SwiftUI

struct Program {
    public var start: UInt16
    
    var commands: [Command] = []
    var initial: [Command]
    var changed: Command?

    var description: [[String]] {
        get {
            var array: [[String]] = []

            for i in commands.indices {
                if !(commands[i].value == 0 && (i != 0 && commands[i - 1].value == 0) && (i != 2047 && commands[i + 1].value == 0)) {
                    let command = commands[i]

                    array.append([
                        String(i, radix: 16).commandFormat(3),
                        command.string,
                        command.mnemonics,
                        command.description
                    ])
                }
            }

            return array
        }
    }
    
    func index(before i: Int) -> Int {
        commands.index(before: i)
    }
    
    func index(after i: Int) -> Int {
        commands.index(after: i)
    }
    
    var startIndex: Int {
        commands.startIndex
    }
    
    var endIndex: Int {
        commands.endIndex
    }

    init(_ start: UInt16 = 0, _ size: Int = 2048) {
        var array: [Command] = []
        for i in 0..<size {
            array.append(Command(number: i, value: "0000"))
        }

        self.commands = array
        self.initial = self.commands
        self.start = start
    }

    init(_ start: UInt16, _ values: [Int: Command]) {
        for command in values {
            while command.key >= commands.count {
                commands.append(Command(number: commands.count, value: "0000"))
            }

            commands[command.key] = command.value
        }

        self.initial = self.commands
        self.start = start
    }
    
    subscript<T: BinaryInteger>(_ index: T) -> Command {
        mutating get {
            let index = Int(index)
            if index >= commands.count {
                commands.addCommands(n: index - commands.count + 1)
            }
            return commands[index]
        }
        set {
            let index = Int(index)
            if index >= commands.count {
                commands.addCommands(n: index - commands.count + 1)
            }
            return commands[index] = newValue
        }
    }
}

extension Program: MutableCollection {
    typealias Element = Command
    typealias Index = Int
    typealias SubSequence = ArraySlice<Command>
    typealias Indices = Range<Int>
    
    
    var indices: Range<Int> {
        commands.indices
    }
    
    subscript(position: Int) -> Command {
        get {
            self.commands[position]
        }
        set {
            self.commands[position] = newValue
        }
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

            append(Command(number: count, value: "0000"))
        }
    }
}
