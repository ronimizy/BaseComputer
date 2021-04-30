//
//  CommandCellView.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 30.12.2020.
//

import SwiftUI

struct CommandCellView: View {
    @State private var command: Command
    @State private var isEditing = false
    private var isSelected: Bool

    private var completion: (Command) -> ()
    private var setCommandCounter: (UInt16) -> ()
    private var setStart: (UInt16) -> ()

    init(_ command: Command, _ isSelected: Bool,
         completion: @escaping (Command) -> (),
         setCommandCounter: @escaping (UInt16) -> (),
         setStart: @escaping (UInt16) -> ()) {

        self._command = State(initialValue: command)
        self.isSelected = isSelected
        self.completion = completion
        self.setCommandCounter = setCommandCounter
        self.setStart = setStart
    }

    var body: some View {
        GeometryReader { g in
            ZStack {
                HStack {
                    Spacer()
                    Text(String(command.number, radix: 16).commandFormat(4))
                            .padding(.horizontal)
                    Spacer()
                            .frame(width: g.size.width * 0.6)
                }

                VStack(alignment: .center) {
                    TextField("0000", text: $command.string, onEditingChanged: { editing in
                        isEditing = editing
                        completion(command)
                    })
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
                    .background(isSelected
                            ? Color.selected
                            : command.number % 2 == 0 ? Color.rows.even : Color.rows.odd)
                    .contextMenu(ContextMenu(menuItems: {
                        Button("Перевести счётчик на эту ячейку", action: { setCommandCounter(UInt16(command.number)) })
                        Button("Сделать эту ячейку начальной", action: { setStart(UInt16(command.number)) })
                        Button("Скопировать значение ячейки", action: { ClipboardManager.copy(command.string) })
                        Button("Скопировать мнемонику ячейки", action: { ClipboardManager.copy(command.mnemonics) })
                        Button("Скопировать ячейку", action: {
                            ClipboardManager.copy("\(command.number) \(command.string) \"\(command.mnemonics)\"")
                        })
                    }))
        }
    }
}
