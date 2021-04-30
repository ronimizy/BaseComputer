//
// Created by Георгий Круглов on 24.04.2021.
//

import SwiftUI

struct FileToolbarItemGroup: ToolbarContent {
    @StateObject private var computer: Computer
    @Binding private var fileToolsPresented: Bool
    private var tracingToolsPresented: Bool

    init(computer: StateObject<Computer>, fileToolsPresented: Binding<Bool>, tracingToolsPresented: Bool) {
        self._computer = computer
        self._fileToolsPresented = fileToolsPresented
        self.tracingToolsPresented = tracingToolsPresented
    }

    var body: some ToolbarContent {
        ToolbarItemGroup {
            HStack {
                ResizableDivider(1, direction: .vertical)

                Button(action: {
                    openProgram(computer)
                }) {
                    Image(systemName: "doc.fill.badge.plus")
                }
                        .keyboardShortcut("o", modifiers: .command)
                        .help("Открыть программу - ⌘O")

                Button(action: {
                    saveProgram(computer)
                }) {
                    Image(systemName: "arrow.up.doc.fill")
                }
                        .keyboardShortcut("s", modifiers: .command)
                        .help("Сохранить программу - ⌘S")

                Button(action: {
                    openMicroProgram(computer)
                }) {
                    Image(systemName: "doc.on.clipboard")
                }
                        .keyboardShortcut("o", modifiers: [.command, .shift])
                        .help("Открыть микро-программу - ⌘⇧O")

                Button(action: {
                    saveMicroProgram(computer)
                }) {
                    Image(systemName: "arrow.up.doc.on.clipboard")
                }
                        .keyboardShortcut("s", modifiers: [.command, .shift])
                        .help("Сохранить микро-программу - ⌘⇧S")
            }
        }
    }
}
