//
//  CommandCellView.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 22.10.2020.
//

import SwiftUI


struct CommandCellView: View {
    
    @EnvironmentObject var computer: Computer
    
    var number: Int

    init(_ number: Int) {
        self.number = number
    }
    
    var body: some View {
        GeometryReader { g in
            VStack {
                //Spacer()
                
                HStack {
                    Text(String(number, radix: 16).commandFormat(3))
                        .frame(width: g.size.width / 5)
                        .multilineTextAlignment(.leading)
                        .help(String(number))
                    
                    TextField("0000", text: $computer.program[number].string)
                        .frame(width: g.size.width/3)
                        .help(computer.program[number].value.signed())

                    Text(computer.program[number].mnemonics)
                        .frame(width: g.size.width/2.5, alignment: .center)
                        .help(computer.program[number].description)
                }
                
                //Spacer()
            }
            .frame(width: g.size.width, height: g.size.height)
            .border(number == computer.commandCounter.getValue() ? Color.blue : Color.clear)
        }
    }
}

struct CommandCellView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            ForEach(0..<3) { i in
                GeometryReader { g in
                    if i != 2 {
                        CommandCellView(i)
                            .padding(.vertical, 10)
                            .frame(height: 40)
                    } else {
                        EmptyView()
                            .padding(.vertical, 10)
                            .frame(height: 40)
                    }
                }
                .frame(height: 50)
            }
        }
        .environmentObject(Computer())
    }
}
