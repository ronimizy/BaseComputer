//
//  Programm.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 25.10.2020.
//

import Cocoa
import SwiftUI

struct Program
{
    var commands: [Command]
    var initial: [Command]
    
    var start: UInt16
    
    var description: [[String]] {
        get {
            var array: [[String]] = []
            
            for i in 0..<2048 {
                if !(commands[i].value == 0 && (i != 0 && commands[i-1].value == 0) && (i != 2047 && commands[i+1].value == 0)) {
                    let command = commands[i]
                    
                    array.append([
                        String.init(i, radix: 16).commandFormat(3),
                        command.string,
                        command.mnemonics,
                        command.description
                    ])
                }
            }
            
            return array
        }
    }
    
    init(_ start: UInt16 = 0, _ size: Int = 2048)
    {
        var array: [Command] = []
        for i in 0..<size
        {
            array.append(Command(number: i, value: "0000"))
        }
        
        self.commands = array
        self.initial = self.commands
        self.start = start
    }
    
    subscript(_ index: Int) -> Command
    {
        get
        {
            return commands[index]
        }
        set
        {
            commands[index] = newValue
        }
    }
    subscript(_ index: UInt16) -> Command
    {
        get
        {
            return commands[Int(index)]
        }
        set
        {
            commands[Int(index)] = newValue
        }
    }
}
