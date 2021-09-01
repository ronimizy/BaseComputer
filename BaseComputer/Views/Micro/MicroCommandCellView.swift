//
//  MicroCommandCellView.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 31.12.2020.
//

import SwiftUI

struct MicroCommandCellView: View {
    @State private var microCommand: MicroCommand
    @State private var isEditing = false

    private var completion: (MicroCommand) -> ()
    private var isSelected: Bool

    init(_ microCommand: MicroCommand, isSelected: Bool, completion: @escaping (MicroCommand) -> ()) {
        self._microCommand = State(initialValue: microCommand)
        self.isSelected = isSelected
        self.completion = completion
    }

    var body: some View {
        GeometryReader { g in
            ZStack {
                HStack {
                    Text(String(microCommand.number, radix: 16).commandFormat(3))
                            .padding(.horizontal)

                    Spacer()
                }

                HStack {
                    Spacer()
                            .frame(width: g.size.width * 0.15)

                    VStack(alignment: .center) {
                        TextField("0000", text: $microCommand.string) {
                            isEditing = $0
                        }
                                .textFieldStyle(UnderlinedTextFieldStyle(editing: $isEditing,
                                        fieldHeight: g.size.height))
                                .font(.system(size: 13))
                                .frame(width: microCommand.string.widthOfString(usingFont: .systemFont(ofSize: 13)))
                    }

                    Spacer()
                }

                HStack {
                    Spacer()
                            .frame(width: g.size.width * 0.25)

                    Text(microCommand.description)
                            .padding(.horizontal)
                    Spacer()
                }
            }
                    .frame(width: g.size.width, height: g.size.height, alignment: .center)
                    .background(isSelected
                            ? Color.selected
                            : microCommand.number % 2 == 0 ? Color.rows.even : Color.rows.odd)
                    .contextMenu(ContextMenu {
                        Button("Скопировать значение ячейки", action: { ClipboardManager.copy(microCommand.string) })
                        Button("Скопировать мнемонику ячейки", action: { ClipboardManager.copy(microCommand.description) })
                        Button("Скопировать ячейку", action: {
                            ClipboardManager.copy("\(microCommand.number) \(microCommand.string) \"\(microCommand.description)\"")
                        })
                    })
        }
    }
}
