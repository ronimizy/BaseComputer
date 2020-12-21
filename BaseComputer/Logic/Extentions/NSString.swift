//
//  NSString.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 04.12.2020.
//

import SwiftUI

extension NSString {
    func toProgram() -> Program? {
        let array = self.components(separatedBy: "\n")

        var program = Program()

        var position: UInt16? = nil
        var offset = 0
        
        for command in array.indices
        {
            var commandComponents = NSString(string: array[command]).components(separatedBy: " ")
            
            if commandComponents.isEmpty || commandComponents[0] == "" { continue }
            
            if commandComponents[0] == "POSITION" {
                offset = command + 1
                position = UInt16.init(commandComponents[1], radix: 16)
                print("Position set to", position ?? "nil", "offset", offset)
                continue
            }
            
            print(commandComponents)
            
            guard let index = position == nil ? Int.init(commandComponents[0], radix: 16) ?? Int.init(commandComponents[1], radix: 16) : command + Int(position!) - offset
            else { print("Failed to calculate index", position ?? "nil", commandComponents[0], command); return nil }
            
            
            if commandComponents[0] == "+"
            {
                program.start = UInt16(index)
                print("+")
                commandComponents.removeFirst()
            }
            
            if position == nil && commandComponents.count < 2 || index >= 2048 || index < 0 {
                let alert = NSAlert()
                alert.alertStyle = .critical
                alert.messageText = "Wrong command format"

                alert.runModal()
                
                return nil
            }
            
            program.commands[index] = Command(number: index, value: UInt16.init(commandComponents[position == nil ? 1 : 0], radix: 16) ?? 0)
            print(String.init(index, radix: 16), index)
        }
        
        print("Commands read")

        program.initial = program.commands
        print(program.start)

        return program
    }
}
