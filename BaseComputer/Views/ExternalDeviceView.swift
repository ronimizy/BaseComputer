//
//  ExternalDeviceView.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 31.12.2020.
//

import SwiftUI

struct ExternalDeviceView: View {
    @EnvironmentObject private var computer: Computer
    @State private var queueIsEditing = [false, false, false]
    @State private var valueIsEditing = [false, false, false]

    private var rowHeight: CGFloat = 40

    var body: some View {
        //MARK: Внешние устройства
        VStack {
            ForEach(0..<3) { number in
                VStack {
                    HStack(alignment: .center) {
                        Spacer()

                        Text("ВУ-\(number + 1)")
                        Text("РД:")
                        TextField("00", text: $computer.externalDevices[number].string,
                                onEditingChanged: { valueIsEditing[number] = $0 })
                                .frame(maxWidth: 40)
                                .textFieldStyle(UnderlinedTextFieldStyle(editing: $valueIsEditing[number], fieldHeight: rowHeight))
                        Toggle(isOn: $computer.externalDevices[number].isReady, label: {
                            Text("Готовность")
                                    .padding(.trailing)
                        })
                    }.frame(height: rowHeight)
                    HStack {
                        Spacer()

                        Text("Очередь:")
                                .help("Записывайте значения через пробелы")
                        TextField("00", text: $computer.externalDevices[number].queue,
                                onEditingChanged: { queueIsEditing[number] = $0 })
                                .lineLimit(1)
                                .frame(maxWidth: 135)
                                .textFieldStyle(UnderlinedTextFieldStyle(editing: $queueIsEditing[number], fieldHeight: rowHeight))
                                .padding(.trailing)
                    }.frame(height: rowHeight)

                    if number != 2 {
                        Divider()
                    }
                }
            }
        }
                .padding(.trailing)
                .frame(minWidth: 250, alignment: .topLeading)
    }
}

struct ExternalDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        ExternalDeviceView()
                .environmentObject(Computer())
    }
}
