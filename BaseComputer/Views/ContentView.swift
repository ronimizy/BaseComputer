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
                                    .help(computer.commandCounter.getValue().signed())
                                Text("PA:")
                                    .help(computer.addressRegister.value.signed())
                                Text("PK:")
                                    .help(computer.commandRegister.value.signed())
                                Text("РД:")
                                    .help(computer.dataRegister.value.signed())
                                Text("C:")
                                Text("A:")
                                    .help(computer.accumulator.value.signed())
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
                                    .help(computer.microCommandManager.microCommandCounter.getValue().signed())
                                Text("PMK:")
                                Text("БР:")
                                    .help(computer.microCommandManager.buffer.signed())
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
                                VStack {
                                    HStack(alignment: .center)
                                    {
                                        Text("ВУ-\(number+1)")
                                        Text("РД:")
                                        TextField("00", text: $computer.externalDevices[number].string)
                                            .frame(maxWidth: 40)
                                        Toggle(isOn: $computer.externalDevices[number].isReady, label: {
                                            Text("Готовность")
                                        })
                                    }
                                    HStack {
                                        Spacer()
                                        Text("Очередь:")
                                            .help("Записывайте значения через пробелы")
                                        TextField("00", text: $computer.externalDevices[number].queue)
                                            
                                            .frame(maxWidth: 135)
                                            .padding(.trailing)
                                    }
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
                                        .help("Наличие значения в регистре переноса")
                                })
                                .disabled(true)
                                Toggle(isOn: $computer.statusRegister.null, label: {
                                    Text("1 - Нуль")
                                        .help("Наличие значения в аккумуляторе")
                                })
                                .disabled(true)
                                Toggle(isOn: $computer.statusRegister.sign, label: {
                                    Text("2 - Знак")
                                        .help("Положительное ли число в аккумуляторе")
                                })
                                .disabled(true)
                                Toggle(isOn: $computer.statusRegister.zero, label: {
                                    Text("3 - Ноль")
                                        .help("Константный флаг, используется \nдля безусловных переходов МПУ")
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
                                        .help("Готово ли хотя бы одно ВУ")
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
