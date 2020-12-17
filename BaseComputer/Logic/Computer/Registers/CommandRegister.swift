//
//  CommandRegister.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 27.10.2020.
//

import SwiftUI

struct CommandRegister
{
    var value: UInt16
    {
        get
        {
            return buffer
        }
        set
        {
            buffer = newValue
        }
    }
    private var buffer: UInt16 = 0
    var string: String {
        get { String.init(buffer, radix: 16).commandFormat() }
        set { buffer = UInt16.init(newValue, radix: 16) ?? buffer }
    }
    
    @Binding var program: Program
    @Binding var commandCounter: CommandCounter
    
    init(program: Binding<Program>, commandCounter: Binding<CommandCounter>)
    {
        self._program = program
        self._commandCounter = commandCounter
    }
    init()
    {
        self._program = .constant(Program())
        self._commandCounter = .constant(CommandCounter())
    }
}
