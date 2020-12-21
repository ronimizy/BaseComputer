//
//  BaseComputerApp.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 23.11.2020.
//

import SwiftUI

@main
struct BaseComputerApp: App {
    
    @ObservedObject var computer = Computer()
    @State var mode: Bool = false
    
    @State var textEditor: Bool = false

    
    var body: some Scene {
        WindowGroup {
            ContentView(mode: $mode)
                .environmentObject(computer)
                .frame(minHeight: 450)
                .frame(width: mode ? 870 : 670)
        }
        .commands {
            CommandGroup(after: CommandGroupPlacement.newItem) {
                Divider()
                Button("Open Program") { computer.clear(); openProgram(computer) }
                    .keyboardShortcut("o", modifiers: .command)
                Button("Save Program") { saveProgram(computer) }
                    .keyboardShortcut("s", modifiers: .command)
                
                Divider()
                
                Button("Open Micro Program") { openMicroProgram(computer) }
                    .keyboardShortcut("o", modifiers: [.command, .shift])
                Button("Insert Micro Program") { insertMicroProgram(computer) }
                    .keyboardShortcut("i", modifiers: .command)
                Button("Save Micro Program") { saveMicroProgram(computer) }
                    .keyboardShortcut("s", modifiers: [.command, .shift])
                
                Divider()
                
                Button("Clear") { computer.clear() }
                    .keyboardShortcut("c", modifiers: [.command, .shift])
            }
            
            
            CommandMenu("Execution") {
                Button("Execute Command") { computer.execute(); computer.offset() }
                    .keyboardShortcut("e", modifiers: [.command])
                    .disabled(!computer.statusRegister.working)
                Button("Execute Micro Command") { computer.microCommandManager.execute(); computer.offset() }
                    .keyboardShortcut("e", modifiers: [.command, .shift])
                    .disabled(!computer.statusRegister.working)
                
                Divider()
                
                Button("Trace Commands") { computer.trace(false) }
                    .keyboardShortcut("t", modifiers: [.command])
                Button("Trace Micro Commands") { computer.trace(true) }
                    .keyboardShortcut("t", modifiers: [.command, .shift])
                Button("Program Description") { saveDescription(computer.program.description) }
                    .keyboardShortcut("d", modifiers: [.command, .shift])
                
                Divider()
                
                Button(mode ? "Command View" : "Micro Command View") { mode.toggle(); computer.offset() }
                    .keyboardShortcut("y")
                
                Divider()
                
                Button("Restart") { computer.restart() }
                    .keyboardShortcut("r")
            }
        }
    }
}
