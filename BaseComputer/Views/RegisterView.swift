//
//  RegisterView.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 31.12.2020.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject private var computer: Computer

    var body: some View {
        HStack(alignment: .top) {
            //MARK: Регистры БЭВМ
            HStack {
                VStack(alignment: .trailing, spacing: 5) {
                    Text("CK:")
                            .help(computer.commandCounter.value.signed())
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
                VStack(alignment: .leading, spacing: 5) {
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
                VStack(alignment: .trailing, spacing: 5) {
                    Text("СчМК:")
                            .help(computer.microCommandManager.microCommandCounter.value.signed())
                    Text("PMK:")
                    Text("БР:")
                            .help(computer.microCommandManager.buffer.value.signed())
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text(computer.microCommandManager.microCommandCounter.string)
                    Text(computer.microCommandManager.microCommandRegister.string)
                    Text(String(computer.microCommandManager.buffer.value, radix: 16).commandFormat())
                }
            }
                    .padding([.top, .trailing], 3)
                    .frame(minWidth: 100, alignment: .leading)

            Spacer()
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
                .environmentObject(Computer())
    }
}
