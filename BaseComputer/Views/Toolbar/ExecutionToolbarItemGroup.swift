//
// Created by Георгий Круглов on 23.04.2021.
//

import SwiftUI

struct ExecutionToolbarItemGroup: ToolbarContent {
    @StateObject private var computer: Computer
    @Binding private var mode: Bool
    
    private var executionQueue: DispatchQueue
    
    init(computer: StateObject<Computer>, mode: Binding<Bool>, queue: DispatchQueue) {
        self._computer = computer
        self._mode = mode
        self.executionQueue = queue
    }
    
    var body: some ToolbarContent {
        ToolbarItemGroup {
            Toggle(isOn: $mode.animation(.spring()), label: {
                Image(systemName: "eyeglasses")
            })
            .onChange(of: mode) { _ in
                computer.offset(.center)
            }
            .keyboardShortcut("y")
            .help((mode ? "Просмотр программы" : "Просмотр микро-программы") + " - ⌘Y")
            
            Button(action: {
                executionQueue.sync {
                    computer.execute()
                }
            }) {
                Image(systemName: "play.fill")
            }
            .keyboardShortcut("e", modifiers: [.command])
            .disabled(!computer.statusRegister.working)
            .help("Выполнить команду - ⌘E")
            
            Button(action: {
                executionQueue.sync {
                    computer.microCommandManager.execute()
                }
            }) {
                Image(systemName: "play")
            }
            .keyboardShortcut("e", modifiers: [.command, .shift])
            .disabled(!computer.statusRegister.working)
            .help("Выполнить микро-команду - ⌘⇧E")
            
            
            Button(action: {
                computer.clear()
            }) {
                Image(systemName: "trash.fill")
            }
            .keyboardShortcut("c", modifiers: [.command, .shift])
            .help("Сбросить БЭВМ - ⌘⇧C")
            
            Button(action: {
                computer.restart()
            }) {
                Image(systemName: "repeat")
            }
            .keyboardShortcut("r")
            .help("Перезагрузить программу - ⌘R")
        }
    }
}
