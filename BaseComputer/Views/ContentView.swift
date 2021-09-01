//
//  ContentView.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 31.12.2020.
//

import SwiftUI

struct ContentView: View {
    @StateObject var computer = Computer()
    @State var isMicroProgramSelected = false

    @State var tracingToolsPresented = false
    @State var fileToolsPresented = false
    
    private let executionQueue = DispatchQueue(label: "com.ronimizy.execution", attributes: .concurrent)

    init(size: Int) {
        self._computer = StateObject(wrappedValue: Computer(size))
    }

    var body: some View {
        GeometryReader { g in
            HStack(alignment: .top) {
                if isMicroProgramSelected {
                    MicroProgramView()
                } else {
                    ProgramView()
                            .frame(width: 350)
                }

                HStack(alignment: .top, spacing: 5) {
                    VStack(alignment: .leading, spacing: 7) {
                        RegisterView()
                        Spacer()
                        StatusRegisterView()
                    }.frame(maxHeight: 450)

                    ExternalDeviceView()
                }.padding()
            }
                    .environmentObject(computer)
                    .toolbar {
                        ExecutionToolbarItemGroup(computer: _computer, mode: $isMicroProgramSelected, queue: executionQueue)

                        TracingToolbarItemGroup(computer: _computer, queue: executionQueue)

                        FileToolbarItemGroup(computer: _computer)
                    }
        }
    }
}
