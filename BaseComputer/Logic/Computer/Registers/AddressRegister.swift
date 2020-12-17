//
//  AddressRegister.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 26.10.2020.
//

import SwiftUI

struct AddressRegister
{
    @Binding var program: Program
    @Binding var commandCounter: CommandCounter
    
    var value: UInt16
    {
        get
        {
            return buffer
        }
        set
        {
            string = String.init(newValue.mask11(), radix: 16).commandFormat()
            buffer = newValue.mask11()
        }
    }
    private var buffer: UInt16 = 0
    var string: String {
        get { return String.init(buffer, radix: 16).commandFormat() }
        set { buffer = UInt16.init(newValue, radix: 16) ?? buffer }
    }
    
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
