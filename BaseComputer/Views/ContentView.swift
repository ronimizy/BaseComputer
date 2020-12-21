//
//  ContentView.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 22.10.2020.
//

import SwiftUI

struct ContentView: View
{
    
    @EnvironmentObject var computer: Computer
    @Binding var mode: Bool
    
    var cellHeight: CGFloat = 0
    var distance: CGFloat = 0
    var renderDistance: CGFloat = 0
    
    init(mode: Binding<Bool> = .constant(true))
    {
        self._mode = mode
        
        self.cellHeight = 20
    }
    
    var body: some View
    {
        GeometryReader { g in
            HStack(alignment: .top) {
                ScrollView(showsIndicators: false) {
                    
                    ScrollViewReader { s in
                        Spacer().frame(height: 2)
                        
                        let range: [ComputerCommand] = mode ? computer.microCommandManager.microCommandMemory : computer.program.commands;
                        
                        { () -> EmptyView in
                            computer.offset = { s.scrollTo(Int(mode
                                                                ? computer.microCommandManager.microCommandCounter.getValue()
                                                                : computer.commandCounter.getValue()),
                                                           anchor: .center) }
                            return EmptyView()
                        }()
                        
                        ForEach(range, id: \.self.number) { command in
                            GeometryReader { cell in
                                
                                let position = cell.frame(in: .global).minY;
                                
                                let displayed = position > -5 * cellHeight && position < g.size.height + 5 * cellHeight
                                
                                if displayed {
                                    if mode {
                                        MicroCommandCellView(command.number)
                                            .frame(height: cellHeight)
                                    } else {
                                        CommandCellView(command.number)
                                            .frame(height: cellHeight)
                                    }
                                } else {
                                    EmptyView()
                                        .frame(height: cellHeight)
                                }
                            }
                        }
                    }
                    
                    Spacer().frame(height: cellHeight)
                }
                .frame(width: g.size.width / (mode ? 2.3 : 3.5))
                .padding(.leading)
                
                
                //MARK: -Информация
                VStack {
                    
                    //MARK: Регистры и ВУ
                    HStack(alignment: .top) {
                        //MARK: Регистры БЭВМ
                        HStack {
                            VStack(alignment: .trailing)
                            {
                                Text("CK:")
                                Text("PA:")
                                Text("PK:")
                                Text("РД:")
                                Text("C:")
                                Text("A:")
                            }
                            VStack(alignment: .leading)
                            {
                                Text(computer.commandCounter.string)
                                Text(computer.addressRegister.string)
                                Text(computer.commandRegister.string)
                                Text(computer.dataRegister.string)
                                Text(computer.shift.string)
                                Text(computer.accumulator.string)
                            }
                        }
                        .padding([.top, .trailing], 3)
                        .frame(minWidth: 100, alignment: .leading)
                        
                        //MARK: Регистры МПУ
                        HStack {
                            VStack(alignment: .trailing)
                            {
                                Text("СчМК:")
                                Text("PMK:")
                                Text("БР:")
                            }
                            
                            VStack(alignment: .leading)
                            {
                                Text(computer.microCommandManager.microCommandCounter.string)
                                Text(computer.microCommandManager.microCommandRegister.string)
                                Text(String.init(computer.microCommandManager.buffer, radix: 16).commandFormat())
                            }
                        }
                        .padding([.top, .trailing], 3)
                        .frame(minWidth: 100, alignment: .leading)
                        
                        //MARK: Внешние устройства
                        VStack {
                            ForEach(0..<3) { number in
                                HStack(alignment: .center)
                                {
                                    Text("ВУ-\(number+1)")
                                    Text("РД:")
                                    TextField("000", text: $computer.externalDevices[number].string)
                                        .frame(maxWidth: 40)
                                    Toggle(isOn: $computer.externalDevices[number].isReady, label: {
                                        Text("Готовность")
                                    })
                                }
                            }
                        }
                        .padding(.trailing)
                        .frame(minWidth: 250, alignment: .topLeading)
                        
                        Spacer()
                    }
                    
                    HStack
                    {
                        //MARK: Флаги ЭВМ
                        VStack(alignment: .leading)
                        {
                            VStack(alignment: .leading)
                            {
                                Toggle(isOn: $computer.statusRegister.shift, label: {
                                    Text("0 - Перенос")
                                })
                                Toggle(isOn: $computer.statusRegister.null, label: {
                                    Text("1 - Нуль")
                                })
                                Toggle(isOn: $computer.statusRegister.sign, label: {
                                    Text("2 - Знак")
                                })
                                Toggle(isOn: $computer.statusRegister.zero, label: {
                                    Text("3 - Ноль")
                                })
                                .disabled(true)
                                Toggle(isOn: $computer.statusRegister.allowInterrupt, label: {
                                    Text("4 - Разрешение прерывания")
                                })
                                Toggle(isOn: $computer.statusRegister.interrupted, label: {
                                    Text("5 - Прерывание")
                                })
                                .disabled(!computer.statusRegister.allowInterrupt)
                            }
                            VStack(alignment: .leading)
                            {
                                Toggle(isOn: $computer.statusRegister.externalDevice, label: {
                                    Text("6 - Статус ВУ")
                                })
                                .disabled(true)
                                Toggle(isOn: $computer.statusRegister.working, label: {
                                    Text("7 - Остановка/Работа")
                                })
                                Toggle(isOn: $computer.statusRegister.program, label: {
                                    Text("8 - Программа")
                                })
                                .disabled(true)
                                Toggle(isOn: $computer.statusRegister.commandFetch, label: {
                                    Text("9 - Выборка команды")
                                })
                                .disabled(true)
                                Toggle(isOn: $computer.statusRegister.addressFetch, label: {
                                    Text("10 - Выборка адреса")
                                })
                                .disabled(true)
                                Toggle(isOn: $computer.statusRegister.execution, label: {
                                    Text("11 - Исполнение")
                                })
                                .disabled(true)
                                Toggle(isOn: $computer.statusRegister.IO, label: {
                                    Text("12 - Ввод-вывод")
                                })
                                .disabled(true)
                            }
                        }
                        .frame(minHeight: 320, alignment: .top)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                .padding()
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let mode = true
        
        ContentView(mode: .constant(mode)).environmentObject(Computer(10))
            .frame(width: mode ? 870 : 670, height: 450)
    }
}
