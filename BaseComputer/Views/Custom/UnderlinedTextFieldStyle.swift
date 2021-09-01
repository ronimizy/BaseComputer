//
//  UnderlinedTextFieldStyle.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 28.04.2021.
//

import SwiftUI

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get {
            .none
        }
        set {
        }
    }
}

struct UnderlinedTextFieldStyle: TextFieldStyle {
    @Binding private var editing: Bool
    private var fieldHeight: CGFloat

    init(editing: Binding<Bool>, fieldHeight: CGFloat) {
        self._editing = editing
        self.fieldHeight = fieldHeight
    }

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
                .textFieldStyle(PlainTextFieldStyle())
                .background(
                        VStack(alignment: .center) {
                            Spacer()
                                    .frame(height: fieldHeight * 0.5)

                            Rectangle()
                                    .fill(editing ? Color.blue : Color.secondary)
                                    .frame(height: 1)
                        }
                )
    }
}

struct UnderlinedTextFieldStyle_Previews: PreviewProvider {
    static var previews: some View {
        TextField("0", text: .constant("Str"))
                .textFieldStyle(UnderlinedTextFieldStyle(editing: .constant(true), fieldHeight: 50))
                .frame(height: 50)
                .padding()
    }
}
