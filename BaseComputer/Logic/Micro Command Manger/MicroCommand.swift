//
//  MicroCommand.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 27.10.2020.
//

import SwiftUI

struct MicroCommand: ComputerCommand
{
    var value: UInt16
    var number: Int
    
    var string: String {
        get
        {
            return String.init(value, radix: 16).commandFormat()
            
        }
        set
        {
            value = UInt16.init(newValue, radix: 16) ?? 0
        }
    }
    
    func operationCode() -> UInt16
    {
        let v = value.getBitsValue(15, 14)
        return v > 1 ? 2 : v
        
    }
    
    //MARK: Операционная микрокоманда 0
    func leftGate() -> UInt16 { return value.getBitsValue(13, 12) }
    func rightGate() -> UInt16 { return value.getBitsValue(9, 8) }
    func reverseCode() -> UInt16 { return value.getBitsValue(7, 6) }
    func operation() -> UInt16 { return value.getBitsValue(5, 4) }
    func shifts() -> UInt16 { return value.getBitsValue(3, 2) }
    func memory() -> UInt16 { return value.getBitsValue(1, 0) }
    
    //MARK: Операционная микрокоманда 1
    func unused() -> UInt16 { return value.getBitsValue(13, 12)}
    func exchange() -> UInt16 { return value.getBitsValue(11, 8) }
    func shift() -> UInt16 { return value.getBitsValue(7, 6) }
    func null() -> UInt16 { return value.getBitsValue(5) }
    func sign() -> UInt16 { return value.getBitsValue(4) }
    func terminate() -> UInt16 { return value.getBitsValue(3) }
    func destination() -> UInt16 { return value.getBitsValue(2, 0) }
    
    //MARK: Управляющая микрокоманда
    func compareField() -> UInt16 { return value.getBitsValue(14) }
    func register() -> UInt16 { return value.getBitsValue(13, 12) }
    func bitChecked() -> UInt16 { return value.getBitsValue(11, 8) }
    func address() -> UInt16 { return value.getBitsValue(7, 0) }
    
    init(number: Int, value: UInt16 = UInt16(0))
    {
        self.value = value
        self.number = number
    }
    init(number: Int, value: String)
    {
        self.number = number
        self.value = UInt16.init(value, radix: 16) ?? 0
    }
    
    static func array(_ strings: [String]) -> [MicroCommand]
    {
        var array: [MicroCommand] = []
        for i in strings.indices
        {
            array.append(MicroCommand(number: i, value: strings[i]))
        }
        return array
    }
}
