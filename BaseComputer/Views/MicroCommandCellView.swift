//
//  MicroCommandCellView.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 10.11.2020.
//

import SwiftUI

struct MicroCommandCellView: View {
    @EnvironmentObject var computer: Computer
    
    var number: Int

    init(_ number: Int = 0)
    {
        self.number = number
    }
    
    var body: some View
    {
        GeometryReader { g in
            HStack
            {
                Text(String(number, radix: 16).commandFormat(2))
                    .frame(width: g.size.width / 5)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 2)
                
                TextField("0000", text: $computer.microCommandManager.microCommandMemory[number].string) { (editing) in
                    ()
                } onCommit: {
                    computer.microCommandManager.microCommandMemory[number].string.commandFormat()
                }
                .frame(width: g.size.width/3)
                .frame(maxHeight: .infinity)

            }
            .frame(width: g.size.width, height: g.size.height)
            .border(number == computer.microCommandManager.microCommandCounter.getValue() ? Color.blue : Color.clear)
        }
    }
}

struct MicroCommandCellView_Previews: PreviewProvider {
    static var previews: some View {
        MicroCommandCellView()
    }
}
