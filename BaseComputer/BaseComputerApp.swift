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
                Button("Открыть программу") { computer.clear(); openProgram(computer) }
                    .keyboardShortcut("o", modifiers: .command)
                Button("Сохранить программу") { saveProgram(computer) }
                    .keyboardShortcut("s", modifiers: .command)
                
                Divider()
                
                Button("Открыть микро-программу") { openMicroProgram(computer) }
                    .keyboardShortcut("o", modifiers: [.command, .shift])
                Button("Внедрить микро-программу") { insertMicroProgram(computer) }
                    .keyboardShortcut("i", modifiers: .command)
                Button("Сохранить микро-программу") { saveMicroProgram(computer) }
                    .keyboardShortcut("s", modifiers: [.command, .shift])
                
                Divider()
                
                Button("Сбросить БЭВМ") { computer.clear() }
                    .keyboardShortcut("c", modifiers: [.command, .shift])
                
                Button("Перезагрузить программу") { computer.restart() }
                    .keyboardShortcut("r")
            }
            
            
            CommandMenu("Выполнение") {
                Button("Выполнить команду") { computer.execute(); computer.offset() }
                    .keyboardShortcut("e", modifiers: [.command])
                    .disabled(!computer.statusRegister.working)
                Button("Выполнить микро-команду") { computer.microCommandManager.execute(); computer.offset() }
                    .keyboardShortcut("e", modifiers: [.command, .shift])
                    .disabled(!computer.statusRegister.working)
                
                Divider()
                
                Button("Выполнить трассировку команд") { computer.trace(false) }
                    .keyboardShortcut("t", modifiers: [.command])
                Button("Выполнить трассировку с заданным количеством команд") {
                    let alert = NSAlert()
                    let field = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
                    
                    alert.alertStyle = NSAlert.Style.informational
                    alert.addButton(withTitle: "OK")
                    alert.addButton(withTitle: "Cancel")
                    alert.messageText = "Введите максимальное количество команд для трассировки"
                    alert.accessoryView = field
                    
                    if alert.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn {
                        guard let size = Int(field.stringValue) else {
                            let error = NSAlert()
                            error.alertStyle = NSAlert.Style.critical
                            error.messageText = "Вы ввели не число"
                            
                            error.runModal()
                            
                            return
                        }
                        
                        computer.trace(false, size)
                    }
                }
                    .keyboardShortcut("t", modifiers: [.command, .option])
                Button("Выполнить трассировку микро-команд") { computer.trace(true) }
                    .keyboardShortcut("t", modifiers: [.command, .shift])
                Button("Получить описание программы") { saveDescription(computer.program.description) }
                    .keyboardShortcut("d", modifiers: [.command, .shift])
                
                Divider()
                
                Button(mode ? "Просмотр программы" : "Просмотр микро-программы") { mode.toggle(); computer.offset() }
                    .keyboardShortcut("y")
            }
        }
    }
}
