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
                                  onCommit: { defaultSize %= 2049 })
                            .textFieldStyle(UnderlinedTextFieldStyle(fieldHeight: settingsRowHeight))
                            .frame(width: 50)
                    }.frame(height: settingsRowHeight)
                    
                    HStack {
                        Text("Максимальная длина трассировки")
                        Spacer()
                        TextField(String(maxTracingLength), value: $maxTracingLength, formatter: NumberFormatter())
                            .textFieldStyle(UnderlinedTextFieldStyle(fieldHeight: settingsRowHeight))
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
