//
//  ProgramView.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 31.12.2020.
//

import SwiftUI
import Combine

struct ProgramView: View {
    @EnvironmentObject private var computer: Computer
    @State private var countToAdd = 0

    private static let cellHeight: CGFloat = 40
    private static let preload: CGFloat = 3

    var body: some View {
        GeometryReader { g in
            ScrollView {
                ScrollViewReader { s in
                    VStack(spacing: 0) {
                        BindingForEach($computer.program) { command in
                            RenderIfWillBeSeen(bounds: g, size: CGSize(width: g.size.width, height: ProgramView.cellHeight)) {
                                CommandCellView(commandCounter: $computer.commandCounter,
                                                start: $computer.program.start,
                                                command: command)
                            }
                        }
                        
                        if computer.program.commands.count < 2048 {
                            AddCommandsBarView(countToAdd: $countToAdd, cellHeight: ProgramView.cellHeight)
                        }
                    }.onAppear {
                        computer.offset = { (point: UnitPoint) in
                            s.scrollTo(Int(computer.commandCounter.value), anchor: point)
                        }
                        
                        computer.offset(.top)
                    }
                }
    

                Spacer()
            }.frame(width: g.size.width)
        }
    }
}
