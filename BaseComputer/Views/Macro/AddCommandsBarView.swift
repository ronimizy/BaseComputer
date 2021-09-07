//
// Created by Георгий Круглов on 28.04.2021.
//

import SwiftUI

struct AddCommandsBarView: View {
    @EnvironmentObject private var computer: Computer

    @Binding private var countToAdd: Int

    @State private var isAddButtonHovered = false

    private let cellHeight: CGFloat

    init(countToAdd: Binding<Int>, cellHeight: CGFloat) {
        self._countToAdd = countToAdd
        self.cellHeight = cellHeight
    }

    var body: some View {
        HStack {
            Spacer()

            Text("Добавить команды: ")
            TextField("0", value: $countToAdd, formatter: NumberFormatter())
                    .textFieldStyle(UnderlinedTextFieldStyle(fieldHeight: cellHeight))
                    .font(.system(size: 13))
                    .frame(width: "DDDD".widthOfString(usingFont: .systemFont(ofSize: 13)))

            Button(action: { computer.program.commands.addCommands(n: countToAdd) }) {
                Image(systemName: "return")
            }
                    .buttonStyle(PlainButtonStyle())
                    .background(
                            RoundedRectangle(cornerRadius: 3)
                                    .fill(isAddButtonHovered ? Color.secondary.opacity(0.1)
                                            : .clear)
                                    .frame(width: cellHeight * 0.7,
                                            height: cellHeight * 0.7)
                    )
                    .onHover { b in
                        isAddButtonHovered = b
                    }

            Spacer().id("ADDER")
        }.frame(height: cellHeight)
    }
}
