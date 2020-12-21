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
