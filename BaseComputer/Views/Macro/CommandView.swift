//
//  CommandCellView.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 30.12.2020.
//

import SwiftUI
import Combine

struct CommandView: View {
    @Binding private var commandCounter: Register<UInt16>
    @Binding private var start: UInt16
    private var command: CommandViewModel
    
    private static let fontSize: CGFloat = 13
    
    init(commandCounter: Binding<Register<UInt16>>,
         start: Binding<UInt16>,
         command: CommandViewModel) {
        self._commandCounter = commandCounter
        self._start = start
        self.command = command
    }
    
    var body: some View {
        GeometryReader { g in
            ZStack {
                HStack {
                    Spacer()
                    Text(command.number)
                        .padding(.horizontal)
                    Spacer()
                        .frame(width: g.size.width * 0.6)
                }
                
                VStack(alignment: .center) {
                    TextField("0000", text: command.value)
                        .font(.system(size: CommandView.fontSize))
                        .frame(width: command.value.wrappedValue.widthOfString(usingFont: .systemFont(ofSize: CommandView.fontSize)))
                }
                .textFieldStyle(UnderlinedTextFieldStyle(fieldHeight: g.size.height))
                
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
            .background(Int(command.number, radix: 16) == Int(commandCounter.value)
                            ? Color.selected
                            : (Int(command.number, radix: 16) ?? 0) % 2 == 0 ? Color.rows.even : Color.rows.odd)
            .contextMenu(ContextMenu(menuItems: {
                Button("Перевести счётчик на эту ячейку") { commandCounter.value = UInt16(command.number) ?? 0 }
                Button("Сделать эту ячейку начальной") {
                    start = UInt16(command.number) ?? 0
                    commandCounter.value = start
                }
                Button("Скопировать значение ячейки") { ClipboardManager.copy(command.value.wrappedValue) }
                Button("Скопировать мнемонику ячейки") { ClipboardManager.copy(command.mnemonics) }
                Button("Скопировать ячейку") {
                    ClipboardManager.copy("\(command.value) \(command.value.wrappedValue) \"\(command.mnemonics)\"")
                }
            }))
        }
    }
}
