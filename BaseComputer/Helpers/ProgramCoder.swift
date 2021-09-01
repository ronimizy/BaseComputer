//
// Created by Георгий Круглов on 27.04.2021.
//

import Foundation

struct ProgramCoder {
    enum ProgramType {
        case Program
        case MicroProgram
    }
    
    static func decodeProgram(data: NSString) -> Program? {
        var program: [Int: Command] = [:]
        var start: UInt16 = 0
        
        decodeAny(.Program, data: data, assign: { number, value in
            program[number] = Command(number: number, value: value)
        }, isIndexCorrect: { size in
            size < 2048
        }, setStart: { number in
            start = number
        })
        
        return Program(start, program)
    }
    
    static func decodeMicroProgram(data: NSString, manager: inout MicroCommandManger) {
        decodeAny(.MicroProgram, data: data, assign: { number, value in
            syncMain {
                manager.microCommandMemory[number].value = value
            }
        }, isIndexCorrect: { index in
            index < manager.microCommandMemory.count
        })
    }
    
    static private func decodeAny(_ type: ProgramType, data: NSString,
                                  assign: (Int, UInt16) -> (),
                                  isIndexCorrect: (Int) -> Bool,
                                  setStart: ((UInt16) -> ())? = nil) {
        let array = parseProgram(data: data)
        
        var counter: Int = 0
        
        for row in array {
            var elements = row.components(separatedBy: " ").filter { s in
                !s.isEmpty
            }
            var isStart = false
            
            if (elements.first?.first == "+") {
                isStart = true
                elements[0].removeFirst()
                elements = elements.filter { s in
                    !s.isEmpty
                }
            }
            
            if elements.count == 1 {
                guard let value = UInt16(elements[0], radix: 16),
                      isIndexCorrect(counter) else {
                    AlertManager.runAlert(message: "Wrong command format:\n\(elements[0])", style: .critical)
                    return
                }
                
                assign(counter, value)
                if isStart {
                    setStart?(UInt16(counter))
                }
                print(counter, value)
            } else if elements.count == 2 {
                guard let index = Int(elements[0], radix: 16),
                      let value = UInt16(elements[1], radix: 16),
                      isIndexCorrect(index) else {
                    AlertManager.runAlert(message: "Wrong command format:\n\(elements[0]) \(elements[1])", style: .critical)
                    return
                }
                
                assign(index, value)
                counter = Int(index)
                
                if isStart {
                    setStart?(UInt16(counter))
                }
                print(counter, index, value)
            } else {
                AlertManager.runAlert(message: "Wrong command format: \(elements)", style: .critical)
                return
            }
            
            counter += 1
        }
    }
    
    static func encodeProgram(program: Program) -> String {
        var result = ""
        
        for command in program.commands {
            if command.value == 0 && command.number != program.start {
                continue
            }
            
            if (command.number == program.start) {
                result += "+ "
            }
            
            result += String(command.number, radix: 16).setLength(3).uppercased()
            result += " \(command.string)\n"
        }
        return result
    }
    
    static func encodeMicroProgram(manager: MicroCommandManger) -> String {
        var result = ""
        
        for microCommand in manager.microCommandMemory {
            result += "\(microCommand.string)\n"
        }
        
        return result
    }
    
    private static func parseProgram(data: NSString) -> [String] {
        data.components(separatedBy: ["\n", "\r"])
            .map { s -> String in
                guard let index = s.firstIndex(of: "#") else {
                    return s
                }
                
                return String(s[..<index])
            }
            .filter { s in
                !s.isEmpty && (s.filter { c in
                    c == " "
                }.count != s.count)
            }
    }
}
