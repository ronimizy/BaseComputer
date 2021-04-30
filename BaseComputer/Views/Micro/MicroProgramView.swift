//
//  MicroProgramView.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 31.12.2020.
//

import SwiftUI

struct MicroProgramView: View {
    @EnvironmentObject private var computer: Computer

    private static let cellHeight: CGFloat = 40
    private static let preload: CGFloat = 3

    var body: some View {
        GeometryReader { g in
            ScrollView {
                ScrollViewReader { s in
                    VStack(spacing: 0) {
                        ForEach(computer.microCommandManager.microCommandMemory, id: \.self) { microCommand in
                            GeometryReader { cell in
                                MicroCommandCellView(microCommand,
                                        isSelected: microCommand.number == computer.microCommandManager.microCommandCounter.value
                                ) {
                                    computer.microCommandManager.microCommandMemory[microCommand.number] = $0
                                }
                                        .renderIfWillBeSeen(MicroProgramView.preload, viewGeometry: cell, generalGeometry: g)
                            }.frame(height: MicroProgramView.cellHeight)
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

struct MicroProgramView_Previews: PreviewProvider {
    static var previews: some View {
        MicroProgramView()
                .environmentObject(Computer())
    }
}
