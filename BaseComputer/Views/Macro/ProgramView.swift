//
//  ProgramView.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 31.12.2020.
//

import SwiftUI

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
                        ForEach(computer.program.commands, id: \.self.number) { command in
                            GeometryReader { cell in
                                CommandCellView(command,
                                        command.number == computer.commandCounter.value,
                                        completion: { computer.program[command.number] = $0 },
                                        setCommandCounter: { computer.commandCounter.value = $0 },
                                        setStart: { computer.program.start = $0 })
                                        .renderIfWillBeSeen(ProgramView.preload, viewGeometry: cell, generalGeometry: g)
                            }.frame(height: ProgramView.cellHeight)
                        }
                        if computer.program.commands.count < 2048 {
                            AddCommandsBarView(countToAdd: $countToAdd, cellHeight: ProgramView.cellHeight)
                        }
                    }.onAppear {
                        computer.offset = { (point: UnitPoint) in
                            s.scrollTo(Int(computer.commandCounter.value), anchor: point)
                        }
                    }
                }


                Spacer()
            }.frame(width: g.size.width)
        }
    }
}
