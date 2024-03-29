//
// Created by Георгий Круглов on 23.04.2021.
//

import SwiftUI

struct TracingToolbarItemGroup: ToolbarContent {
    @AppStorage("max-tracing-length") private var maxTracingLength: Int = 1024

    @StateObject private var computer: Computer
    @State private var isActive = false
    private let executionQueue: DispatchQueue

    private var timeStep: Double = 1


    init(computer: StateObject<Computer>, queue: DispatchQueue) {
        self._computer = computer
        self.executionQueue = queue
    }

    var body: some ToolbarContent {
        ToolbarItemGroup {
            HStack {
                ResizableDivider(1, direction: .vertical)

                Button(action: {
                    executionQueue.sync {
                        computer.trace(false, maxTracingLength)
                    }
                }) {
                    Image(systemName: "list.dash")
                }
                        .keyboardShortcut("t", modifiers: [.command])
                        .help("Выполнить трассировку команд - ⌘T")
                        .animation(Animation.easeOut(duration: timeStep))

                Button(action: {
                    executionQueue.sync {
                        let field = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
                        let response = AlertManager.runAlert(
                                message: "Введите максимальное количество команд для трассировки",
                                style: .informational) { alert in
                            alert.addButton(withTitle: "OK")
                            alert.addButton(withTitle: "Cancel")
                            alert.accessoryView = field
                        }

                        if response == NSApplication.ModalResponse.alertFirstButtonReturn {
                            guard let size = Int(field.stringValue) else {
                                AlertManager.runAlert(message: "Вы ввели не число", style: .critical)
                                return
                            }

                            computer.trace(false, size)
                        }
                    }
                }) {
                    Image(systemName: "list.number")
                }
                        .keyboardShortcut("t", modifiers: [.command, .option])
                        .help("Выполнить трассировку с заданным количеством команд - ⌘T")
                        .animation(Animation.easeOut(duration: timeStep))

                Button(action: {
                    executionQueue.sync {
                        computer.trace(true, maxTracingLength)
                    }
                }) {
                    Image(systemName: "list.bullet.indent")
                }
                        .keyboardShortcut("t", modifiers: [.command, .shift])
                        .help("Выполнить трассировку микро-команд - ⌘⇧T")
                        .animation(Animation.easeOut(duration: timeStep))

                Button(action: {
                    executionQueue.sync {
                        ProgramFileManager.saveDescription(computer.program.description)
                    }
                }) {
                    Image(systemName: "list.bullet.rectangle")
                }
                        .keyboardShortcut("d", modifiers: [.command, .shift])
                        .help("Получить описание программы - ⌘⇧D")
                        .animation(Animation.easeOut(duration: timeStep))
            }

        }
    }
}
