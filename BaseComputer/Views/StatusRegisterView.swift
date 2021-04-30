//
//  StatusRegisterView.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 31.12.2020.
//

import SwiftUI

struct StatusRegisterView: View {
    @EnvironmentObject private var computer: Computer

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
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
            VStack(alignment: .leading) {
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

            Spacer()
        }
                .frame(minHeight: 320, alignment: .top)
    }
}

struct StatusRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        StatusRegisterView()
                .environmentObject(Computer())
    }
}
