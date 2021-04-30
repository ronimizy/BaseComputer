//
//  Program.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 25.10.2020.
//

import Cocoa
import SwiftUI

struct Program {
    var commands: [Command] = []
    var initial: [Command]
    var changed: Command?

    var start: UInt16

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

    subscript(_ index: Int) -> Command {
        mutating get {
            if index >= commands.count {
                commands.addCommands(n: index - commands.count + 1)
            }
            return commands[index]
        }
        set {
            if index >= commands.count {
                commands.addCommands(n: index - commands.count + 1)
            }
            return commands[index] = newValue
        }
    }
    subscript<T: UnsignedInteger>(_ index: T) -> Command {
        mutating get {
            self[Int(index)]
        }
        set {
            self[Int(index)] = newValue
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