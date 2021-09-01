//
//  BaseComputerApp.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 23.11.2020.
//

import SwiftUI

@main
struct BaseComputerApp: App {
    @AppStorage("default-size") private var defaultSize = 50
    @AppStorage("max-tracing-length") private var maxTracingLength: Int = 1024

    @State private var isSizeEditing = false
    @State private var isLengthEditing = false

    private var settingsRowHeight: CGFloat = 50

    var body: some Scene {
        WindowGroup {
            ContentView(size: Int(defaultSize))
                    .frame(minHeight: 600)
                    .frame(width: 890)
        }

        Settings {
            TabView {
                VStack {
                    HStack {
                        Text("Стандартный размер программы")
                        Spacer()
                        TextField(String(defaultSize), value: $defaultSize, formatter: NumberFormatter(),
                                onEditingChanged: { isSizeEditing = $0 },
                                onCommit: { defaultSize %= 2049 })
                                .textFieldStyle(UnderlinedTextFieldStyle(editing: $isSizeEditing,
                                        fieldHeight: settingsRowHeight))
                                .frame(width: 50)
                    }.frame(height: settingsRowHeight)

                    HStack {
                        Text("Максимальная длина трассировки")
                        Spacer()
                        TextField(String(maxTracingLength), value: $maxTracingLength, formatter: NumberFormatter(),
                                onEditingChanged: { isLengthEditing = $0 })
                                .textFieldStyle(UnderlinedTextFieldStyle(editing: $isLengthEditing,
                                        fieldHeight: settingsRowHeight))
                                .frame(width: 50)
                    }.frame(height: settingsRowHeight)

                    Spacer()
                }.tabItem {
                    Image(systemName: "tray.full.fill")
                    Text("Настройки")
                }
            }
                    .padding()
                    .frame(width: 350, height: 250)
        }
    }
}
