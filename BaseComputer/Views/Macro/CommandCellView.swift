//
//  CommandCellView.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 30.12.2020.
//

import SwiftUI
import Combine

struct CommandCellView: View {
    @State private var isEditing = false

    @Binding private var commandCounter: Register<UInt16>
    @Binding private var start: UInt16
    @Binding private var command: Command

    init(commandCounter: Binding<Register<UInt16>>,
         start: Binding<UInt16>,
         command: Binding<Command>) {
        self._commandCounter = commandCounter
        self._start = start
        self._command = command
    }
    
    var body: some View {
        GeometryReader { g in
            ZStack {
                HStack {
                    Spacer()
                    Text(String(command.number, radix: 16).commandFormat(3))
                        .padding(.horizontal)
                    Spacer()
                        .frame(width: g.size.width * 0.6)
                }
                
                VStack(alignment: .center) {
                    TextField("0000", text: $command.string)
                        .font(.system(size: 13))
                        .frame(width: command.string.widthOfString(usingFont: .systemFont(ofSize: 13)))
                }
                .textFieldStyle(UnderlinedTextFieldStyle(editing: $isEditing, fieldHeight: g.size.height))
                
                HStack {
                    Spacer()
                        .frame(width: g.size.width * 0.6)
                    Text(command.mnemonics)
                        .frame(alignment: .leading)
                        .padding(.horizontal)
                        .help(command.description)
                    Spacer()
                }
            }
            .frame(width: g.size.width, height: g.size.height, alignment: .center)
            .background(command.number == Int(commandCounter.value)
                            ? Color.selected
                            : command.number % 2 == 0 ? Color.rows.even : Color.rows.odd)
            .contextMenu(ContextMenu(menuItems: {
                Button("Перевести счётчик на эту ячейку") { commandCounter.value = UInt16(command.number) }
                Button("Сделать эту ячейку начальной") {
                    start = UInt16(command.number)
                    commandCounter.value = start
                }
                Button("Скопировать значение ячейки") { ClipboardManager.copy(command.string) }
                Button("Скопировать мнемонику ячейки") { ClipboardManager.copy(command.mnemonics) }
                Button("Скопировать ячейку") {
                    ClipboardManager.copy("\(command.value) \(command.string) \"\(command.mnemonics)\"")
                }
            }))
        }
    }
}
